defmodule EtheroscopeWeb.ContractController do
  use EtheroscopeWeb, :controller

  def contract(conn, %{"contract_address" => contract_address}) do
    case Etheroscope.fetch_contract_abi(contract_address) do
      {:ok, contract} ->
        json conn, %{abi: contract}
      {:error, err} ->
        put_status(conn, :internal_server_error)
        json conn, %{:error => err}
    end
  end

  @doc """
    Returns history status or result if done.
    Returns 404 if no history task running.
  """
  def get_history(conn, %{"contract_address" => contract_address, "variable" => variable}) do
    case Etheroscope.fetch_history_status(contract_address, variable) do
      nil ->
        put_status(conn, 404)
        json conn, %{error: "History not found", message: "Did you start the task?"}
      {:error, err} ->
        put_status(conn, :internal_server_error)
        json conn, %{:error => err}
      res ->
        json conn, Map.put(res, :result, "Success")
    end
  end

  @doc """
    Creates variable history task if none has run.
  """
  def post_history(conn, %{"contract_address" => contract_address, "variable" => variable}) do
    case Etheroscope.run_history_task(contract_address, variable) do
      {:ok, _pid} ->
        json conn, %{result: "Success"}
      {:found, _} ->
        put_status(conn, 202)
        json conn, %{result: "History status already cached."}
      {:error, err} ->
        put_status(conn, :internal_server_error)
        json conn, %{:error => err}
    end
  end
end
