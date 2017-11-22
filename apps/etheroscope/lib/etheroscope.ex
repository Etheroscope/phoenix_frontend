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
    Etheroscope.HistoryTask.status(address, variable)
  end

  def fetch_variable_history(address, variable) do
    Etheroscope.HistoryTask.start(address, variable)
  end

  defp fetch(function, address) do
    case function.(address) do
      {:error, errors}     -> Error.put_error_message(errors)
      resp   = {:ok, _val} -> resp
    end
  end
end
