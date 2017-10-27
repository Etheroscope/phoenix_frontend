defmodule EtheroscopeDBTest do
  use ExUnit.Case
  doctest EtheroscopeDB

  test "greets the world" do
    assert EtheroscopeDB.hello() == :world
  end
end
