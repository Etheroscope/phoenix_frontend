defmodule EtheroscopeEth.Parity.Resource do
  use Etheroscope.Util

  @callback fetch(args :: term) :: {:ok, response :: term} | Error.t
end
