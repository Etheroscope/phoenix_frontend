defmodule Etheroscope.Application do
  @moduledoc """
  The Etheroscope Application Service.

  The etheroscope system business domain lives in this application.

  Exposes API to clients such as the `EtheroscopeWeb` application
  for use in channels, controllers, and elsewhere.
  """
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    Supervisor.start_link([
      
    ], strategy: :one_for_one, name: Etheroscope.Supervisor)
  end
end
