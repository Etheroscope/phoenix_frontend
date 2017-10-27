defmodule EtheroscopeWeb.ContractView do
  use EtheroscopeWeb, :view

  def render("history.json", %{contract_address: contract_address, method: method}) do
    %{
      contract_address: contract_address,
      method: method
    }
  end
end
