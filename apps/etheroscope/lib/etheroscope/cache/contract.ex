defmodule Etheroscope.Cache.Contract do
  use Etheroscope.Util
  alias Etheroscope.Cache

  @behaviour Etheroscope.Resource

  def default_ttl, do: 3600
  def next_storage_module, do: EtheroscopeEcto.Parity.Contract

  def get_block_numbers(address) do
    case Cache.lookup_elem(:contract_blocks, address) do
      {:stale, blocks} -> get_new_blocks(address, blocks)
      nil              -> get_new_blocks(address, [])
      {:error, err}    -> Error.build_error(err)
      resp             -> resp
    end
  end

  defp get_new_blocks(address, blocks) do
    {status, new_blocks} = apply(next_storage_module(), :get_block_numbers, [address])
    if status == :ok do
      Cache.add_elem_with_expiration(:contract_blocks, {address, blocks ++ new_blocks}, default_ttl())
    end
    {status, blocks ++ new_blocks}
  end
end
