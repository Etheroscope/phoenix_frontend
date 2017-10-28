use Mix.Config

# Configure your database
config :etheroscope_db,
  database: System.get_en("COUCHDB_ENV") || "etheroscope_test"
