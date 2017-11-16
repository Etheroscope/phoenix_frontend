defmodule EtheroscopeWeb.ContractController do
  use EtheroscopeWeb, :controller

  def get(conn, %{"contract_address" => contract_address}) do
    case Etheroscope.Contract.fetch_contract(contract_address) do
      {:ok, contract} -> json conn, contract
      {:error, _msg} ->
        put_status(conn, :internal_server_error)
        json conn, %{:error => "An error occured fetching the contract."}
    end
  end

  def get_variable_history(conn, %{"contract_address" => contract_address}) do
    case Etheroscope.Contract.fetch_history(contract_address) do
      {:ok, history} -> json conn, history
      {:error, _msg} ->
        put_status(conn, :internal_server_error)
        json conn, %{:error => "An error occured fetching the contract."}
    end
  end
end
