defmodule Etheroscope.Util.Error do
  @typedoc """
    Etheroscope.Util.Error is a type that represents errors through-out the Etheroscope back-end.
  This module will also serve to handle any potential errors and report them correctly
  and accurately
  """
  @type t :: {:error, map() | binary() | nonempty_list()}

  defmacro handle_error(error_msg, do: block) do
    quote do
      try do
        unquote(block)
      rescue
        e in RuntimeError -> Logger.error(unquote(error_msg) <> " -- " <> e.message)
      end
    end
  end

end
