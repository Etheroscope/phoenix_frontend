# Etheroscope

App contain all business logic needed for backend.

## Secrets

To successfully run this application, you must have the following secrets in your `dev.secret.exs` and `prod.secret.exs`:

```elixir
config :etheroscope,
  etherscan_api_key: <ETHERSCAN_API_KEY>
```

## Structure

### lib

Where the magic happens. Create "contexts" within to separate the logic into groups. Look [here](https://hexdocs.pm/phoenix/contexts.html#content) for more information on how to use contexts.

### test

Test your code using the [ExUnit testing framework](https://hexdocs.pm/ex_unit/ExUnit.html).
