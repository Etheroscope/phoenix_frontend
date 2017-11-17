use Mix.Config

config :etheroscope_ecto, EtheroscopeEcto.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: System.get_env("POSTGRES_USERNAME"),
  password: System.get_env("POSTGRES_PASSWORD"),
  database: "etheroscope_prod",
  hostname: "40.71.225.99",
  pool_size: 10

import_config "prod.secret.exs"
