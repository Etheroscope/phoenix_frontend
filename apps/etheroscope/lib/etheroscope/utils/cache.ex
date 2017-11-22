defmodule Etheroscope.Util.Cache do
  @moduledoc """
    This will use Erlang Term Storage to store important info in memory.
  """
  defmacrop handle_missing_table(table, table_props \\ [:set, :protected, :named_table], do: block) do
    quote do
      try do
        unquote(block)
      rescue
        e in ArgumentError ->
          :ets.new(unquote(table), unquote(table_props))
          unquote(block)
      end
    end
  end

  defp add_new_elem(table, key, val) do
    handle_missing_table(table) do
      :ets.insert_new(table, {key, val})
    end
  end

  defp add_or_update_elem(table, key, val) do
    handle_missing_table(table) do
      :ets.insert(table, {key, val})
    end
  end

  defp lookup_elem(table, key) do
    handle_missing_table(table) do
      case :ets.lookup(table, key) do
        [{^key, val}] -> val
        []            -> nil
      end
    end
  end

  def add_or_update_global_var(key, val) do
    add_or_update_elem(:global_lookup, key, val)
  end

  def lookup_global_var(key) do
    lookup_elem(:global_lookup, key)
  end

  def add_history_task(address, variable, pid) do
    add_new_elem(:history_tasks, address <> variable, pid)
  end

  def update_history_task(address, variable, pid) do
    add_or_update_elem(:history_tasks, address <> variable, pid)
  end

  def lookup_history_task(address, variable) do
    lookup_elem(:history_tasks, address <> variable)
  end

  def start_history_task(pid, address, variable) do
    update_history_task(address, variable, pid)
    update_task_status(pid, "started", {})
  end

  def finish_history_task(pid, data) do
    update_task_status(pid, "done", data)
  end

  def update_task_status(pid, status, data) do
    add_or_update_elem(:history_status, pid, {status, data})
  end

  def lookup_task_status(pid) do
    lookup_elem(:history_status, pid)
  end
end
