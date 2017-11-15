defmodule Etheroscope do
  @moduledoc """
  Etheroscope keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  alias EtheroscopeEth.Parity.{Contract, History}

  def fetch_contract_abi(address) do
    case EtheroscopeEcto.Parity.get_contract_abi(address) do
      nil ->
        contract_abi = Contract.fetch(address)
        EtheroscopeEcto.Parity.create_contract_abi(address: address, abi: contract_abi)
        {:ok, contract_abi}
      abi ->
        {:ok, abi}
    end
  end

end
