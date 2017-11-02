defmodule EtheroscopeDB do
  @moduledoc """
  Documentation for EtheroscopeDB.
  """

  @doc """
  Hello world.

  ## Examples

      iex> EtheroscopeDB.hello
      :world

  """
  def db_props do
    %{
      protocol: Application.get_env(:etheroscope_db, :protocol),
      hostname: Application.get_env(:etheroscope_db, :hostname),
      database: Application.get_env(:etheroscope_db, :database),
      port:     Application.get_env(:etheroscope_db, :port),
      user:     Application.get_env(:etheroscope_db, :user),
      password: Application.get_env(:etheroscope_db, :password)
    }
  end

  def fetch_filter(id),  do: fetch("filter/#{id}")

  # HELPERS
  defp fetch(id), do: Couchdb.Connector.get(db_props(), id)
  defp write(id, params), do: Couchdb.Connector.create(db_props(), params, id)
end
