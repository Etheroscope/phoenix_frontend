defmodule EtheroscopeWeb.ContractController do
  use EtheroscopeWeb, :controller

  def history(conn, %{"contract_address" => contract_address, "method" => method}) do
    render conn, :history, %{contract_address: contract_address, method: method}
  end
end
