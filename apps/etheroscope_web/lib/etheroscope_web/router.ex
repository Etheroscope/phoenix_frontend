defmodule EtheroscopeWeb.Router do
  use EtheroscopeWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", EtheroscopeWeb do
    pipe_through :api

    get "/contracts/:contract_address/",                   ContractController, :contract
    get "/contracts/:contract_address/variables",          ContractController, :get_variables
    get "/contracts/:contract_address/history/:variable",  ContractController, :get_history
    post "/contracts/:contract_address/history/:variable", ContractController, :post_history

  end
end
