use Mix.Config

config :etheroscope_ecto, ecto_repos: [EtheroscopeEcto.Repo]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time [ECTO] $metadata[$level] $message\n",
  metadata: [:request_id]

import_config "#{Mix.env}.exs"
