defmodule EtheroscopeEcto.History do
  use Etheroscope.Util

  require EtheroscopeEcto
  alias Etheroscope.Cache.Contract
  alias EtheroscopeEcto.Parity.VariableState
  alias Etheroscope.Cache.History

  def get([address: address, variable: variable]) do
    case Contract.get_block_numbers(address) do
      {:ok, new_blocks} ->
        Logger.info "[CORE] NEW BLOCKS ARE #{inspect(new_blocks)}"
        History.start_process_status(self(), length(new_blocks))
        # Store all processed blocks
        vars = new_blocks
        |> process_blocks(address, variable)

        Logger.info "[CORE] PROCESSED ALL BLOCKS"
        Logger.info(inspect(vars))
        VariableState.store_all(vars, address)
        History.finish_process_status(self())

        VariableState.fetch_all_variable_states(address, variable)
      resp = {:error, _err} ->
        resp
    end
  end

  defp process_blocks(blocks, address, variable) do
    Enum.map(blocks, fn (block) ->
      Logger.info "[CORE] PROCESSING #{block}"
      History.update_process_status(self(), 1)
      VariableState.get_variable_state(address, variable, block)
    end)
  end

end
