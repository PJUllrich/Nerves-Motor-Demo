defmodule PiSensor do
  @moduledoc """
  Documentation for PiSensor.
  """

  require Logger

  alias Circuits.GPIO

  @pins [5, 6, 13, 26]

  def start(count) do
    pins = []
    Logger.info("Pins before: #{pins}")

    pins =
      for pin <- @pins do
        Logger.info("Starting pin #{pin} as output")
        {:ok, gpio} = GPIO.open(pin, :output)
        pins = pins ++ gpio
        pins
      end

    Logger.info("Pins after: #{inspect(pins)}")
    Logger.info("Starting the motor. Hold on to your butts!")

    spawn(fn -> step(count, pins) end)
    {:ok, self()}
  end

  defp step(0, pins) do
    Logger.info("End reached. Closing the pin connections...")

    for pin <- pins do
      GPIO.write(pin, 0)
      GPIO.close(pin)
    end

    Logger.info("Pin connections closed. Good bye.")
  end

  defp step(round, pins) do
    Logger.info("Round Nr: #{round}")

    next_idx = rem(round, length(pins))
    prev_idx = if next_idx == 0, do: 3, else: next_idx - 1

    next_pin = Enum.at(pins, next_idx)
    prev_pin = Enum.at(pins, prev_idx)

    Logger.info("Turning Pin #{prev_idx}: OFF and #{next_idx}: ON")
    GPIO.write(prev_pin, 0)
    GPIO.write(next_pin, 1)

    Process.sleep(2)
    step(round - 1, pins)
  end
end
