defmodule EtheroscopeEth.Parity.Resource do
  use Etheroscope.Utils

  @callback fetch(args :: term) :: {:ok, response :: term} | Error.t
end
