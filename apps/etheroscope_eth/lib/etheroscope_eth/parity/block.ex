defmodule EtheroscopeEth.Parity.Block do
  @moduledoc """
    EtheroscopeEth.Parity.History is the module containing functions to handle retrieval
  of block times and other block related functions.
  """
  use Etheroscope.Util, :parity
  alias EtheroscopeEth.Parity

  @batch_size 500

  @behaviour EtheroscopeEth.Parity.Resource

  def start_block_number, do: blocks_ago(100_000)
  def start_block_hex,    do: Hex.to_hex start_block_number()

  def blocks_ago(number) do
    case current_block_number() do
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
    Logger.info "[ETH] Fetching: block #{block_number}"
    case EtheroscopeEth.Client.eth_get_block_by_number(block_number, false) do
      {:ok, %{"timestamp" => timestamp}} -> {:ok, timestamp}
      {:error, err} -> Error.build_error_eth(err, "Not Fetched: Block time")
    end
  end

  @spec current_block_number_ch() :: non_neg_integer()
  def current_block_number_ch, do: Cache.fetch_global_var(:current_block)

  @spec current_block_number() :: {:ok, non_neg_integer()} | Error.t()
  def current_block_number do
    case EtheroscopeEth.Client.eth_block_number() do
      {:ok, block} ->
        block_number = Hex.from_hex(block)
        Cache.add_or_update_global_var(:current_block, block_number)
        {:ok, block_number}
      {:error, err} ->
        Error.build_error_eth(err, "Not Fetched: Current Block")
    end
  end

  @spec fetch_full_history(String.t()) :: {:ok, list()} | Error.t()
  def fetch_full_history(address), do: fetch({address, {:ok, start_block_number()}})

  @spec fetch({String.t(), {atom(), integer()}}) :: {:ok, list()} | Error.t()
  def fetch({address, {:ok, block_num}}), do: fetch_batch(address, block_num, block_num, [])
  def fetch({_a, {:error, err}}),         do: Error.build_error_eth(err, "Not Fetched: Error passed in")

  @spec fetch_batch(String.t(), integer(), integer(), list()) :: {:ok, list()} | Error.with_arg()
  defp fetch_batch(address, start_block, block_num, list) do
    if block_num >= current_block_number_ch() do
      Logger.info "[ETH] Fetched: block numbers for #{address} up to date."

      Cache.update_task_status(self(), "fetched", {})
      {:ok, list}
    else
      Logger.info "[ETH] Fetching: blocks #{block_num} to #{block_num + @batch_size} for #{address}"
      case address |> batched_filter_params(block_num) |> Parity.trace_filter do
        {:ok, ts} ->
          Logger.info "[ETH] Fetched: blocks #{block_num} to #{block_num + @batch_size} for #{address}"

          Cache.update_task_status(self(), "fetching", fetch_batch_status(start_block, block_num))
          fetch_batch(address, start_block, block_num + @batch_size, ts ++ list)
        {:error, _err} ->
          # return on error
          {:error, "[ETH] Not Fetched: blocks #{block_num} to #{block_num + @batch_size} for #{address}", list}
      end
    end
  end


  defp fetch_batch_status(start_block, block_num) do
    {block_num - start_block, current_block_number_ch() - start_block}
  end

  defp batched_filter_params(address, block_num) do
    %{
      "toAddress" => [address],
      "fromBlock" => Hex.to_hex(block_num),
      "toBlock"   => Hex.to_hex(block_num + @batch_size)
    }
  end
end
