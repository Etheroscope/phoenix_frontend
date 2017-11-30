defmodule Etheroscope.Cache.Server do
  use GenServer

  defmacrop handle_missing_table(table, do: block) do
    quote do
      try do
        unquote(block)
      rescue
        e in ArgumentError ->
          :ets.new(unquote(table), [:named_table])
          unquote(block)
      end
    end
  end

  def start_link(_arg) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def handle_cast({:add, table, obj}, _from) do
    handle_missing_table(table) do
      {:noreply, :ets.insert(table, obj)}
    end
  end

  def handle_cast({:add_with_expiration, table, obj, ttl}, _from) do
    handle_missing_table(table) do
      expiration = :os.system_time(:seconds) + ttl
      {:noreply, :ets.insert(table, Tuple.append(obj, expiration))}
    end
  end

  def handle_cast({:update_counter, table, key, pos, step}, _from) do
    {:noreply, update(table, &:ets.update_counter/3, key, {pos, step})}
  end

  def handle_cast({:update_element, table, key, updaters}, _from) do
    {:noreply, update(table, &:ets.update_element/3, key, updaters)}
  end

  def handle_call({:lookup, table, key}, _from, _state) do
    handle_missing_table(table) do
      {:reply, (case :ets.lookup(table, key) do
        [{^key, res, expiration}] -> Etheroscope.Cache.check_freshness({res, expiration})
        [{^key, res}]             -> {:ok, res}
        [match]                   -> match
        []                        -> nil
      end), []}
    end
  end

  def handle_call({:match_unique, table, pattern}, _from, _state) do
    handle_missing_table(table) do
      {:reply, (case :ets.match_object(table, pattern) do
        [match]        -> match
        []             -> nil
      end), []}
    end
  end

  defp update(table, updater, key, updates) do
    updater.(table, key, updates)
  end

end
