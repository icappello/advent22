defmodule Puzzle1Test do
  use ExUnit.Case
  alias Puzzle1

  test "divide the strings in half" do
    inputs = ["vJrwpWtwJgWrhcsFMMfFFhFp", "jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL", "PmmdzqPrVvPwwTWBwg"]

    partitioned = inputs |> Enum.map(fn input -> Puzzle1.split(input) end)

    assert partitioned == [{"vJrwpWtwJgWr", "hcsFMMfFFhFp"}, {"jqHRNqRjqzjGDLGL", "rsFMfFZSrLrFZsSL"}, {"PmmdzqPrV", "vPwwTWBwg"}]
  end

  test "find the common part" do
    inputs = [{"vJrwpWtwJgWr", "hcsFMMfFFhFp"}, {"jqHRNqRjqzjGDLGL", "rsFMfFZSrLrFZsSL"}, {"PmmdzqPrV", "vPwwTWBwg"}]

    common = inputs |> Enum.map(fn input -> Puzzle1.find_common(input) end)

    assert common == ["p", "L", "P"]
  end


  test "convert the strings to scores" do
    inputs = ["vJrwpWtwJgWrhcsFMMfFFhFp", "jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL", "PmmdzqPrVvPwwTWBwg"]

    scores = inputs |> Enum.map(fn input -> Puzzle1.score_line(input) end)

    assert scores == [16, 38, 42]
  end


  test "compute the overall score for input" do
    input = ["vJrwpWtwJgWrhcsFMMfFFhFp", "jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL", "PmmdzqPrVvPwwTWBwg", "wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn", "ttgJtRGJQctTZtZT", "CrZsJsPPZsGzwwsLwLmpwMDw"] |> Enum.join("\n")

    score = Puzzle1.score_input(input)

    assert score == 157
  end
end
