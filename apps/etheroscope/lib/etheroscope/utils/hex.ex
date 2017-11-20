defmodule Etheroscope.Util.Hex do
  @moduledoc """
    Etheroscope.Util.Hex is a collection of functions to handle, transform and apply
  functions to hex values returned from the Parity client.
  """

  @spec from_hex(binary() | {atom(), binary()}) :: {atom(), any()} | integer()
  def from_hex("0x" <> hex), do: String.to_integer(hex, 16)
  def from_hex({:ok, "0x" <> hex}), do: {:ok, String.to_integer(hex, 16)}
  # propragate the error
  def from_hex({:error, msg}), do: {:error, msg}
  def from_hex(x) do
    IO.inspect(x)
    raise Etheroscope.Util.BadArgError
  end

  @spec to_hex(integer() | {atom(), integer()}) :: {atom(), any()} | binary()
  def to_hex(num) when is_integer(num), do: "0x#{Integer.to_string(num, 16)}"
  def to_hex({:ok, num}), do: {:ok, "0x#{Integer.to_string(num, 16)}"}
  # propragate the error
  def to_hex({:error, msg}), do: {:error, msg}
  def to_hex(_),                        do: raise Etheroscope.Util.BadArgError

  @spec sub_from_hex(binary() | {atom(), binary()}, integer()) :: binary()
  def sub_from_hex(hex, num) do
    apply_to_hex(&Kernel.-/2, hex, num)
  end

  @spec apply_to_hex(((integer(), integer()) -> integer()), binary(), integer()) :: binary()
  def apply_to_hex(op, hex, num) do
    hex
      |> from_hex
      |> op.(num)
      |> to_hex
  end
end
