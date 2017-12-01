defmodule EtheroscopeWeb.NotificationController do
  use EtheroscopeWeb, :controller

  defp notifier do
    Etheroscope.Notifier.Email
  end

  def subscribe(conn, %{"contract_address" => addr, "variable" => var, "email_address" => email}) do
    notifier().subscribe(email, addr, var)
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
