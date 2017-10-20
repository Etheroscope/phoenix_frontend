use Mix.Config

config :ethereumex,
  scheme: "http",
  host: "146.169.46.90",
  port: 8545

import_config "#{Mix.env}.exs"
