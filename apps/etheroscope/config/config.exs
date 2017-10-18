use Mix.Config

config :etheroscope,
  ecto_repos: [Etheroscope.Repo]

config :etheroscope, Etheroscope.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: System.get_env("POSTGRES_USER") || "postgres",
  password: System.get_env("POSTGRES_PASSWORD") || "postgres",
  hostname: System.get_env("POSTGRESQL_HOSTNAME") || "db",
  pool_size: 10

import_config "#{Mix.env}.exs"
