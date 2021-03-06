defmodule VerandertesLeben.MixProject do
  use Mix.Project

  def project do
    [
      app: :verandertes_leben,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {VerandertesLeben.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:credo, ">= 0.0.0", only: [:dev, :test]},
      {:plug, "~> 1.7"},
      {:cowboy, "~> 2.8"},
      {:plug_cowboy, ">= 2.4.0"},
      {:jason, "~> 1.1"},
      {:hackney, "~> 1.17"},
      {:tesla, "~> 1.4"}
    ]
  end
end
