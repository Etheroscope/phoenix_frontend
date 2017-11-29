defmodule Etheroscope.Cache do
  @moduledoc """
    A simple ETS based cache for variable history calls.
  """
  @server Etheroscope.Cache.Server

  def add_elem(table, obj) do
    GenServer.cast(@server, {:add, table, obj})
  end

  def add_elem_with_expiration(table, obj, ttl) do
    GenServer.cast(@server, {:add_with_expiration, table, obj, ttl})
  end

  def lookup_elem(table, key) do
    GenServer.call(@server, {:lookup, table, key})
  end

  def match_unique_object(table, pattern) do
    GenServer.call(@server, {:match_unique, table, pattern})
  end

  def update_element(table, key, updaters) do
    GenServer.cast(@server, {:update_element, table, key, updaters})
  end

  def update_counter(table, key, pos, step) do
    GenServer.cast(@server, {:update_counter, table, key, pos, step})
  end

  def check_freshness({value, expiration}) do
    if expiration > :os.system_time(:seconds) do
      {:ok, value}
    else
      nil
    end
  end
  def check_freshness(other), do: other

end