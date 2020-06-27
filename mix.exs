defmodule NosbyteProxy.MixProject do
  use Mix.Project

  def project do
    [
      app: :nosbyte_proxy,
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
      mod: {NosbyteProxy.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:confex, "~> 3.4"},
      {:ranch, "~> 1.7"},
      {:edeliver, "~> 1.8"},
      {:distillery, "~> 2.1", runtime: false}
    ]
  end
end
