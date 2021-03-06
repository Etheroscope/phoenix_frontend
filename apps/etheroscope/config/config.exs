use Mix.Config

config :etheroscope,
  etherscan_api_key: System.get_env("ETHERSCAN_API_KEY") || "0000000000000",
  email_notifier_url: "http://notifier.etheroscope.info"

# Configures Elixir's Logger
config :logger, :console,
  format: "$time [CORE] $metadata[$level] $message\n",
  metadata: [:request_id]

import_config "#{Mix.env}.exs"
