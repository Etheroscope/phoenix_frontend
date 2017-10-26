# Etheroscope Umbrella

## Development

In order to get your environment setup for development, follow these instructions:
- macOS: clone the devbox repo to the same parent folder as this one and follow their instructions.
- other OSes: the devbox hasn't been setup for windows (or even linux) development yet. Thus you should:
  1. Install Docker and docker-compose.
  2. Build a docker image with the `Dockerfile` and tag it `etheroscope` (try `docker build . -f Dockerfile -t etheroscope`)
  3. Run `docker-compose up -d`.

## Structure

### Etheroscope

This app contains the main business logic behind the backend. Any function that deals with transforming should be written here.

### Etheroscope Ecto

This app interacts with the database. Any function that loads/stores data to/from the database should be placed here.

### Etheroscope Web

This app manages connections to/from the backend. It will handle any calls to the backend API as well as any calls to external APIs we may need.
