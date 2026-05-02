defmodule Mystemex.Worker do
  @moduledoc """
  A worker instance for the pool. User request handlers are implemented here.
  Each instance runs a binary mystem as port and monitor its.
  """

  @worker_timeout 5_000
  @timeout_error "timeout has been exceed"

  require Logger

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts)
  end

  def init(_index) do
    mystem_path = Application.fetch_env!(:mystemex, :mystem_path) |> Path.expand()

    with true <- File.exists?(mystem_path),
         port_pid <-
           Port.open({:spawn, "#{mystem_path} --weight --format json -d -gi"}, [
             :binary,
             :exit_status
           ]),
         res when is_reference(res) <- Port.monitor(port_pid) do
      Logger.debug("mystemex worker has been started")

      {:ok, port_pid}
    else
      false ->
        Logger.error("Install mystem binaries or setup mystem_path")
        {:error, "invalid mystem_path"}
    end
  end

  def handle_call(:get, _, port) do
    {:reply, port, port}
  end

  def handle_call({:analyze, text}, _, port) do
    case receive_from(port, text) do
      {:ok, data} ->
        {:reply, {:ok, data}, port}

      {:exit_code, exit_code} ->
        {:reply, {:exit_code, exit_code}, port}

      {:error, :timeout} ->
        {:reply, {:error, @timeout_error}, port}
    end
  end

  def handle_call({:lemmatize, text}, _, port) when is_binary(text) do
    resp =
      text
      |> String.split("\n", trim: true)
      |> Enum.map(fn s -> receive_from(port, s) end)
      |> Enum.filter(fn {a, _} -> a == :ok end)
      |> Enum.map(fn {_, data} ->
        data |> Enum.map(&get_lemma/1) |> Enum.filter(fn x -> x != nil end)
      end)
      |> List.flatten()

    {:reply, {:ok, resp}, port}
  end

  def handle_call({:lemmatize, _}, _, port) do
    {:reply, {:error, "bad type of text"}, port}
  end

  def handle_call({:lemmatize_word, text}, _, port) do
    case receive_from(port, text) do
      {:ok, data} ->
        resp =
          case data |> Enum.map(&get_lemma/1) |> Enum.filter(fn x -> x != nil end) do
            [w] when is_binary(w) -> {:ok, w}
            [w | _] when is_binary(w) -> {:ok, w}
            [] -> {:ok, ""}
            _ -> {:error, "lemmatize_word failed"}
          end

        {:reply, resp, port}

      {:exit_code, exit_code} ->
        {:reply, {:exit_code, exit_code}, port}

      {:error, :timeout} ->
        {:reply, {:error, @timeout_error}, port}
    end
  end

  def handle_info({_, {:exit_status, status}}, port) do
    Logger.error("port has been failed: #{status}")
    {:stop, status, port}
  end

  def handle_info(message, port) do
    Logger.warning("unknown mystem port message: #{inspect(message)}")
    {:noreply, port}
  end

  @spec receive_from(port(), String.t()) ::
          {:ok, String.t()} | {:exit_code, number()} | {:error, :timeout}
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
        {:error, :timeout}
    end
  end

  @spec get_lemma(map()) :: nil | binary()
  defp get_lemma(%{"analysis" => [], "text" => text}) do
    text
  end

  defp get_lemma(%{"analysis" => a, "text" => _}) do
    a |> hd |> Map.get("lex")
  end

  defp get_lemma(_), do: nil
end
