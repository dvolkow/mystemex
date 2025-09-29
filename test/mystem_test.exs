defmodule MystemTest do
  use ExUnit.Case
  doctest Mystem

  test "greets the world" do
    assert Mystem.hello() == :world
  end
end
