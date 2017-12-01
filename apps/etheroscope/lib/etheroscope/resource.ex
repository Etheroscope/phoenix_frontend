defmodule Etheroscope.Resource do
  use Etheroscope.Util

  @callback get(args :: maybe_improper_list()) :: {:ok, result :: term} | Error.t() | Error.with_arg()
  @callback next_storage_module :: module()
end
