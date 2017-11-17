defmodule EtheroscopeEth.Server do
  use GenServer

  def start_link(default) do
    GenServer.start_link(__MODULE__, default)
  end


end
