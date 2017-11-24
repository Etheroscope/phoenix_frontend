defmodule Etheroscope.Util do
  @moduledoc """
    Etheroscope.Util will allow global access to tools defined within the context.
  """

  def essential do
    quote do
      require Logger
      alias Etheroscope.Util
      alias Util.{Error, Hex}
      alias Etheroscope.Cache
      require Error
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
