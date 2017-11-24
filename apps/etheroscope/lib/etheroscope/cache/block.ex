defmodule Etheroscope.Cache.Block do
  use Etheroscope.Util
  alias Etheroscope.Cache

  @default_ttl 1 |> :timer.minutes

  @behaviour Etheroscope.Resource

  def next_storage_module, do: EtheroscopeEth.Parity.Block

  def get_current! do
    case get_current() do
      {:ok, val}    -> val
      {:error, err} ->
        Error.put_error_message(err)
    end
  end
  def get_current do
    with nil        <- Cache.lookup_elem(:blocks, "current_block"),
         {:ok, val} <- apply(EtheroscopeEth.Parity, :current_block_number, [])
    do
      Logger.info "[CACHE] Adding current block"
      Cache.add_elem_with_expiration(:blocks, {"current_block", val}, @default_ttl)
      {:ok, val}
    else
      resp -> resp
    end
  end

  def get_time(block_number), do: get([block_number: block_number])

  def get(block_number: block_number) do
    with nil         <- Cache.lookup_elem(:blocks, block_number),
         {:ok, time} <- apply(next_storage_module(), :fetch_time, [block_number])
    do
      Cache.add_elem(:blocks, {block_number, time})
      {:ok, time}
    else
      resp -> resp
    end
  end
end
