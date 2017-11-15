defmodule Etheroscope do
  @moduledoc """
  Etheroscope keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  alias EtheroscopeEth.Parity.{Contract, History}

  def fetch_contract_abi(address) do
    with nil                 <- EtheroscopeEcto.Parity.get_contract_abi(address),
         {:ok, contract_abi} <- Contract.fetch(address)
         # variables            = Enum.filter(&abi_item_is_variable/1)
    do
      EtheroscopeEcto.Parity.create_contract_abi(%{address: address, abi: contract_abi})
      {:ok, contract_abi}
    else
      abi ->
        {:ok, abi}
    end
  end

end
