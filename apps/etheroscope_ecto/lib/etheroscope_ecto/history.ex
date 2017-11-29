defmodule EtheroscopeEcto.History do
  use Etheroscope.Util

  require EtheroscopeEcto
  alias Etheroscope.Cache.{Block, Contract}
  alias EtheroscopeEcto.Parity.VariableState

  def get([address: address, variable: variable]) do
    with {:ok, blocks}      <- Contract.get_block_numbers(address),
         {:ok, accum, vars} <- process_blocks(blocks, [], [], address, variable),
         {count, _}         <- VariableState.store_all(vars)
    do
      Logger.info "[DB] Stored #{count} variable states"
      {:ok, accum}
    else
      {:error, err, vars} ->
        {count, _} = VariableState.store_all(vars)
        Logger.info "[DB] Stored #{count} variable states before failing"
        {:error, err}
      resp = {:error, _err} -> resp
    end
  end

  defp process_blocks([], accum, variable_schemas, _address, _variable), do: {:ok, accum, variable_schemas}
  defp process_blocks([block | blocks], accum, variable_schemas, address, variable) do
    case VariableState.get_variable_state(address, variable, block) do
      {:ok, var} -> process_blocks(blocks, [%{value: var.value, time: var.time} | accum], [var | variable_schemas], address, variable)
      {:error, errors} -> {:error, ["No process: failed to proccess block #{block}" | errors], variable_schemas}
    end
  end

end
