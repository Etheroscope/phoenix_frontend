defmodule Etheroscope.Contract do
  @moduledoc """
  Etheroscope.Contract defines the business logic behind handling and
  transforming data as well as business logic.
  """

  def fetch_history(contract_address, method) do
    case Etheroscope.Cache.find_history(contract_address, method) do
      {:ok, value} -> value
      {:error, _none} ->
        %{}
    end
  end

end
