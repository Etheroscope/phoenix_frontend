defmodule EtheroscopeEth.Parity do
  @moduledoc """
    EtheroscopeEth.Parity serves as a wrapper for the Ethereumex library. It allows us
  to be responsible for error handling as well as adding new functionality to it.
  """
  use Etheroscope.Util, :parity
  import EtheroscopeEth.Client

  defp handle_timeout(do: block) do
    Error.handle_error "A timeout error occurred with the Parity client", do: block
  end

  @spec trace_filter(map()) :: {:ok, String.t} | Error.t
  def trace_filter(params) do
    with true          <- Parity.validate_filter_params(params),
         {:ok, result} <- request("trace_filter", [params], [])
    do
      IO.inspect result
      {:ok, Parity.block_numbers(result)}
    else
      false         -> {:error, "Invalid parameters"}
      {:error, msg} -> {:error, "The following error occured when requesting the filter: #{msg}"}
    end
  end

  @spec current_block_number() :: non_neg_integer()
  def current_block_number do
    handle_timeout do
      {:ok, hex} = eth_block_number()
      Hex.from_hex(hex)
    end
  end
end

defmodule EtheroscopeEth.TimeoutError do
    defexception message: "A timeout error has occurred with the Parity node."
end
