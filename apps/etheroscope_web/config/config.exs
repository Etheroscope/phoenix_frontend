# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :etheroscope_web,
  namespace: EtheroscopeWeb

# Configures the endpoint
config :etheroscope_web, EtheroscopeWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "D8bWJP+B2Pdwh+neZBBU5c2nt6Qme6a0PUnCG6tzZhJn009ga6MD1/0ztIw3Uam0",
  pubsub: [name: EtheroscopeWeb.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :etheroscope_web, :generators,
  context_app: :etheroscope

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
