defmodule Mystem.Application do
  use Application
  require Logger

  @impl true
  def start(_type, _args) do
    children = [
      Mystem.Pool
    ]

    opts = [strategy: :one_for_one, name: Mystem.Supervisor]
    Logger.debug("Mystem start...")
    Supervisor.start_link(children, opts)
  end

  @impl true
  def stop(_state) do
    Logger.debug("Mystem has been stopped")
  end
end
