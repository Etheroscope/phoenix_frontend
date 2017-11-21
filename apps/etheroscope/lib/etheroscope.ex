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

  defp fetch(function, address) do
    case function.(address) do
      {:error, errors}     -> Error.put_error_message(errors)
      resp   = {:ok, _val} -> resp
    end
  end

  def fetch_variable_history(address, variable, callback_url) do
    # ping the callback to check validity
    case HTTPoison.post(callback_url, "") do
      {:ok, %HTTPoison.Response{status_code: 200}} ->
        Task.Supervisor.start_child(Etheroscope.TaskSupervisor, fn () ->
          with {:ok, blocks} <- Contract.fetch_contract_block_numbers(address),
               {:ok, accum}  <- process_blocks(blocks, [], address, variable)
          do
            IO.inspect accum
            post_history_result(callback_url, accum, address, variable)
          end
        end)
        {:ok, nil}
      {:error, %HTTPoison.Error{reason: :nxdomain}} ->
        {:error, "Non existent domain passed in: #{callback_url}"}
      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, "Error from callback url: #{reason}"}
      {:error, %HTTPoison.Response{body: body}} ->
        {:error, "Unkown error from callback: #{body}"}
    end
  end

  defp post_history_result(callback_url, blocks, _address, _variable) do
    HTTPoison.post!(callback_url, Poison.encode!(%{response: "Success", data: blocks}), [{"Content-Type", "application/json"}])
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
