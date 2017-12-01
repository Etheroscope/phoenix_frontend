defmodule Etheroscope.Notifier.Email do
  use Etheroscope.Util

  @behaviour Etheroscope.Notifier

  def url do
    Application.get_env(:etheroscope, :email_notifier_url)
  end

  def notify(address, variable) do
    notify(%{
      contract: address,
      variable: variable
    })
  end
  def notify(payload = %{contract: addr, variable: var}) do
    encoded_payload = Poison.encode!(payload)
    case HTTPoison.post(url() <> "/notify?contract=#{addr}&variable=#{var}", encoded_payload, [{"Content-Type", "application/json"}]) do
      {:ok, %HTTPoison.Response{body: _body, status_code: 200}} ->
        :ok
      {:ok, %HTTPoison.Response{body: body, status_code: _st}} ->
        {:error, "[NOTIFIER] Bad Response - " <> inspect(body)}
      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end
  def notify(_), do: {:error, "[NOTIFIER] Bad Parameters"}

  def subscribe(email, contract, variable) do
    notify(%{
      email_address: email,
      contract: contract,
      variable: variable
    })
  end
  def subscribe(payload = %{email_address: email, contract: addr, variable: var}) do
    encoded_payload = Poison.encode!(payload)
    Logger.info encoded_payload
    Logger.info url() <> "/store"
    case HTTPoison.put(url() <> "/store?email_address=#{email}&contract=#{addr}&variable=#{var}", encoded_payload, [{"Content-Type", "application/json"}]) do
      {:ok, %HTTPoison.Response{body: _body, status_code: 200}} ->
        :ok
      {:ok, %HTTPoison.Response{body: body, status_code: _st}} ->
        {:error, "[NOTIFIER] Bad Response - " <> inspect(body)}
      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end
  def subscribe(_), do: {:error, "[NOTIFIER] Bad Parameters"}

end
