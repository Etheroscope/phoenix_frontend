defmodule EtheroscopeDB.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = []

    create_database()
    # seed_database()

    opts = [strategy: :one_for_one, name: EtheroscopeDB.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def create_database do
    case Couchdb.Connector.Storage.storage_up(EtheroscopeDB.db_props) do
      {:ok, _msg}   -> IO.puts "Database #{EtheroscopeDB.db_props.database} successfully created."
      {:error, msg} -> IO.warn "Unable to create database: #{msg}"
    end
  end

  def seed_database do
    # not implemented
    raise "Not implemented"
  end
end
