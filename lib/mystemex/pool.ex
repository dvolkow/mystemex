defmodule Mystemex.Pool do
  @moduledoc false
  #
  # Provides a pool of workers to handle user requests.

  use Supervisor
  @pool_query_timeout 10_000

  alias Mystemex.Types

  def start_link(_opts) do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  @impl true
  def init(_) do
    pool_options = [
      name: {:local, :mystemex_pool},
      worker_module: Mystemex.Worker,
      size: Application.get_env(:mystemex, :pool_size),
      max_overflow: Application.get_env(:mystemex, :pool_max_overflow)
    ]

    children = [
      :poolboy.child_spec(:mystemex_pool, pool_options, [])
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

  @doc """
  Pool Interface. This is where we send requests to mystem.
  """
  @spec query(Types.query_type()) :: Types.responses()
  def query(query) do
    :poolboy.transaction(
      :mystemex_pool,
      fn worker ->
        GenServer.call(worker, query)
      end,
      @pool_query_timeout
    )
  end
end
