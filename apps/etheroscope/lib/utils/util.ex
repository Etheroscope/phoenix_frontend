defmodule Etheroscope.Util do
  @moduledoc """
    Etheroscope.Util will allow global access to tools defined within the context.
  """

  def essential do
    quote do
      require Logger
      require Etheroscope.Util.Error
      alias Etheroscope.Util
      alias Etheroscope.Util.{Error, Hex}
    end
  end

  def parity do
    quote do
      unquote(essential())
      import Etheroscope.Util.Parity
    end
  end

  defmacro __using__([]) do
    apply(__MODULE__, :essential, [])
  end

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end

end
