defmodule EtheroscopeEcto.History do
  use Etheroscope.Util

  require EtheroscopeEcto
  alias Etheroscope.Cache.Contract
  alias EtheroscopeEcto.Parity.VariableState
  alias Etheroscope.Cache.History

  def get([address: address, variable: variable]) do
    case Contract.get_block_numbers(address) do
      {:ok, new_blocks} ->
        Logger.info "NEW BLOCKS ARE #{inspect(new_blocks)}"
        History.start_process_status(self(), length(new_blocks))
        # Store all processed blocks
        vars = process_blocks(new_blocks, address, variable)
        History.finish_process_status(self())

        History.start_store_status(self())
        VariableState.store_all(vars, address)

        # VariableState.fetch_all_variable_states(address, variable)
        res = VariableState.fetch_all_variable_states(address, variable)
        Logger.info inspect(res)
        res
      resp = {:error, _err} ->
        resp
    end
  end

  defp process_blocks(blocks, address, variable) do
    Util.map(blocks, fn (block) ->
      Logger.info "PROCESSING #{block}"
      History.update_process_status(self(), 1)
      VariableState.get_variable_state(address, variable, block)
    end)
  end

end
