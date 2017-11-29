defmodule Etheroscope.HistoryTask do
  use Etheroscope.Util, :parity
  alias Etheroscope.Cache.History

  def start(address, variable) do
    case History.get(address: address, variable: variable) do
      nil    -> Task.Supervisor.start_child(Etheroscope.TaskSupervisor, fn -> run(address, variable) end)
      _other -> {:found, nil}
    end
  end

  def run(address, variable) do
    History.start(self(), address, variable)
    case :timer.tc(fn -> get_blocks(address, variable) end) do
      {_time, {:error, err}} ->
        History.set_fetch_error(self(), err)
        Error.put_error_message(err)
      {time, blocks} ->
        Logger.info("TIME IS #{time}")
        History.finish(self(), blocks)
      :not_found ->
        History.not_found_error(self())
    end
  end

  defp get_blocks(address, variable) do
    EtheroscopeEcto.History.get(address: address, variable: variable)
  end

  def status(address, variable) do
    History.get(address: address, variable: variable)
  end
end
