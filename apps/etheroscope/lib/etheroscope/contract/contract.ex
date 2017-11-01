defmodule Etheroscope.Contract do
#  alias Etheroscope.Contract

  def fetch_contract(contract_address) do
    %{
      :test => "Hello world (contract)",
      :contract_address => contract_address
    }
  end

  def fetch_history(contract_address, variable) do
    %{
      :test => "Hello world (history)",
      :contract_address => contract_address,
      :variable => variable
    }
  end
end
