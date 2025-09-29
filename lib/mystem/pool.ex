defmodule Mystem.Pool do
  use Supervisor
  @pool_query_timeout 10_000

  def start_link(_opts) do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  @impl true
  def init(_) do
    pool_options = [
      name: {:local, :mystem_pool},
      worker_module: Mystem.Worker,
      size: Application.get_env(:mystem, :pool_size),
      max_overflow: Application.get_env(:mystem, :pool_max_overflow)
    ]

    children = [
      :poolboy.child_spec(:mystem_pool, pool_options, [])
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

  def query(query) do
    :poolboy.transaction(
      :mystem_pool,
      fn worker ->
        GenServer.call(worker, query)
      end,
      @pool_query_timeout
    )
  end
end
