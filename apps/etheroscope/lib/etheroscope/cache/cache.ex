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

  def lookup_key(table, pattern) do
    case GenServer.call(@server, {:match_unique, table, pattern}) do
      nil -> nil
      tup -> tup |> Tuple.to_list |> hd
    end
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

  def delete(table, key) do
    GenServer.cast(@server, {:delete, table, key})
  end

  def check_freshness({value, expiration}) do
    status = if expiration > :os.system_time(:seconds), do: :ok, else: :stale
    {status, value}
  end
  def check_freshness(other), do: other

end
