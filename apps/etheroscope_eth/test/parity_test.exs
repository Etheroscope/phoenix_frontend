defmodule ParityTest do
  use ExUnit.Case
  doctest EtheroscopeEth.Parity

  @tag :filter
  test "validates correct filter params" do
    assert EtheroscopeEth.Parity.validate_filter_params(%{})
    assert EtheroscopeEth.Parity.validate_filter_params(%{"fromBlock" => "0xtest"})
    assert EtheroscopeEth.Parity.validate_filter_params(%{"fromBlock" => "0xtest", "toAddress" => "0xaddr_test"})
  end

  @tag :filter
  test "invalidates incorrect filter params" do
    refute EtheroscopeEth.Parity.validate_filter_params(%{"blah" => "blah"})
    refute EtheroscopeEth.Parity.validate_filter_params(%{fromBlock: "0xtest"})
  end
end
