use Mix.Config

# Configure your database
config :etheroscope_ecto, EtheroscopeEcto.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "etheroscope_dev",
  hostname: "db",
  pool_size: 10
