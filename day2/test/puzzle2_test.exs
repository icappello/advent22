defmodule Puzzle2Test do
  use ExUnit.Case
  alias Puzzle2

  test "single round, draw" do
    input = "A Y"

    result = Puzzle2.compute(input)

    assert result == 4
  end

  test "multiple rounds, win draw loss" do
    input = ["A Y", "B X", "C Z"] |> Enum.join("\n")

    result = Puzzle2.compute(input)

    assert result == 12
  end

  test "possible round combinations" do
    input = ["A Y", "A X", "A Z", "B Y", "B X", "B Z", "C Y", "C X", "C Z"] |> Enum.join("\n")

    result = Puzzle2.compute(input)

    assert result == 45
  end
end
