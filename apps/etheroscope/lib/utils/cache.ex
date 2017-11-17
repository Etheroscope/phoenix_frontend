defmodule Etheroscope.Util.Cache do
  @moduledoc """
    This will use Erlang Term Storage to store important info in memory.
  """
  defmacrop handle_missing_table(do: block) do
    quote do
      try do
        unquote(block)
      rescue
        e in ArgumentError ->
          :ets.new(:global_lookup, [:set, :protected, :named_table])
          unquote(block)
      end
    end
  end

  def add_or_update_global_var(key, val) do
    handle_missing_table do
      :ets.insert(:global_lookup, {key, val})
    end
  end

  def fetch_global_var(key) do
    handle_missing_table do
      :ets.lookup(:global_lookup, key)
    end
  end
end
