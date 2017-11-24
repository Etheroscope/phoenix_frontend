defmodule EtheroscopeEcto.History do
  use Etheroscope.Util

  require EtheroscopeEcto
  alias Etheroscope.Cache.Block
  alias EtheroscopeEcto.Parity.{Contract, VariableState}

  def get([address: address, variable: variable]) do
    case Contract.get_block_numbers(address) do
      {:ok, blocks}         ->
        process_blocks(blocks, [], address, variable)
      resp = {:error, _err} -> resp
    end
  end

  defp process_blocks([], accum, _address, _variable), do: {:ok, accum}
  defp process_blocks([block | blocks], accum, address, variable) do
    with {:ok, var}  <- VariableState.get_variable_state(address, variable, block),
         {:ok, time} <- Block.get_time(block)
    do
      Logger.info "[CORE] Processing: block #{time} var #{var.value}"
      process_blocks(blocks, [%{value: var.value, time: time} | accum], address, variable)
    else
      {:error, errors} ->
        Error.build_error_core(errors, "No process: failed to proccess block #{block}")
    end
  end

end
