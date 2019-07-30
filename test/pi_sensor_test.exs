defmodule PiSensorTest do
  use ExUnit.Case
  doctest PiSensor

  test "greets the world" do
    assert PiSensor.hello() == :world
  end
end
