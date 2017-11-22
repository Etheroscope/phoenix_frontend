defmodule Etheroscope.Util.Parity do
  @moduledoc """
    EtheroscopeEth.Util.Parity is used to support all other Parity handling modules.
  """
  alias EtheroscopeEcto.Parity.{Block, VariableState}
  alias Etheroscope.Util.{Error, Hex}

  @valid_filter_params ["fromBlock", "toBlock", "fromAddress", "toAddress"]
  @allowed_types ["uint", "uint8", "uint16", "uint32", "uint64", "uint128", "uint256", "int", "int8", "int16", "int32", "int64", "int128", "int256"]

  def abi_variables(abi) do
    filter_abi_variables(abi, [])
  end

  defp filter_abi_variables([%{
                               "type" => "function",
                               "inputs" => [],
                               "outputs" => [%{"type" => type}],
                               "name" => name
                              } | abi], vars) when type in @allowed_types do
    filter_abi_variables(abi, [name | vars])
  end
  defp filter_abi_variables([_ | abi], vars), do: filter_abi_variables(abi, vars)
  defp filter_abi_variables([], vars), do: vars

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

  def process_blocks([], accum, _address, _variable) do
    {:ok, accum}
  end
  def process_blocks([block | blocks], accum, address, variable) do
    with {:ok, var}  <- VariableState.fetch_variable_state(address, variable, block),
         {:ok, time} <- Block.fetch_block_time(block)
    do
      process_blocks(blocks, [%{value: var.value, time: time} | accum], address, variable)
    else
      {:error, errors} ->
        Error.build_error_core(errors, "No process: failed to proccess block #{block |> Hex.to_hex}")
    end
  end
end
