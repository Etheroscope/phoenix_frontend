defmodule Etheroscope.Utils.Error do
  @typedoc """
    Etheroscope.Utils.Error is a type that represents errors through-out the Etheroscope back-end.
  This module will also serve to handle any potential errors and report them correctly
  and accurately
  """
  @type t :: {:error, map() | binary() | nonempty_list()}
end
