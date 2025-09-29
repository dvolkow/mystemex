defmodule Mystem.MixProject do
  use Mix.Project

  def project do
    [
      app: :mystem,
      version: "0.1.0",
      elixir: "~> 1.18-dev",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {Mystem.Application, []}
    ]
  end

  defp deps do
    [
      {:poolboy, "~> 1.5"},
      {:jason, "~> 1.1.2"}
    ]
  end
end
