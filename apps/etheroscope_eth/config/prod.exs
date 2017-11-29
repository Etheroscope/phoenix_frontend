use Mix.Config

config :ethereumex,
  scheme: "http",
  host: System.get_env("ETHERSCAN_API_KEY"),
  port: 8545,
  timeout: :infinity
