defmodule Etheroscope.HistoryTask do
  use Etheroscope.Util, :parity
  alias Etheroscope.Cache.History

  def notifier do
    Etheroscope.Notifier.Email
  end

  def start_task(start_value, address, variable, process_all_blocks? \\ false) do
    Task.Supervisor.start_child(Etheroscope.TaskSupervisor, fn -> run(start_value, address, variable, process_all_blocks?) end)
  end

  def start(address, variable, process_all_blocks? \\ false) do
    case History.get(address: address, variable: variable) do
      nil ->
        start_task([], address, variable, process_all_blocks?)
      {:error, _data} ->
        History.delete_history(address, variable)
        start_task([], address, variable, process_all_blocks?)
      {:stale, data}  ->
        History.delete_history(address, variable)
        start_task(data, address, variable, process_all_blocks?)
      _other          -> {:found, nil}
    end
  end

  def run(start_value, address, variable, process_all_blocks?) do
    History.start(self(), start_value, address, variable)
    case :timer.tc(fn -> get_blocks(address, variable, process_all_blocks?) end) do
      {_time, {:error, err}} ->
        History.set_fetch_error(self(), err)
        Error.put_error_message(err)
      {time, blocks} ->
        Logger.info("TIME IS #{time}")
        History.finish(self(), blocks)
        notifier().notify(address, variable)
      :not_found ->
        History.not_found_error(self())
    end
  end

  defp get_blocks(address, variable, process_all_blocks?) do
    EtheroscopeEcto.History.get(address: address, variable: variable, process_all_blocks?: process_all_blocks?)
  end

  def status(address, variable) do
    History.get(address: address, variable: variable)
  end
end
