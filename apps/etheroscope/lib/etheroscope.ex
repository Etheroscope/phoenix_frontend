defmodule Etheroscope do
  @moduledoc """
  Etheroscope keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  use Etheroscope.Util
  alias EtheroscopeEcto.Parity.{Contract, VariableState, Block}

  def fetch_contract_abi(address) do
    fetch(&Contract.fetch_contract_abi/1, address)
  end

  def fetch_contract_block_numbers(address) do
    fetch(&Contract.fetch_contract_block_numbers/1, address)
  end

  def fetch_contract_variables(address) do
    fetch(&Contract.fetch_contract_variables/1, address)
  end

  def fetch_variable_history(address, variable) do
    Task.Supervisor.start_child(Etheroscope.TaskSupervisor, fn () ->
      case Contract.fetch_contract_block_numbers(address) do
        {:ok, blocks} -> process_blocks(blocks, [], address, variable)
        {:error, err} -> #TODO: implement
          err
      end
    end)
  end

  defp fetch(function, address) do
    case function.(address) do
      {:error, errors}     -> Error.put_error_message(errors)
      resp   = {:ok, _val} -> resp
    end
  end

  defp process_blocks([], accum, _address, _variable), do: {:ok, accum}
  defp process_blocks([block | blocks], accum, address, variable) do
    with {:ok, var}  <- VariableState.fetch_variable_state(address, variable, block),
         {:ok, time} <- Block.fetch_block_time(block)
    do
      process_blocks(blocks, [%{value: var.value, time: time} | accum], address, variable)
    else
      {:error, errors} ->
        Error.put_error_message(errors)
        process_blocks(blocks, accum, address, variable)
    end
  end
end
