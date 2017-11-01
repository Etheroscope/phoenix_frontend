use Mix.Config

config :ethereumex,
  scheme: "http",
  host: "cloud-vm-46-90",
  port: 8545

config :etheroscope,
  etherscan_api_key: "0000000000000" # Set this in backend-phoenix/config/local.exs

import_config "#{Mix.env}.exs"

local_config = "local.exs"
if (File.exists?(Path.join(Path.dirname(__ENV__.file), local_config))) do
  import_config local_config
end
