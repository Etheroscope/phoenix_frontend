defmodule EtheroscopeWeb.Router do
  use EtheroscopeWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", EtheroscopeWeb do
    pipe_through :api

    get "/contracts/:contract_address/",                   ContractController, :contract
    post "/contracts/:contract_address/history/:variable", ContractController, :history

    get "/contracts/:contract_address/history/:variable/status", ContractController, :status
  end
end
