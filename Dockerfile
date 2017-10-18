FROM elixir: 1.4.2-slim

ENV HOME=/app

# Install/update mix, rebar, hex and Phoenix 1.3
RUN \
  mix local.hex --force && \
  mix local.rebar --force && \
  mix hex.info && \
  mix archive.install https://github.com/phoenixframework/archives/raw/master/phx_new.ez

ENV MIX_ENV=prod REPLACE_OS_VARS=true
WORKDIR /app

# Cache Elixir deps
COPY mix.exs mix.lock \
# RUN mkdir -p apps/
RUN mix do deps.update --all, deps.compile, phx.digest 


COPY . .

RUN mix release --profile=etheroscope_umbrella:prod --verbose && \
  tar xzf ./_build/prod/rel/etheroscope_umbrella/releases/**/etheroscope_umbrella.tar.gr && \
  rm -rf /_build ./apps ./mix.*
