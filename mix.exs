defmodule Mystem.MixProject do
  use Mix.Project

  def project do
    [
      app: :mystem,
      version: "0.2.0",
      elixir: "~> 1.18",
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
      {:jason, "~> 1.4.4"}
    ]
  end
end
