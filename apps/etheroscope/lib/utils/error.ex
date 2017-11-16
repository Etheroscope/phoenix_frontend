defmodule Etheroscope.Util.Error do
  @typedoc """
    Etheroscope.Util.Error is a type that represents errors through-out the Etheroscope back-end.
  This module will also serve to handle any potential errors and report them correctly
  and accurately
  """
  @type t :: {:error, atom() | %{atom() => string()} | nonempty_list()}

  defmacro build_error(err_type) when is_atom(err_type), do: {:error, err_type}
  defmacro build_error(err_msg) when is_binary(err_msg), do: {:error, %{msg: err_msg}}
  defmacro build_error(_), do: raise Etheroscope.Util.BadArgError

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

defmodule Etheroscope.Util.BadArgError, do: defexception message: "Bad argument passed as input"
