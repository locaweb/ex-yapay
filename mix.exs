defmodule Yapay.MixProject do
  use Mix.Project

  def project do
    [
      app: :yapay,
      version: "0.4.2",
      elixir: "~> 1.10",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:bypass, "~> 1.0", only: :test},
      {:credo, "~> 1.4", only: [:dev, :test], runtime: false},
      {:ex_machina, "~> 2.4", only: :test},
      {:httpotion, "~> 3.1"},
      {:jason, "~> 1.2"},
      {:mox, "~> 0.5", only: :test}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]
end
