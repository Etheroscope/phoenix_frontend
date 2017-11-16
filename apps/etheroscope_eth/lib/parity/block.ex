defmodule EtheroscopeEth.Parity.Block do
  @moduledoc """
    EtheroscopeEth.Parity.History is the module containing functions to handle retrieval
  of block times and other block related functions.
  """
  use Etheroscope.Util, :parity
  alias EtheroscopeEth.Parity

  def start_block, do: Hex.to_hex(Parity.current_block_number - 15_000)

  def process_blocks(x), do: IO.inspect x

end
