defmodule KGB.MixProject do
  use Mix.Project

  def project do
    [
      app: :kgb,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {KGB.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:crawly, "~> 0.11.0"},
      {:floki, "~> 0.26.0"},
      {:exop, "~> 1.4"},
      {:credo, "~> 1.4", only: [:dev, :test], runtime: false}
    ]
  end
end
