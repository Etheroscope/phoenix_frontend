defmodule EtheroscopeWeb.Router do
  use EtheroscopeWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", EtheroscopeWeb do
    pipe_through :api

    scope "/contracts:contract_address/" do
      get "/",                                            ContractController, :contract
      get "/history/:variable",                           ContractController, :get_history
      post "/history/:variable",                          ContractController, :post_history
      post "/history/:variable",                          ContractController, :post_history
      post "/history/:variable/subscribe/:email_address", NotificationController, :subscribe
    end

  end
end
