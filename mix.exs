defmodule Coap.Mixfile do
  use Mix.Project

  def project do
    [app: :coap,
     version: "0.0.1",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  def application do
    []
  end

  defp deps do
    [
      {:gen_coap, git: "https://github.com/gotthardp/gen_coap.git"},
      {:apex, "~> 1.0.0"}
    ]
  end
end
