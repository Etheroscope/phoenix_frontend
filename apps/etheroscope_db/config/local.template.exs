config :etheroscope_db,
       hostname: System.get_env("COUCHDB_HOSTNAME") || "[ENTER DATABASE HOST]",
       database: System.get_env("COUCHDB_DATABASE") || "[ENTER DATABASE NAME]",
       port: 5984,
       user: System.get_env("COUCHDB_USER") || "[ENTER USERNAME HERE]",
       password: System.get_env("COUCHDB_PASSWORD") || "[ENTER PASS HERE]"