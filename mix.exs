defmodule CID.MixProject do
  use Mix.Project

  @version "0.0.1"
  @source_url "https://github.com/nocursor/ex-cid"

  def project do
    [
      app: :cid,
      version: @version,
      elixir: ">= 1.7.0",
      start_permanent: Mix.env() == :prod,
      deps: deps(),

      # Hex
      description: "Elixir library for creating self-describing content-addressed identifiers for distributed systems (CIDs).",
      package: package(),

      # Docs
      source_url: @source_url,
      docs: docs()
    ]
  end

  def application do
    [
    ]
  end

  defp package do
    [
      maintainers: [
        "nocursor",
      ],
      licenses: ["MIT"],
      links: %{github: @source_url},
      files: ~w(lib NEWS.md LICENSE.md mix.exs README.md)
    ]
  end

  defp docs do
    [
      source_ref: "v#{@version}",
      main: "readme",
      extra_section: "PAGES",
      extras: extras(),
      groups_for_extras: groups_for_extras()
    ]
  end

  defp extras do
    [
      "README.md",
      "docs/FAQ.md",
    ]
  end

  defp groups_for_extras do
    [
    ]
  end

  defp deps do
    [
      {:benchee, "~> 0.13.2", only: [:dev]},
      {:dialyxir, "~> 1.0.0-rc.3", only: [:dev], runtime: false},
      {:ex_doc, "~> 0.13", only: [:dev], runtime: false},
      {:multibase, "~> 0.0.1"},
      {:multicodec, "~> 0.0.2"},
      {:basefiftyeight, "~> 0.1.0"},
      {:ex_multihash, "~> 2.0"},
      {:varint, "~> 1.2"},
    ]
  end
end
