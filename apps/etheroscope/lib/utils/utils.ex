defmodule Etheroscope.Utils do
  @moduledoc """
    Etheroscope.Utils will allow global access to tools defined within the context.
  """

  defmacro __using__([]) do
    quote do
      require Logger
      alias Etheroscope.Utils.Error
    end
  end
end
