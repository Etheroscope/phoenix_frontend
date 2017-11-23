defmodule EtheroscopeEcto do
  @moduledoc """
  EtheroscopeEcto keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  @type status :: {:ok, Ecto.Schema.t} | {:error, Ecto.Changeset.t}

end
