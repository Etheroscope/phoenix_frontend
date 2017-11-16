defmodule EtheroscopeWeb.OrganisationController do
  use EtheroscopeWeb, :controller

  def get(conn, %{"organisation_name" => organisation_name}) do
    case Etheroscope.Organisation.fetch_organisation(organisation_name) do
      {:ok, organisation} -> json conn, organisation
      {:error, _msg} ->
        put_status(conn, :internal_server_error)
        json conn, %{:error => "An error occured fetching the organisation."}
    end
  end

end
