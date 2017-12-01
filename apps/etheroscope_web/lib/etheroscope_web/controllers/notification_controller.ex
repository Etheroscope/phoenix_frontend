defmodule EtheroscopeWeb.NotificationController do
  use EtheroscopeWeb, :controller

  defp notifier do
    Etheroscope.Notifier.Email
  end

  def subscribe(conn, params = %{"contract_address" => _addr, "variable" => _var, "email" => _email}) do
    params
    |> notifier().subscribe
    |> handle_response(conn)
  end
  def subscribe(conn, _) do
    conn
    |> put_status(400)
    |> json(%{})
  end

  def handle_response(resp, conn) do
    case resp do
      :ok ->
        json conn, %{result: "Request Accepted"}
      {:error, err} ->
        conn
        |> put_status(500)
        |> json(%{error: inspect(err)})
    end
  end
end
