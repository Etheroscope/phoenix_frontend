use Mix.Config

config :etheroscope,
  etherscan_api_key: "0000000000000" # Set this in backend-phoenix/config/local.exs

import_config "#{Mix.env}.exs"
