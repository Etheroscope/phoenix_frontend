defmodule EtheroscopeEth.Parity do
  @moduledoc """
    EtheroscopeEth.Parity serves as a wrapper for the Ethereumex library. It allows us
  to be responsible for error handling as well as adding new functionality to it.
  """
  use Etheroscope.Util, :parity
  import EtheroscopeEth.Client

  @type keccak_var :: <<_ ::80>>

  @method_id_size 10

  @spec trace_filter(map()) :: {:ok, String.t} | Error.t
  def trace_filter(params) do
    with true          <- validate_filter_params(params),
         {:ok, result} <- request("trace_filter", [params], [])
    do
      IO.inspect result
      {:ok, result}
    else
      false         -> {:error, "Invalid parameters"}
      {:error, msg} -> {:error, "The following error occured when requesting the filter: #{msg}"}
    end
  end

  @spec current_block_number() :: non_neg_integer()
  def current_block_number do
    Hex.from_hex(eth_block_number())
  end

  @spec keccak_value(string()) :: {:ok, string} | Error.t
  def keccak_value(var) do
    # create hash for variable name with empty parenthises
    hash = Base.encode16(var <> "()")
    case EtheroscopeEth.Client.web3_sha3("0x" <> hash) do
      {:ok, hex} -> {:ok, String.slice(hex, 0, @method_id_size)}
      other      -> other
    end
  end

  @spec variable_value(keccak_var, string(), string()) :: {:ok, string()} | Error.t
  def variable_value(variable, address, block_number) do
    EtheroscopeEth.Client.eth_call(%{ "to" => address, "data" => variable}, block_number)
  end

end

defmodule EtheroscopeEth.TimeoutError, do: defexception message: "A timeout error has occurred with the Parity node."
