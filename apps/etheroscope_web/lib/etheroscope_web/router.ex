defmodule EtheroscopeWeb.Router do
  use EtheroscopeWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", EtheroscopeWeb do
    pipe_through :api

    get "/contracts/:contract_address/",                   ContractController, :contract
    get "/status/:pid",                                    ContractController, :status
    post "/contracts/:contract_address/history/:variable", ContractController, :history
  end
end
