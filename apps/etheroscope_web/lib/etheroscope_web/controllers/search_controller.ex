defmodule EtheroscopeWeb.SearchController do
  use EtheroscopeWeb, :controller

  def search(conn, %{"query" => query}) do
    case Etheroscope.Search.search(query) do
      {:ok, results} -> json conn, results
      {:error, _msg} ->
        put_status(conn, :internal_server_error)
        json conn, %{:error => "An error occured fetching the contract."}
    end
  end

end
