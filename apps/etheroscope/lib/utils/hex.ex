defmodule Etheroscope.Util.Hex do
  @moduledoc """
    Etheroscope.Util.Hex is a collection of functions to handle, transform and apply
  functions to hex values returned from the Parity client.
  """

  @spec from_hex!(binary()) :: integer()
  def from_hex!("0x" <> hex), do: String.to_integer(hex, 16)
  def from_hex!(_), do: raise Etheroscope.Util.BadArgError
  @spec from_hex({atom(), binary()}) :: {atom(), any()}
  def from_hex({:ok, "0x" <> hex}), do: {:ok, String.to_integer(hex, 16)}
  # propragate the error
  def from_hex({:error, msg}), do: {:error, msg}

  @spec to_hex!(integer) :: binary()
  def to_hex!(num) when is_integer(num), do: "0x#{Integer.to_string(num, 16)}"
  def to_hex!(_),                        do: raise Etheroscope.Util.BadArgError
  @spec to_hex({atom(), integer()}) :: {atom(), any()}
  def to_hex({:ok, num}), do: {:ok, "0x#{Integer.to_string(num, 16)}"}
  # propragate the error
  def to_hex({:error, msg}), do: {:error, msg}
end
