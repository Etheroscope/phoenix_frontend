defmodule Etheroscope.Notifier.Email do
  use Etheroscope.Util

  @behaviour Etheroscope.Notifier

  def url do
    Application.get_env(:etheroscope, :email_notifier_url)
  end

  def notify(address, variable) do
    notify(%{
      contract_address: address,
      variable: variable
    })
  end
  def notify(payload = %{contract_address: _addr, variable: _var}) do
    encoded_payload = Poison.encode!(payload)
    case HTTPoison.post(url() <> "/notify", encoded_payload) do
      {:ok, %HTTPoison.Response{body: _body, status_code: 200}} ->
        :ok
      {:ok, %HTTPoison.Response{body: body, status_code: _st}} ->
        {:error, "[NOTIFIER] Bad Response - " <> inspect(body)}
      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end
  def notify(_), do: {:error, "[NOTIFIER] Bad Parameters"}

  def subscribe(payload = %{email_address: _email, contract_address: _addr, variable: _var}) do
    encoded_payload = Poison.encode!(payload)
    case HTTPoison.put(url() <> "/store", encoded_payload) do
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
