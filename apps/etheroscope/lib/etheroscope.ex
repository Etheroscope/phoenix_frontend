defmodule Etheroscope do
  @moduledoc """
  Etheroscope keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  use Etheroscope.Util, :parity
  alias EtheroscopeEcto.Parity.Contract

  def fetch_contract_abi(address) do
    fetch(&Contract.fetch_contract_abi/1, address)
  end

  def fetch_contract_block_numbers(address) do
    fetch(&Contract.fetch_contract_block_numbers/1, address)
  end

  def fetch_contract_variables(address) do
    fetch(&Contract.fetch_contract_variables/1, address)
  end

  def fetch_task_status(address, variable) do
    Cache.lookup_history_task(address, variable)
    |> format_history_task_status
  end

  def fetch_variable_history(address, variable) do
    Task.Supervisor.start_child(Etheroscope.TaskSupervisor, fn () ->
      Cache.start_history_task(self(), address, variable)
      case Contract.fetch_contract_block_numbers(address) do
        {:ok, blocks} ->
          data = process_blocks(blocks, [], address, variable)
          Cache.update_task_status(self(), "done", data)
        {:error, err} ->
          #TODO: implement
          err
      end
    end)
  end

  defp format_history_task_status(nil), do: nil
  defp format_history_task_status(pid) do
    case Cache.lookup_task_status(pid) do
      {"fetching", {blocks_done, blocks_total}}
        -> %{status: "fetching", data: blocks_done/blocks_total}
      {"done", data}
        -> %{status: "done", data: data}
      nil
        -> nil
      other
        -> %{status: other}
    end
  end

  defp fetch(function, address) do
    case function.(address) do
      {:error, errors}     -> Error.put_error_message(errors)
      resp   = {:ok, _val} -> resp
    end
  end
end
