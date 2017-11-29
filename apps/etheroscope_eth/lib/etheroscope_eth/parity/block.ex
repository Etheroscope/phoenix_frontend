defmodule EtheroscopeEth.Parity.Block do
  @moduledoc """
    EtheroscopeEth.Parity.History is the module containing functions to handle retrieval
  of block times and other block related functions.
  """
  use Etheroscope.Util, :parity
  alias EtheroscopeEth.Parity

  @batch_size 1000

  @behaviour Etheroscope.Resource

  def next_storage_module, do: nil

  def start_block_number, do: blocks_ago(1_000_000)

  def blocks_ago(number) do
    case Cache.Block.get_current() do
      {:ok, num}    -> num - number
      {:error, err} -> Error.build_error_eth(err, "Fetch failed: current_block_number")
    end
  end

  def fetch_time(block_number) when is_integer(block_number) do
    block_number
    |> Hex.to_hex
    |> fetch_time
  end
  def fetch_time(block_number) when is_binary(block_number) do
    # Logger.info "[ETH] Fetching: block #{block_number} time"
    case EtheroscopeEth.Client.eth_get_block_by_number(block_number, false) do
      {:ok, %{"timestamp" => timestamp}} ->
        # Logger.info "[ETH] Fetched: block #{block_number} time = #{Hex.from_hex(timestamp)}"
        {:ok, Hex.from_hex(timestamp)}
      {:ok, nil} ->
        {:error, :unknown}
      {:error, err} -> Error.build_error_eth(err, "Fetch Failed: Block time")
    end
  end

  @spec fetch_full_history(String.t()) :: {:ok, list()} | Error.t()
  def fetch_full_history(address), do: get({address, {:ok, start_block_number()}})

  @spec get({String.t(), {atom(), integer()}}) :: {:ok, list()} | Error.t()
  def get({address, {:ok, block_num}}) when is_integer(block_num) do
    get({address, block_num})
  end
  def get({_a, {:error, err}}), do: Error.build_error_eth(err, "Fetch Failed: Error passed in")
  def get({address, block_num}) do
    case total_blocks_to_be_fetched(block_num) do
      {:ok, total_blocks} ->
        Cache.History.start_fetch_status(self(), total_blocks)
        # Logger.info "[ETH] Fetching: blocks #{block_num} to #{Cache.Block.get_current!()} for #{address}"
        fetch_batch(address, block_num, [])
      resp = {:error, _err} ->
        Logger.info "Block get error"
        resp
    end
  end

  defp fetch_batch(address, block_num, list) do
    if block_num >= Cache.Block.get_current!() do
      # Logger.info "[ETH] Fetched: block numbers for #{address} up to date."
      Cache.History.finish_fetch_status(self())
      {:ok, list}
    else
      case address |> batched_filter_params(block_num) |> Parity.trace_filter do
        {:ok, ts} ->
          Logger.info "[ETH] Fetching: blocks #{block_num} to #{block_num + @batch_size} for #{address} "
          Cache.History.update_fetch_status(self(), @batch_size)
          fetch_batch(address, block_num + @batch_size, ts ++ list)
        {:error, err} ->
          # return on error
          Cache.History.set_fetch_error(self(), err)
          {:error, "[ETH] Fetch Failed: blocks #{block_num} to #{block_num + @batch_size} for #{address}", list}
      end
    end
  end

  defp total_blocks_to_be_fetched(start_block) do
    case Cache.Block.get_current() do
      {:ok, val}            -> {:ok, val - start_block}
      resp = {:error, _err} ->
        Logger.info "total_blocks_to_be_fetched error"
        resp
    end
  end
  defp batched_filter_params(address, block_num) do
    %{
      "toAddress" => [address],
      "fromBlock" => Hex.to_hex(block_num),
      "toBlock"   => Hex.to_hex(Enum.min([block_num + @batch_size, Cache.Block.get_current!()]))
    }
  end
end
