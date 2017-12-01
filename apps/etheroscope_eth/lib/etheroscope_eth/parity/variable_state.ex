defmodule EtheroscopeEth.Parity.VariableState do
  @moduledoc """
    EtheroscopeEth.Parity.VariableState is the module containing functions to handle retrieval
  of a contract history from our Parity node.
  """
  use Etheroscope.Util, :parity
  alias EtheroscopeEth.Parity

  @behaviour Etheroscope.Resource

  def next_storage_module, do: nil

  @doc """
    Returns the calculated integer value for the variable at the given block.
  """
  def get([address: address, variable: variable, block_number: block_number]) do
    # Logger.info "Fetching #{variable} in #{address} at block #{block_number}"
    case variable |> Parity.keccak_value |> Parity.variable_value(address, Hex.to_hex(block_number)) do
      {:ok, var} ->
        # Logger.info "Fetched #{variable} with value #{var} = #{Hex.from_hex(var)}"
        {:ok, Hex.from_hex(var)}
      {:error, err} ->
        Error.build_error_eth(err, "Fetch Failed: failed for #{variable} at block #{block_number}.")
    end

  end
end
