defmodule Etheroscope.Resource do
  use Etheroscope.Util

  @callback get(args :: nonempty_maybe_improper_list()) :: {:ok, result :: term} | Error.t() | Error.with_arg()
  @callback next_storage_module :: module()
  # @callback cache_apply(mod :: term, fun :: fun(), args :: nonempty_maybe_improper_list(), ttl :: number()) :: result :: any()

end
