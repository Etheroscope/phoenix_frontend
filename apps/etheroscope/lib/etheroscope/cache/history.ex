defmodule Etheroscope.Cache.History do
  use Etheroscope.Util

  alias Etheroscope.Cache

  def default_ttl, do: 3600
  def next_storage_module, do: nil

  def get(address: address, variable: variable) do
    case Cache.match_unique_object(:histories, {:"_", {address, variable}, :"_", :"_", :"_"}) do
      {_pid, _av, "done", data, expiration}            -> Cache.check_freshness({data, expiration})
      {_pid, _av, "fetching", fetched, total_to_fetch} -> {:fetching, fetched/total_to_fetch}
      {_pid, _av, "fetched",  _, _}                    -> {:processing, nil}
      {_pid, _av, "error", err, _}                     -> {:error, err}
      {_pid, _av, "started",  _, _}                    -> {:started, nil}
      nil                                              -> nil
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

  def set_fetch_error(pid, err) do
    Cache.update_element(:histories, pid, [{3, "error"}, {4, err}])
  end

  def not_found_error(pid) do
    set_fetch_error(pid, :not_found)
  end
end
