defmodule EtheroscopeEth.Tasks.Block do
  use Task

  def start_link(block_number) do
    Task.start_link(__MODULE__, :run, [block_number])
  end

  def run(block_number) do
    case EtheroscopeEcto.Parity.get_block_time(block_number) do
      {:ok, block_time} -> block_time
      # {:error, msg}     -> EtheroscopeEth.Parity.Block.fetch()
    end
  end
end
