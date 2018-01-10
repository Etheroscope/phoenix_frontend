# Etheroscope Umbrella

## Development

In order to get your environment setup for development, follow these instructions:
- macOS: clone the devbox repo to the same parent folder as this one and follow their instructions.
- other OSes: the devbox hasn't been setup for windows (or even linux) development yet. Thus you should:
  1. Install Docker and docker-compose.
  2. Build a docker image with the `Dockerfile` and tag it `etheroscope` (try `docker build . -f Dockerfile -t etheroscope`)
  3. Run `docker-compose up -d`.

### Running without Docker

First, set up your local database configuration. To do
 this, create the file `apps/etheroscope_db/config/local.exs`. A template has
 been provided for your convenience (`apps/etheroscope_db/config/local.template.exs`).

Second, you'll need to set up an Etherscan API key. To do this, create the file
`apps/etheroscope/config/local.exs`, similar to the database config above.
You can find a template in the same directory.

You can then start the server with `mix phx.server`.


## Structure

These files exist in the umbrella app as well as in every app within:

  * *config/*: Files to set system wide config variables in given environments.
  * *mix.exs*: Define app properties (dependencies, aliases, etc.)

## Apps

### Etheroscope

This app contains the main business logic behind the backend. Any function that deals with transforming should be written here. See more [here](apps/etheroscope/README.md)

### Etheroscope Ecto

This app interacts with the database. Any function that loads/stores data to/from the database should be placed here. See more [here](apps/etheroscope_ecto/README.md)

### Etheroscope Eth

This app interacts with our Ethereum node. Any function that connects with the Parity node or Etherscan should be placed here. See more [here](apps/etheroscope_eth/README.md)

### Etheroscope Web

This app manages connections to/from the backend. It will handle any calls to the backend API as well as any calls to external APIs we may need. See more [here](apps/etheroscope_web/README.md)
