# EtheroscopeWeb

Your server should start automatically if you're using the devbox. Try visiting [`localhost:4000`](http://localhost:4000) from your browser to see if it's working.

If it doesn't, you're going to have to start it manually:
  * Install dependencies with `mix deps.get`
  * Start Phoenix endpoint with `mix phx.server`

(N.B. this won't start the database server. To get that running you'll need to install CouchDB and make sure the server settings are correct.)

## Structure

### config

Use the files below to set system wide config variables.

### lib/etheroscope_web

  * *channels*: not quite sure how to use them yet, but looks [promising](https://hexdocs.pm/phoenix/channels.html#content).
  * *controllers*: handle calls to endpoints by running the desired code. After transforming data in conn and parameters, call `render conn, <JSON_FILE_NAME>, %{<PARAMS>}`


## Learn more
  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix
