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

  def history(conn, %{"contract_address" => contract_address, "variable" => variable}) do
    case Etheroscope.fetch_variable_history(contract_address, variable) do
      {:ok, pid} ->
        json conn, %{result: "Success", pid: pid}
      {:error, err} ->
        put_status(conn, :internal_server_error)
        json conn, %{:error => err}
    end
  end
end
