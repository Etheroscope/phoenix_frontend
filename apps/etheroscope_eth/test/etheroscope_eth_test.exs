defmodule EtheroscopeEthTest do
  use ExUnit.Case
  doctest EtheroscopeEth

  test "greets the world" do
    assert EtheroscopeEth.hello() == :world
  end
end
