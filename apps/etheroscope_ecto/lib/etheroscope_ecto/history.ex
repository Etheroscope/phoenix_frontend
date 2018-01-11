defmodule EtheroscopeEcto.History do
  use Etheroscope.Util

  require EtheroscopeEcto
  alias Etheroscope.Cache.Contract
  alias EtheroscopeEcto.Parity.VariableState
  alias Etheroscope.Cache.History

  def get([address: address, variable: variable, process_all_blocks?: process_all_blocks?]) do
    case Contract.get_block_numbers(address) do
      {:ok, all_blocks, new_blocks} ->
        blocks_to_process = if process_all_blocks?, do: all_blocks, else: new_blocks

        History.start_process_status(self(), length(blocks_to_process))
        # Store all processed blocks
        vars = process_blocks(blocks_to_process, address, variable)
        History.finish_process_status(self())

        History.start_store_status(self())
        VariableState.store_all(vars, address)

        VariableState.fetch_all_variable_states(address, variable)
      resp = {:error, _err} ->
        resp
    end
  end

  def process_blocks(blocks, address, variable) do
    Enum.map(blocks, fn (block) ->
      Logger.info "PROCESSING #{block} for address #{address}"
      History.update_process_status(self(), 1)
      VariableState.get_variable_state(address, variable, block)
    end)
  end

end
