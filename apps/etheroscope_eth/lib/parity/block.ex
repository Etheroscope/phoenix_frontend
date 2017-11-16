defmodule EtheroscopeEth.Parity.Block do
  @moduledoc """
    EtheroscopeEth.Parity.History is the module containing functions to handle retrieval
  of block times and other block related functions.
  """
  use Etheroscope.Util, :parity
  alias EtheroscopeEth.Parity

  @behaviour EtheroscopeEth.Parity.Resource

  def start_block do
    case Parity.current_block_number do
      {:ok, num} -> Hex.to_hex(num - 5_000)
      unknown     -> unknown
    end
  end

  def fetch(_x) do
    nil
  end

  # def process_blocks(x), do: IO.inspect x

end
