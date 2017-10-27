use Mix.Config

config :etheroscope_db,
  database: "etheroscope_prod"

import_config "prod.secret.exs"
