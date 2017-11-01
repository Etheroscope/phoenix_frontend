defmodule EtheroscopeWeb.ContractController do
  use EtheroscopeWeb, :controller

  def contract(conn, %{"contract_address" => contract_address}) do
    json conn, Etheroscope.Contract.fetch_contract(contract_address)
  end

  def history(conn, %{"contract_address" => contract_address, "variable" => variable}) do
    json conn, Etheroscope.Contract.fetch_history(contract_address, variable)
  end
end
