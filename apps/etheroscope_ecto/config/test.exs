use Mix.Config

# Configure your database
config :etheroscope_ecto, EtheroscopeEcto.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "etheroscope_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
