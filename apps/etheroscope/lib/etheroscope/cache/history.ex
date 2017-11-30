defmodule Etheroscope.Cache.History do
  use Etheroscope.Util

  alias Etheroscope.Cache

  def default_ttl, do: 3600

  def next_storage_module, do: nil

  def get_pid(address, variable) do
    :ets.match_object(:histories, {:"$1", {address, variable}, :"_", :"_", :"_"})
  end

  def get(address: address, variable: variable) do
    Logger.warn inspect(Cache.match_unique_object(:histories, {:"_", {address, variable}, :"_", :"_", :"_"}))
    case Cache.match_unique_object(:histories, {:"_", {address, variable}, :"_", :"_", :"_"}) do
      {_pid, _av, "done", data, expiration} -> Cache.check_freshness({data, expiration})
      {_pid, _av, "error", err, _}          -> {:error, err}
      {pid, _av, status,  val1, val2}       -> format_status(pid, status, val1, val2)
      nil                                   -> nil
    end
  end

  def start(pid, address, variable) do
    Cache.add_elem(:histories, {pid, {address, variable}, "started", 0, 0})
  end

  def finish(pid, data) do
    expiration = :os.system_time(:seconds) + default_ttl()
    Cache.update_element(:histories, pid, [{3, "done"}, {4, data}, {5, expiration}])
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

  def format_status(pid, status, val1, val2) do
    cond do
      !Process.alive?(pid)                           -> {:error, "Task Failed"}
      status == "fetching" || status == "processing" -> {status, val1/val2}
      :else                                          -> status
    end
  end
end
