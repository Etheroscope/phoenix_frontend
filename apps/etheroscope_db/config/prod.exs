use Mix.Config

config :etheroscope_ecto, EtheroscopeEcto.Repo,
  database: "etheroscope_prod",

import_config "prod.secret.exs"
