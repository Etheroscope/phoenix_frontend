defmodule EtheroscopeEth.Parity.Contract do
  use Etheroscope.Util, :parity
  alias EtheroscopeEth.Parity
  alias EtheroscopeEth.Parity.Block

  @behaviour EtheroscopeEth.Parity.Resource

  @api_base_url "https://api.etherscan.io"

  defp handle_etherscan_error(do: block) do
    Etheroscope.Util.Error.handle_error "There seems to be an issue with Etherscan", do: block
  end

  @spec fetch(binary()) :: {:ok, map()} | Error.t
  def fetch(contract_address) do
    handle_etherscan_error do
      api_key = Application.get_env(:etheroscope, :etherscan_api_key)
      url = "#{@api_base_url}/api?module=contract&action=getabi&address=#{contract_address}&apikey=#{api_key}"

      Logger.info "Fetching: contract #{contract_address}"

      with {:ok, resp}                             <- HTTPoison.get(url),
          %{"message" => "OK", "result" => result} <- Poison.decode!(resp.body),
          abi                                       = result |> Poison.decode!
      do
        Logger.info "Fetched: contract #{contract_address}"
        {:ok, %{address: contract_address, abi: abi}}
      else
        body = %{"message" => "NOTOK"} ->
          Logger.error "Fetching contract #{contract_address} failed."
          {:error, %{msg: "Error with Etherscan", body: body}}
      end
    end
  end

  @spec fetch_early_blocks(binary()) :: {:ok, MapSet.t()} | Error.t
  def fetch_early_blocks(address) do
    fetch_blocks(address, Block.start_block)
  end

  @spec fetch_latest_blocks(binary(), integer()) :: {:ok, MapSet.t()} | Error.t
  def fetch_latest_blocks(address, block) do
    fetch_blocks(address, block)
  end

  defp fetch_blocks(address, block_num) when is_integer(block_num) do
    fetch_blocks(address, Hex.to_hex block_num)
  end
  defp fetch_blocks(address, block_num) do
    Logger.info "Fetching: block numbers for #{address}"
    case address |> format_filter_params(block_num) |> Parity.trace_filter do
      {:ok, ts} ->
        Logger.info "Fetched: block numbers for #{address}"
        {:ok, block_numbers(ts)}
      {:error, err} ->
        Logger.error "Fetching block numbers #{address} failed with error #{err}"
        Error.build_error(err, "Error fetching block numbers in EtheroscopeEth.Parity.Contract.fetch_block_numbers(#{address})")
    end
  end

  defp format_filter_params(address, block_num) do
      %{ "toAddress" => [address], "fromBlock" => block_num }
  end
end
