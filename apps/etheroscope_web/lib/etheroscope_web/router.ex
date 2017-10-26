defmodule EtheroscopeWeb.Router do
  use EtheroscopeWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", EtheroscopeWeb do
    pipe_through :api

    get "/history/:contract_address/:method", ContractController, :history
  end
end
