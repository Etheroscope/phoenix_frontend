defmodule Etheroscope.HistoryTask do
  use Etheroscope.Util, :parity
  alias EtheroscopeEcto.Parity.Contract

  def start(address, variable) do
    Task.Supervisor.start_child(Etheroscope.TaskSupervisor, fn -> run(address, variable) end)
  end

  def run(address, variable) do
    # TODO: add cache staleness to prevent endless loop.
    Cache.start_history_task(self(), address, variable)
    case Contract.fetch_contract_block_numbers(address) do
      {:ok, blocks} ->
        data = process_blocks(blocks, [], address, variable)
        Cache.finish_history_task(self(), data)
      {:error, err} ->
        #TODO: implement
        err
    end
  end

  def status(address, variable) do
    Cache.lookup_history_task(address, variable)
    |> format_history_task_status
  end

  defp format_history_task_status(nil), do: nil
  defp format_history_task_status(pid) do
    case Cache.lookup_task_status(pid) do
      {"fetching", {blocks_done, blocks_total}}
        -> %{status: "fetching", data: blocks_done/blocks_total}
      {"done", data}
        -> %{status: "done", data: data}
      nil
        -> nil
      other
        -> %{status: other}
    end
  end
end
