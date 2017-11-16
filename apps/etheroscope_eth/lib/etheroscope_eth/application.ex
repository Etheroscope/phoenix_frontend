defmodule EtheroscopeEth.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false
    # List all child processes to be supervised
    children = [
      # Starts a worker by calling: EtheroscopeEth.Worker.start_link(arg)
      # {EtheroscopeEth.Worker, arg},
      worker(EtheroscopeEth.Client, []),
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: EtheroscopeEth.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
