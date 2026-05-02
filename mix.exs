defmodule Mystemex.MixProject do
  use Mix.Project

  def project do
    [
      app: :mystemex,
      version: "0.2.1",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps(),

      # Docs
      name: "Mystemex",
      description: "Elixir wrapper for Yandex Mystem 3 morphological analyzer",
      source_url: "https://github.com/dvolkow/mystemex",
      homepage_url: "https://github.com/dvolkow/mystemex",
      package: package(),
      docs: [
        main: "Mystemex",
        extras: ["README.md", "LICENSE"]
      ]
    ]
  end

  defp package do
    [
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/dvolkow/mystemex"}
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {Mystemex.Application, []}
    ]
  end

  defp deps do
    [
      {:poolboy, "~> 1.5"},
      {:jason, "~> 1.4.4"},
      {:ex_doc, "~> 0.40.1", only: :dev, runtime: false}
    ]
  end
end
