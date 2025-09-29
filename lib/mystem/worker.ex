defmodule Mystem.Worker do
  @worker_timeout 5_000
  @timeout_error "timeout has been exceed"

  require Logger

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts)
  end

  def init(_index) do
    port = Port.open({:spawn, "mystem --weight --format json -d -gi"}, [])
    Logger.debug("mystem worker has been started")
    {:ok, %{port: port}}
  end

  def handle_call(:get, _, state) do
    {:reply, state, state}
  end

  def handle_call({:analyze, text}, _, %{port: port} = state) do
    case receive_from(port, text) do
      {:ok, data} ->
        {:reply, {:ok, data}, state}

      {:exit_code, exit_code} ->
        {:reply, {:exit_code, exit_code}, state}

      {:error, _timeout} ->
        {:reply, {:error, @timeout_error}, state}
    end
  end

  def handle_call({:lemmatize, text}, _, %{port: port} = state) do
    resp =
      text
      |> String.split("\n", trim: true)
      |> Enum.map(fn s -> receive_from(port, s) end)
      |> Enum.filter(fn {a, _} -> a == :ok end)
      |> Enum.map(fn {_, data} ->
        data |> Enum.map(&get_lemma/1) |> Enum.filter(fn x -> x != nil end)
      end)
      |> List.flatten()

    {:reply, {:ok, resp}, state}
  end

  def handle_call({:lemmatize_one, text}, _, %{port: port} = state) do
    case receive_from(port, text) do
      {:ok, data} ->
        resp = data |> Enum.map(&get_lemma/1) |> Enum.filter(fn x -> x != nil end)
        {:reply, {:ok, resp}, state}

      {:exit_code, exit_code} ->
        {:reply, {:exit_code, exit_code}, state}

      {:error, _timeout} ->
        {:reply, {:error, @timeout_error}, state}
    end
  end

  defp receive_from(port, text) do
    Port.command(port, text <> "\n")

    receive do
      {^port, {:data, output}} ->
        {_, data} = Jason.decode(output)
        {:ok, data}

      {^port, {:exit_status, exit_code}} ->
        {:exit_code, exit_code}
    after
      @worker_timeout ->
        {:error, @worker_timeout}
    end
  end

  defp get_lemma(%{"analysis" => [], "text" => text}) do
    text
  end

  defp get_lemma(%{"analysis" => a, "text" => _}) do
    a |> hd |> Map.get("lex")
  end

  defp get_lemma(_), do: nil
end
