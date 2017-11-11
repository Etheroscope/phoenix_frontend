defmodule Etheroscope.Utils.Hex do
  @moduledoc """
    Etheroscope.Utils.Hex is a collection of functions to handle, transform and apply
  functions to hex values returned from the Parity client.
  """

  @spec from_hex(binary()) :: integer()
  def from_hex("0x" <> hex), do: String.to_integer(hex, 16)

  @spec to_hex(integer) :: binary()
  def to_hex(num), do: "0x#{Integer.to_string(num, 16)}"

  @spec apply_to_hex(((integer(), integer()) -> integer()), binary(), integer()) :: binary()
  def apply_to_hex(op, hex, num) do
    hex
      |> from_hex
      |> op.(num)
      |> to_hex
  end
end
