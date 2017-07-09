defmodule Depz.Mixfile do
  use Mix.Project

  def project do
    [
      app: :depz,
      version: "0.1.0",
      elixir: "~> 1.4",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        "coveralls": :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test,
      ],
    ]
  end


  def application do
    [
      extra_applications: [:logger, :httpc]
    ]
  end


  defp deps do
    [
      {:poison, "~> 3.1.0"},
      {:mix_test_watch, "~> 0.4.1", [only: :dev, runtime: false]},
      {:excoveralls, "~> 0.7.1", [only: :test]},
    ]
  end
end
