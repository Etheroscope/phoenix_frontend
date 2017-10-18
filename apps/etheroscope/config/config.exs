use Mix.Config

config :etheroscope, Etheroscope.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "etheroscope_repo",
  username: "user",
  password: "pass",
  hostname: "localhost"


config :etheroscope,
  ecto_repos: [Etheroscope.Repo]

import_config "#{Mix.env}.exs"
