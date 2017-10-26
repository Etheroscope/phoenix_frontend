defmodule EtheroscopeWeb.ContractController do
  use EtheroscopeWeb, :controller

  def history(conn, %{"contract_address" => contract_address, "method" => method}) do
    history = Etheroscope.Contract.fetch_history(contract_address, method)
    render conn, :history, history
  end
end
