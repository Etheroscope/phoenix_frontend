defmodule Etheroscope.Util do
  @moduledoc """
    Etheroscope.Util will allow global access to tools defined within the context.
  """

  def max([]), do: -1
  def max(l),  do: Enum.max(l)

  def map(collection, func) do
    collection
    |> Enum.map(&(Task.async(fn -> func.(&1) end)))
    |> Enum.map(&Task.await/1)
  end

  # REQUIRY FUNCTIONS

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
