defmodule Etheroscope do
  @moduledoc """
  Etheroscope keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  use Etheroscope.Util
  alias EtheroscopeEcto.Parity.{Contract, VariableState}

  def fetch_contract_abi(address) do
    fetch(&Contract.fetch_contract_abi/1, address)
    case Contract.fetch_contract_abi(address) do
      {:ok, abi} -> abi
      errors     -> Error.put_error_message(errors)
    end
  end

  def fetch_contract_block_numbers(address) do
    fetch(&Contract.fetch_contract_block_numbers/1, address)
  end

  def fetch_contract_variables(address) do
    fetch(&Contract.fetch_contract_variables/1, address)
  end

  defp fetch(function, address) do
    case function.(address) do
      {:ok, resp}             -> resp
      errors = {:error, _err} -> Error.put_error_message(errors)
    end
  end

  def fetch_variable_history(address, variable) do
    with {:ok, blocks} <- Contract.fetch_contract_block_numbers(address)
    do
      for block <- blocks do
        VariableState.fetch_variable_state(address, variable)
      end
    end
  end

end
