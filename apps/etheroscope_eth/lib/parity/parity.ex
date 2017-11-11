defmodule EtheroscopeEth.Parity do
  import Ethereumex.HttpClient
  use Etheroscope.Utils

  @valid_filter_params ["fromBlock", "toBlock", "fromAddress", "toAddress"]

  @spec trace_filter(map()) :: {:ok, String.t} | Error.t
  def trace_filter(params) do
    with true          <- validate_filter_params(params),
         {:ok, result} <- request("trace_filter", [params], [])
    do
      Logger.info result
      {:ok, result}
    else
      false         -> {:error, "Invalid parameters"}
      {:error, msg} -> {:error, "The following error occured when requesting the filter: #{msg}"}
    end
  end

  @spec validate_filter_params(map()) :: boolean
  def validate_filter_params(params), do: is_valid_param(Map.keys(params))

  defp is_valid_param([]), do: true
  defp is_valid_param([p | ps]) when p in @valid_filter_params, do: is_valid_param(ps)
  defp is_valid_param(_),  do: false

end
