defmodule Etheroscope.Util.Error do
  @typedoc """
    Etheroscope.Util.Error is a type that represents errors through-out the Etheroscope back-end.
  This module will also serve to handle any potential errors and report them correctly
  and accurately
  """
  require Logger

  @typep err_msg_list :: [%{atom() => String.t()}]
  @type t :: {:error, err_msg_list()}
  @type with_arg :: {:error, err_msg_list(), any()}

  def build_error_db(err, msg), do: build_error_namespaced(err, "DB", msg)
  def build_error_eth(err, msg), do: build_error_namespaced(err, "ETH", msg)
  def build_error_core(err, msg), do: build_error_namespaced(err, "CORE", msg)

  defp build_error_namespaced(error, namespace, msg) , do: build_error_h(error, "[#{namespace}] " <> msg)

  @spec build_error(atom() | String.t() | err_msg_list()) :: Error.t()
  def build_error(error), do: {:error, error}
  @spec build_error(err_msg_list() | atom(), atom() | String.t()) :: Error.t()
  # Propagate a not_found error all the way up
  def build_error(:not_found, _new_err), do: {:error, :not_found}
  def build_error_h(errs, new_err) when is_list(errs) do
    {:error, [new_err | errs]}
  end
  def build_error_h(err, new_err), do: {:error, [new_err, err]}

  defmacro handle_error(error_msg, do: block) do
    quote do
      try do
        unquote(block)
      rescue
        e in RuntimeError -> Logger.error(unquote(error_msg) <> " -- " <> e.message)
      end
    end
  end

  def put_error_message(err) when is_atom(err), do: err
  def put_error_message(errors) do
    for err <- errors do
      cond do
        is_atom(err)   -> err |> Atom.to_string |> Logger.error
        is_binary(err) -> err |> Logger.error
        :else          -> Logger.error("An error occured")
      end
    end
    {:error, errors}
  end

end

defmodule Etheroscope.Util.BadArgError, do: defexception message: "Bad argument passed as input"
