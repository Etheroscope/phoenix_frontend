defmodule EtheroscopeWeb.ContractController do
  use EtheroscopeWeb, :controller

  def contract(conn, %{"contract_address" => contract_address}) do
    case Etheroscope.fetch_contract_abi(contract_address) do
      {:ok, contract = %EtheroscopeEcto.Parity.Contract{}} ->
        json conn, contract
      :not_found ->
        conn
        |> put_status(404)
        |> json(%{error: "Not Found."})
      {:error, err} ->
        conn
        |> put_status(:internal_server_error)
        |> json(%{:error => inspect(err)})
      other ->
        conn
        |> put_status(:internal_server_error)
        |> json(%{:error => inspect(other)})
    end
  end

  @doc """
    Returns history status or result if done.
    Returns 404 if no history task running.
  """
  def get_history(conn, %{"contract_address" => contract_address, "variable" => variable}) do
    case Etheroscope.fetch_history_status(contract_address, variable) do
      {:ok, data} ->
        conn
        |> json(%{data: data})
      {:error, :not_found} ->
        conn
        |> put_status(422)
        |> json(%{:error => "Error with contract address or variable name."})
      {:error, err} ->
        conn
        |> put_status(:internal_server_error)
        |> json(%{:error => inspect(err)})
      nil ->
        conn
        |> put_status(404)
        |> json(%{})
      {status, data} ->
        conn
        |> put_status(503)
        |> json(%{status: status, data: data})
      status ->
        conn
        |> put_status(:internal_server_error)
        |> json(%{:error => inspect(status)})
    end
  end

  @doc """
    Creates variable history task if none has run.
  """
  def post_history(conn, %{"contract_address" => contract_address, "variable" => variable}) do
    case Etheroscope.run_history_task(contract_address, variable) do
      {:ok, _pid} ->
        conn
        |> put_status(201)
        |> json(%{result: "Request Accepted"})
      {:found, _} ->
        conn
        |> put_status(204)
        |> json(%{result: "Request Already Submitted"})
      {:error, err} ->
        conn
        |> put_status(:internal_server_error)
        |> json(%{:error => err})
    end
  end
end
