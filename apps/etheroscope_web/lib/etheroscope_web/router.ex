defmodule EtheroscopeWeb.Router do
  use EtheroscopeWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", EtheroscopeWeb do
    pipe_through :api

    get "/search/", SearchController, :search

    get "/organisations/:organisation_name/", OrganisationController, :get

    get "/contracts/:contract_address/", ContractController, :get
    get "/contracts/:contract_address/history/", ContractController, :get_variable_history
  end
end
