defmodule EtheroscopeEth.Parity.Block do
  @moduledoc """
    EtheroscopeEth.Parity.History is the module containing functions to handle retrieval
  of block times and other block related functions.
  """
  use Etheroscope.Util, :parity
  alias EtheroscopeEth.Parity

  def start_block do
    case Parity.current_block_number do
      {:ok, num} -> Hex.to_hex(num - 2_000)
      unknown    -> unknown
    end
  end

  def fetch_time(block_number) when is_integer(block_number) do
    fetch_time(Hex.to_hex(block_number))
  end
  def fetch_time(block_number) when is_binary(block_number) do
    Logger.info "[ETH] Fetching: block #{block_number}"
    case EtheroscopeEth.Client.eth_get_block_by_number(block_number, false) do
      {:ok, %{"timestamp" => timestamp}} -> {:ok, timestamp}
      {:error, err} ->
        Error.build_error(err, "[ETH] Unable to fetch block time")
    end
  end
end
