defmodule EtheroscopeDB.Mixfile do
  use Mix.Project

  def project do
    [
      app: :etheroscope_db,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :couchdb_connector],
      mod: {EtheroscopeDB.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:couchdb_connector, "~> 0.5.0"}
    ]
  end

  defp aliases do
    [
      # "couchdb.create": ["run lib/tasks/couchdb.create.exs"]
      # "couchdb.setup":  ["couchdb.create"]
    ]
  end
end
