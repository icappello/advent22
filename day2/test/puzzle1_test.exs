defmodule Puzzle1Test do
  use ExUnit.Case
  alias Puzzle1

  test "single round, win" do
    input = "A Y"

    result = Puzzle1.compute(input)

    assert result == 8
  end

  test "multiple rounds, win draw loss" do
    input = ["A Y", "B X", "C Z"] |> Enum.join("\n")

    result = Puzzle1.compute(input)

    assert result == 15
  end

  test "possible round combinations" do
    input = ["A Y", "A X", "A Z", "B Y", "B X", "B Z", "C Y", "C X", "C Z"] |> Enum.join("\n")

    result = Puzzle1.compute(input)

    assert result == 45
  end
end
