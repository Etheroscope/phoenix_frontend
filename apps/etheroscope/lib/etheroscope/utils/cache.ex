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

  defp add_to_table(table, key, val) do
    handle_missing_table(table) do
      :ets.insert(table, {key, val})
    end
  end

  defp fetch_from_table(table, key) do
    handle_missing_table(table) do
      case :ets.lookup(table, key) do
        [{^key, val}] -> val
        []            -> nil
      end
    end
  end

  def add_or_update_global_var(key, val) do
    add_to_table(:global_lookup, key, val)
  end

  def fetch_global_var(key) do
    fetch_from_table(:global_lookup, key)
  end

  def add_history_task(pid, address, variable) do
    add_to_table(:history_tasks, pid, {address, variable})
  end

  def fetch_history_task_params(pid) do
    fetch_from_table(:history_tasks, pid)
  end

  def start_history_task(pid, address, variable) do
    update_task_status(pid, "started", {})
    add_history_task(pid, address, variable)
  end

  def update_task_status(pid, status, data) do
    add_to_table(:tasks_statuses, pid, {status, data})
  end

  def fetch_task_status(pid) do
    fetch_from_table(:task_statuses, pid)
  end
end
