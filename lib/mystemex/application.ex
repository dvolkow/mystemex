defmodule Mystemex.Application do
  use Application
  require Logger

  @impl true
  def start(_type, _args) do
    children = [
      Mystemex.Pool
    ]

    opts = [strategy: :one_for_one, name: Mystemex.Supervisor]
    Logger.debug("Mystemex start...")
    Supervisor.start_link(children, opts)
  end

  @impl true
  def stop(_state) do
    Logger.debug("Mystemex has been stopped")
  end
end
