defmodule Etheroscope.Cache.History do
  use Etheroscope.Util

  alias Etheroscope.Cache

  def default_ttl, do: 30

  def next_storage_module, do: nil

  def get_pid(address, variable) do
    Cache.lookup_key(:histories, {:"$1", {address, variable}, :"_", :"_", :"_"})
  end

  def get(address: address, variable: variable) do
    case Cache.match_unique_object(:histories, {:"_", {address, variable}, :"_", :"_", :"_"}) do
      {_pid, _av, "done", _val, expiration, data} -> Cache.check_freshness({data, expiration})
      {_pid, _av, "error", err, _, _}             -> {:error, err}
      {pid, _av, status,  val1, val2, old_value}  -> format_status(pid, status, val1, val2, old_value)
      nil                                         -> nil
    end
  end

  def delete_history(address, variable) do
    pid = get_pid(address, variable)
    Cache.delete(:histories, pid)
  end

  def start(pid, start_value, address, variable) do
    Cache.add_elem(:histories, {pid, {address, variable}, "started", 0, 0, start_value})
  end

  def finish(pid, data) do
    expiration = :os.system_time(:seconds) + default_ttl()
    Cache.update_element(:histories, pid, [{3, "done"}, {5, expiration}, {6, data}])
  end

  def start_fetch_status(pid, total_blocks) do
    Cache.update_element(:histories, pid, [{3, "fetching"}, {5, total_blocks}])
  end

  def update_fetch_status(pid, step) do
    Cache.update_counter(:histories, pid, 4, step)
  end

  def finish_fetch_status(pid) do
    Cache.update_element(:histories, pid, {3, "fetched"})
  end

  def start_process_status(pid, total_blocks) do
    Cache.update_element(:histories, pid, [{3, "processing"}, {4, 0}, {5, total_blocks}])
  end

  def update_process_status(pid, step) do
    Cache.update_counter(:histories, pid, 4, step)
  end

  def finish_process_status(pid) do
    Cache.update_element(:histories, pid, {3, "processed"})
  end

  def start_store_status(pid) do
    Cache.update_element(:histories, pid, {3, "caching"})
  end

  def set_fetch_error(pid, err) do
    Cache.update_element(:histories, pid, [{3, "error"}, {4, err}])
  end

  def not_found_error(pid), do: set_fetch_error(pid, :not_found)

  def format_status(pid, status, val1, val2, old_value) do
    cond do
      !Process.alive?(pid) ->
        Cache.delete(:histories, pid)
        {:error, "Task Failed"}
      status == "fetching" || status == "processing" -> {status, {val1/val2, old_value}}
      :else                                          -> {status, old_value}
    end
  end
end
