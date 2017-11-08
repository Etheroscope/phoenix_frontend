defmodule EtheroscopeEth.Parity do
  import Ethereumex.HttpClient

  @valid_filter_params ["fromBlock", "toBlock", "fromAddress", "toAddress"]

  def filter(params) do
    # TODO: implement
  end

  def validate_filter_params(params) do
    is_valid_param(Map.keys(params))
  end

  defp is_valid_param([]), do: true
  defp is_valid_param([p | ps]) when p in @valid_filter_params, do: is_valid_param(ps)
  defp is_valid_param(_),  do: false

end
