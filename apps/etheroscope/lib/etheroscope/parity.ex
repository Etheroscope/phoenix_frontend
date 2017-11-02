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
    IO.puts "From block: #{start_block}"
    %{
      "fromBlock" => "0x#{start_block}",
      "toAddress" => [addr]
    }
  end

  def setup_filter(addr) do
    filter_db_id  = Etheroscope.hash_code(:history_filter, addr)
    filter_eth_id = addr
                  |> filter_params
                  |> Ethereumex.HttpClient.eth_new_filter

    EtheroscopeDB.write(filter_db_id, %{"filter_id" => filter_eth_id})
  end

  def get_history(addr) do
    case EtheroscopeDB.fetch_filter(addr) do
      {:ok,   resp} ->
        resp["filter_id"] |> Ethereumex.HttpClient.eth_get_filter_changes
      {:error, err} ->
        setup_filter(add)
        # get_history(addr) again?
    end
  end

end
