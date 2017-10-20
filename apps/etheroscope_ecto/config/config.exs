use Mix.Config

config :etheroscope_ecto, ecto_repos: [EtheroscopeEcto.Repo]

import_config "#{Mix.env}.exs"
