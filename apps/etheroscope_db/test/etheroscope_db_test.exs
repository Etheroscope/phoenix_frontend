defmodule EtheroscopeDbTest do
  use ExUnit.Case
  doctest EtheroscopeDb

  test "greets the world" do
    assert EtheroscopeDb.hello() == :world
  end
end
