defmodule EtheroscopeWeb.ContractController do
  use EtheroscopeWeb, :controller

  def contract(conn, %{"contract_address" => contract_address}) do
    case Etheroscope.fetch_contract_abi(contract_address) do
      {:ok, contract} -> json conn, %{abi: contract}
      {:error, err} ->
        put_status(conn, :internal_server_error)
        json conn, %{:error => err}
    end
  end

  @doc """
    Returns status of a task. PID should be of the format: "<#PID"
  """
  def status(conn, %{"pid" => pid}) do
    case Etheroscope.fetch_task_status(pid) do
      nil ->
        put_status(conn, 404)
        json conn, %{error: "Task not found", message: "Did you start the task?"}
      res ->
        json conn, Map.put(res, :result, "Success")
    end
  end

  @doc """
    Creates task to fetch variable history.
  """
  def history(conn, %{"contract_address" => contract_address, "variable" => variable}) do
    case Etheroscope.fetch_variable_history(contract_address, variable) do
      {:ok, _pid} ->
        json conn, %{result: "Success"}
      {:error, err} ->
        put_status(conn, :internal_server_error)
        json conn, %{:error => err}
    end
  end
end
