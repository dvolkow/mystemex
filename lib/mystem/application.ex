defmodule Mystem.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Mystem.Pool
    ]

    opts = [strategy: :one_for_one, name: Mystem.Supervisor]
    IO.puts("Mystem[Ex] start...")
    Supervisor.start_link(children, opts)
  end

  @impl true
  def stop(_state) do
    IO.puts("Mystem[Ex] has been stopped.")
  end
end
