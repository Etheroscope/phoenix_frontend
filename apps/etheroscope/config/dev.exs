use Mix.Config

config :etheroscope, Etheroscope.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "etheroscope_env"
