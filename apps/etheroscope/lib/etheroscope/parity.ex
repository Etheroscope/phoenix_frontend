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
    filter_eth_id = addr
                  |> filter_params
                  |> Ethereumex.HttpClient.eth_new_filter

    EtheroscopeDB.write_filter(addr, %{"filter_id" => filter_eth_id})
  end

  def get_history(addr) do
    filter = case EtheroscopeDB.fetch_filter(addr) do
      {:error, err} -> setup_filter(addr)
      {:ok,   resp} -> {:ok, resp["filter_id"]}
    end
    get_filter_changes(filter)
  end

  defp get_filter_changes({:ok,    filter_id}), do: filter_id |> Ethereumex.HttpClient.eth_get_filter_changes
  defp get_filter_changes({:error, error_msg}) do
    raise "Error getting filter changes: #{error_msg}"
    []
  end
end
