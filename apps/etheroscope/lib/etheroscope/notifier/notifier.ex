defmodule Etheroscope.Notifier do
  use Etheroscope.Util

  @callback subscribe(map()) :: :ok | {:error, list() | String.t()}
  @callback notify(map()) :: :ok | {:error, list() | String.t()}
end
