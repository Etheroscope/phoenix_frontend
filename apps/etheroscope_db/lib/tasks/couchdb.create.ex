db_props = %{
  protocol: Application.get_env(:couchdb_connector, :protocol),
  hostname: Application.get_env(:couchdb_connector, :hostname),
  database: Application.get_env(:couchdb_connector, :database),
  port:     Application.get_env(:couchdb_connector, :port),
  user:     Application.get_env(:couchdb_connector, :user),
  password: Application.get_env(:couchdb_connector, :password)
}

case Couchdb.Connector.Storage.storage_up(db_props) do
  {:ok, _msg}   -> IO.puts "Database #{db_props.database} created."
  {:error, msg} -> IO.warn "Database could not be created: #{msg}"
end
