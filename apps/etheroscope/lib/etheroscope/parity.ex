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

  defp filter_params(addr) do
    start_block = Integer.to_charlist(Ethereumex.HttpClient.eth_block_number - 150000, 16)
    %{
      "fromBlock" => "0x#{start_block}",
      "toAddress" => [addr]
    }
  end

  def get_history(addr) do
    start_time  = DateTime.utc_now()
    start_block = Ethereumex.HttpClient.eth_block_number - 150000

    IO.puts "From block: #{start_block}"

    IO.puts Ethereumex.HttpClient.eth_new_filter(filter_params(addr))
  end

end
