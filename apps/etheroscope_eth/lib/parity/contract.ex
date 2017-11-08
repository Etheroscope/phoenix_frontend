defmodule EtheroscopeEth.Parity.Contract do
  @api_base_url "https://api.etherscan.io"
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
    api_key = Application.get_env(:etheroscope, :etherscan_api_key)
    url = "#{@api_base_url}/api?module=contract&action=getabi&address=#{contract_address}&apikey=#{api_key}"
    case HTTPoison.get(url) do
      {:error, msg} -> {:error, msg}
      {:ok, response} ->
        response_body = Poison.decode!(response.body)

        if (response_body["result"] == "") do
          {:ok, %{:variables => [], :error => "No ABI found"}}
        else
          contract_abi = Poison.decode!(response_body["result"])
          variables = Enum.filter(contract_abi, &abi_item_is_variable/1)
          var_names = Enum.map(variables, fn (var) -> var["name"] end);
          {:ok, %{:variables => var_names}}
        end
    end
  end

  def fetch_history(contract_address) do
    {
      :ok,
      %{
        :test => "Hello world (history)",
        :contract_address => contract_address
      }
    }
  end
end
