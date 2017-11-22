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

  @spec build_error(atom() | String.t() | map()) :: Error.t()
  def build_error(error) , do: build_error([], error)

  def build_error_db(err, msg), do: build_error_namespaced(err, "DB", msg)
  def build_error_eth(err, msg), do: build_error_namespaced(err, "ETH", msg)
  def build_error_core(err, msg), do: build_error_namespaced(err, "CORE", msg)

  defp build_error_namespaced(error, namespace, msg) , do: build_error_h(error, "[#{namespace}] " <> msg)

  def build_error(error, err_msg) when is_binary(err_msg), do: build_error_h(error, %{msg: err_msg})
  def build_error(error, err_type) when is_atom(err_type), do: build_error_h(error, %{type: err_type})
  def build_error(error, err_map) when is_map(err_map),    do: build_error_h(error, err_map)

  defp build_error_h(errs, new_err) when is_list(errs) do
    {:error, [new_err | errs]}
  end
  defp build_error_h(err, new_err), do: {:error, [new_err, err]}

  defmacro handle_error(error_msg, do: block) do
    quote do
      try do
        unquote(block)
      rescue
        e in RuntimeError -> Logger.error(unquote(error_msg) <> " -- " <> e.message)
      end
    end
  end

  def put_error_message(errors) do
    for err <- errors do
      msg  = Map.get(err, :msg, "An error occured.")
      type = Map.get(err, :msg, ":error")
      # Logger.error "#{type}"
      Logger.error "#{msg}"
      # Logger.error "Full error: #{map}"
    end
    {:error, errors}
  end

end

defmodule Etheroscope.Util.BadArgError, do: defexception message: "Bad argument passed as input"
