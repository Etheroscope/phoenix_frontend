defmodule Etheroscope.Cache.Contract do
  use Etheroscope.Util
  alias Etheroscope.Cache

  @behaviour Etheroscope.Resource

  def default_ttl, do: 3600
  def next_storage_module, do: EtheroscopeEcto.Parity.Contract

  def get_block_numbers(address) do
    with nil           <- Cache.lookup_elem(:contract_blocks, address),
         {:ok, blocks} <- apply(next_storage_module(), :get_block_numbers, [address])
    do
      Cache.add_elem_with_expiration(:contract_blocks, {address, blocks}, default_ttl())
      {:ok, blocks}
    else
      {:error, err} -> Error.build_error(err)
      res           -> res
    end
  end
end
