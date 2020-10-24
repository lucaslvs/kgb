defmodule KGB.MixProject do
  use Mix.Project

  def project do
    [
      app: :kgb,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      elixirc_paths: elixirc_paths(Mix.env())
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {KGB.Application, []}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:crawly, "~> 0.11.0"},
      {:floki, "~> 0.26.0"},
      {:exop, "~> 1.4"},
      {:credo, "~> 1.4", only: [:dev, :test], runtime: false},
      {:ex_machina, "~> 2.4", only: :test}
    ]
  end
end
