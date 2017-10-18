use Mix.Config

config :etheroscope, Etheroscope.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "etheroscope_prod"

import_config "prod.secret.exs"
