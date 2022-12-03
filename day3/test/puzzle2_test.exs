defmodule Puzzle2Test do
  use ExUnit.Case
  alias Puzzle2

  test "find common value between lists of strings" do
    inputs = [
      ["vJrwpWtwJgWrhcsFMMfFFhFp", "jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL", "PmmdzqPrVvPwwTWBwg"],
      ["wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn", "ttgJtRGJQctTZtZT", "CrZsJsPPZsGzwwsLwLmpwMDw"]
    ]

    results = inputs |> Enum.map(fn input -> Puzzle2.find_common(input) end)

    assert results == ["r", "Z"]
  end

  test "score lists of strings" do
    inputs = [
      ["vJrwpWtwJgWrhcsFMMfFFhFp", "jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL", "PmmdzqPrVvPwwTWBwg"],
      ["wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn", "ttgJtRGJQctTZtZT", "CrZsJsPPZsGzwwsLwLmpwMDw"]
    ]

    result = inputs |> Enum.map(fn input -> Puzzle2.score_group(input) end)

    assert result == [18, 52]
  end

  test "score input" do
    input =
      [
        "vJrwpWtwJgWrhcsFMMfFFhFp",
        "jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL",
        "PmmdzqPrVvPwwTWBwg",
        "wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn",
        "ttgJtRGJQctTZtZT",
        "CrZsJsPPZsGzwwsLwLmpwMDw"
      ]
      |> Enum.join("\n")

    result = Puzzle2.score_input(input)

    assert result == 70
  end
end
