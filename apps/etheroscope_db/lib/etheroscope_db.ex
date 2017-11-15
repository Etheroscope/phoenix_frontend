defmodule EtheroscopeDB do
  @moduledoc """
  EtheroscopeDB will contain all wrapping functions for the database.
  """
  use Etheroscope.Util

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

  @spec fetch_contract_abi(integer()) :: any()
  def fetch_contract_abi(addr),         do: fetch("#{addr}")
  @spec write_contract_abi(integer(), map()) :: any()
  def write_contract_abi(addr, contract_abi), do: write("#{addr}", contract_abi)

  @spec fetch_block_time(integer()) :: {:ok, map()} | Error.t
  def fetch_block_time(number),         do: fetch("block/#{number}")
  @spec write_block_time(integer(), map()) :: any()
  def write_block_time(number, timestamp), do: write("block/#{number}", timestamp)

  # HELPERS
  defp fetch(id), do: Couchdb.Connector.get(db_props(), id)
  defp write(id, params) do
    {status, %{payload: payload}} = Couchdb.Connector.create(db_props(), params, id)
    {status, payload}
  end
end
