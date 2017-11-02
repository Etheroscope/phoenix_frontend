defmodule Etheroscope.Contract do
  @allowed_types [
    "uint",
    "uint8",
    "uint16",
    "uint32",
    "uint64",
    "uint128",
    "uint256",
    "int",
    "int8",
    "int16",
    "int32",
    "int64",
    "int128",
    "int256"
  ]

  def abi_item_is_variable(abi_item) do
    abi_item["type"] == "function" and length(abi_item["inputs"]) == 0
    and length(abi_item["outputs"]) == 1
    and Enum.member?(@allowed_types, Enum.at(abi_item["outputs"], 0)["type"])
  end

  def fetch_contract(contract_address) do
    IO.inspect Application.get_env(:etheroscope, :etherscan_api_key)
    url = "https://api.etherscan.io/api?module=contract&action=getabi&address="
      <> contract_address <> "&apikey=" <> Application.get_env(:etheroscope, :etherscan_api_key)
    {:ok, response} = HTTPoison.get(url)
    response_body = Poison.decode!(response.body)

    if (response_body["result"] == "") do
      %{:variables => [], :error => "No ABI found"}
    else
      contract_abi = Poison.decode!(response_body["result"])
      variables = Enum.filter(contract_abi, &abi_item_is_variable/1)
      var_names = Enum.map(variables, fn (var) -> var["name"] end);
      %{:variables => var_names}
    end
  end

  def fetch_history(contract_address, variable) do

    %{
      :test => "Hello world (history)",
      :contract_address => contract_address,
      :variable => variable
    }
  end
end
