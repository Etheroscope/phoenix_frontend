defmodule Etheroscope.Util.Parity do
  @moduledoc """
    EtheroscopeEth.Util.Parity is used to support all other Parity handling modules.
  """

  @valid_filter_params ["fromBlock", "toBlock", "fromAddress", "toAddress"]

  @spec block_numbers(nonempty_list()) :: MapSet.t()
  def block_numbers(transactions), do: filter_block_numbers(MapSet.new, transactions)

  defp filter_block_numbers(set, [%{"blockNumber" => blockNumber} | ts]) do
    set
      |> MapSet.put(blockNumber)
      |> filter_block_numbers(ts)
  end
  defp filter_block_numbers(set, []), do: set

  @spec validate_filter_params(map()) :: boolean
  def validate_filter_params(params), do: is_valid_param(Map.keys(params))

  defp is_valid_param([]), do: true
  defp is_valid_param([p | ps]) when p in @valid_filter_params, do: is_valid_param(ps)
  defp is_valid_param(_),  do: false
end
