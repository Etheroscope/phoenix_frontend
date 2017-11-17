defmodule EtheroscopeEth.Parity.VariableState do
  @moduledoc """
    EtheroscopeEth.Parity.VariableState is the module containing functions to handle retrieval
  of a contract history from our Parity node.
  """
  use Etheroscope.Util, :parity
  alias EtheroscopeEth.Parity

  @behaviour EtheroscopeEth.Parity.Resource

  @doc """
  fetch_value/3 is just a wrapper for fetch/1 to facilitate dev.
  """
  @spec fetch_value(String.t(), String.t(), integer()) :: {:ok, any()} | Error.t()
  def fetch_value(address, variable_name, block_number) do
    fetch({address, variable_name, block_number})
  end

  @doc """
  fetch() returns the calculated integer value for the variable at the given block.
  """
  @spec fetch({String.t(), String.t(), integer()}) :: {:ok, integer()} | Error.t()
  def fetch({address, variable_name, block_number}) do
    Logger.info "[ETH] Fetching #{variable_name} in #{address} at block #{block_number}"
    resp = variable_name
           |> Parity.keccak_value
           |> Parity.variable_value(address, Hex.to_hex(block_number))

    case resp do
      {:ok, var} ->
        Logger.info "[ETH] Fetched #{variable_name} with value #{var} = #{Hex.from_hex(var)}"
        {:ok, Hex.from_hex(var)}
      {:error, err} ->
        Error.build_error(err, "[ETH] Fetched failed #{variable_name}")
    end


  end
  def fetch(_), do: Error.build_error(:badarg)
end
