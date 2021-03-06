defmodule EtheroscopeEth.Parity.Contract do
  use Etheroscope.Util, :parity
  alias EtheroscopeEth.Parity.Block

  @behaviour Etheroscope.Resource

  @api_base_url "https://api.etherscan.io"

  defp handle_etherscan_error(do: block) do
    Etheroscope.Util.Error.handle_error "There seems to be an issue with Etherscan", do: block
  end

  def next_storage_module, do: nil

  def get([address: contract_address]) do
    handle_etherscan_error do
      api_key = Application.get_env(:etheroscope, :etherscan_api_key)
      url = "#{@api_base_url}/api?module=contract&action=getabi&address=#{contract_address}&apikey=#{api_key}"

      # Logger.info "Fetching: contract #{contract_address}"

      with {:ok, resp}                             <- HTTPoison.get(url),
          %{"message" => "OK", "result" => result} <- Poison.decode!(resp.body),
          abi                                       = result |> Poison.decode!
      do
        # Logger.info "Fetched: contract #{contract_address}"
        {:ok, abi}
      else
        %{"message" => "NOTOK"} ->
          {:error, :not_found}
        {:error, %HTTPoison.Error{reason: :nxdomain}} ->
          Error.build_error_eth([], "No Domain: can't connect to #{url}")
      end
    end
  end

  @spec fetch_early_blocks(binary()) :: {:ok, MapSet.t()} | Error.t
  def fetch_early_blocks(address), do: Block.fetch_full_history(address)

  @spec fetch_latest_blocks(binary(), integer()) :: {:ok, MapSet.t()} | Error.t
  def fetch_latest_blocks(address, latest_block), do: Block.get({address, latest_block})
end
