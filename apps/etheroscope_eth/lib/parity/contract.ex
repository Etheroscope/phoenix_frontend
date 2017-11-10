defmodule EtheroscopeEth.Parity.Contract do
  @behaviour EtheroscopeEth.Parity.Resource

  @api_base_url "https://api.etherscan.io"
  @allowed_types ["uint", "uint8", "uint16", "uint32", "uint64", "uint128", "uint256", "int", "int8", "int16", "int32", "int64", "int128", "int256"]

  def abi_item_is_variable(abi_item) do
    abi_item["type"] == "function" and length(abi_item["inputs"]) == 0
    and length(abi_item["outputs"]) == 1
    and Enum.member?(@allowed_types, Enum.at(abi_item["outputs"], 0)["type"])
  end

  def fetch(contract_address) do
    api_key = Application.get_env(:etheroscope, :etherscan_api_key)
    url = "#{@api_base_url}/api?module=contract&action=getabi&address=#{contract_address}&apikey=#{api_key}"

    with {:ok, resp} <- HTTPoison.get(url),
         ""          <- Poison.decode!(resp.body)["result"]
    do
      {:ok, %{:variables => [], :error => "No ABI found"}}
    else
      {:error, msg} -> {:error, msg}
      result ->
        var_names = result
                    |> Poison.decode!
                    |> Enum.filter(&abi_item_is_variable/1)
                    |> Enum.map(fn (var) -> var["name"] end);
        {:ok, %{:variables => var_names}}
    end
  end
end
