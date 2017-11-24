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
    case get_blocks(address, variable) do
      {:ok, blocks} ->
        History.finish(self(), blocks)
        Logger.info "[CORE] Processed: contract #{address} for var #{variable}"
      {:error, err} ->
        #TODO: implement
        Error.put_error_message(err)
    end
  end

  defp get_blocks(address, variable) do
    EtheroscopeEcto.History.get(address: address, variable: variable)
  end

  def status(address, variable) do
    case History.get(address: address, variable: variable) do
      {status, data} ->
        %{status: Atom.to_string(status), data: data}
      nil ->
        nil
    end
  end
end
