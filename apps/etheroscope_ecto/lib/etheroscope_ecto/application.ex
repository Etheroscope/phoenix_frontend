defmodule EtheroscopeEcto.Application do
  @moduledoc """
  The EtheroscopeEcto Application Service.

  The etheroscope_ecto system business domain lives in this application.

  Exposes API to clients such as the `EtheroscopeEctoWeb` application
  for use in channels, controllers, and elsewhere.
  """
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    Supervisor.start_link([
      supervisor(EtheroscopeEcto.Repo, []),
    ], strategy: :one_for_one, name: EtheroscopeEcto.Supervisor)
  end
end
