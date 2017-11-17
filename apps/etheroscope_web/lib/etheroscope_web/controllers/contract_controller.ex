defmodule EtheroscopeWeb.ContractController do
  use EtheroscopeWeb, :controller

  def contract(conn, %{"contract_address" => contract_address}) do
    case Etheroscope.fetch_contract_abi(contract_address) do
      {:ok, contract} -> json conn, %{abi: contract}
      {:error, err} ->
        Etheroscope.Util.Error.put_error_message(err)
        put_status(conn, :internal_server_error)
        json conn, %{:error => err}
    end
  end

  def history(conn, %{"contract_address" => contract_address}) do
    # case Etheroscope.fetch_history(contract_address) do
    #   {:ok, history} -> json conn, history
    #   {:error, msg} ->
    #     put_status(conn, :internal_server_error)
    #     json conn, %{:error => "An error occured fetching the contract: #{msg}"}
    # end
  end
end
