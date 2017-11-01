defmodule Etheroscope.Parity do
  @moduledoc """
  Etheroscope.Parity is the wrapper for the EthereumEx library to faciliate
  interactions with the node.
  """

  def get_contract(addr) do
    # CHANGE
    json = "../../support/contract_template.json"
      |> File.read!
      |> Poison.decode
    json["result"]
  end

end
