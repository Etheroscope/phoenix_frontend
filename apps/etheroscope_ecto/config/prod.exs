use Mix.Config

config :etheroscope_ecto, EtheroscopeEcto.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "etheroscope_prod",
  hostname: "db",
  pool_size: 10

import_config "prod.secret.exs"
