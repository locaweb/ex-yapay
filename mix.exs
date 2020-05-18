defmodule ExYapay.MixProject do
  use Mix.Project

  @version "1.0.0"
  @repo_url "https://github.com/locaweb/ex-yapay"

  def project do
    [
      app: :ex_yapay,
      deps: deps(),
      elixir: "~> 1.10",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      version: @version,

      # Hex
      description: "Elixir client that integrates with Yapay.
",
      package: package(),

      # Docs
      name: "ExYapay",
      docs: docs()
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
      {:ex_doc, "~> 0.21", only: :dev, runtime: false},
      {:ex_machina, "~> 2.4", only: :test},
      {:httpotion, "~> 3.1"},
      {:jason, "~> 1.2"},
      {:mox, "~> 0.5", only: :test}
    ]
  end

  defp package do
    [
      maintainers: ["Locaweb"],
      licenses: ["MIT"],
      links: %{"GitHub" => @repo_url}
    ]
  end

  defp docs do
    [
      extras: ["README.md", "LICENSE.md", "CONTRIBUTING.md"],
      main: "ExYapay",
      source_ref: "v#{@version}",
      source_url: @repo_url
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]
end
