defmodule Day5Test do
  use ExUnit.Case
  alias Day5
  doctest Day5

  describe "common" do
    test "parse sliced crate stacks" do
      input = "    [V]     [F] [F] [S] [S]        "

      result = Day5.parse_slice(input)

      assert result == [nil, "V", nil, "F", "F", "S", "S", nil, nil]
    end

    test "parse stacks definition" do
      input = ["    [D]    ", "[N] [C]    ", "[Z] [M] [P]", " 1   2   3 "]

      result = Day5.parse_stacks(input)

      assert result == %{1 => ["Z", "N"], 2 => ["M", "C", "D"], 3 => ["P"]}
    end

    test "parse move" do
      input = "move 3 from 4 to 3"

      result = Day5.parse_move(input)

      assert result == %{how_many: 3, from: 4, to: 3}
    end

    test "parse moves" do
      input = ["move 3 from 4 to 3", "move 1 from 2 to 3", "move 1 from 2 to 3"]

      result = Day5.parse_moves(input)

      assert result == [
               %{how_many: 3, from: 4, to: 3},
               %{how_many: 1, from: 2, to: 3},
               %{how_many: 1, from: 2, to: 3}
             ]
    end
  end

  describe "puzzle1" do
    test "perform move (1 crate)" do
      stacks = %{1 => ["Z", "N"], 2 => ["M", "C", "D"], 3 => ["P"]}

      updated_stacks = stacks |> Day5.move(1, 2, 3, :puzzle1)

      assert updated_stacks == %{1 => ["Z", "N"], 2 => ["M", "C"], 3 => ["P", "D"]}
    end

    test "perform move (2 crates)" do
      stacks = %{1 => ["Z", "N"], 2 => ["M", "C", "D"], 3 => ["P"]}

      updated_stacks = stacks |> Day5.move(2, 2, 3, :puzzle1)

      assert updated_stacks == %{1 => ["Z", "N"], 2 => ["M"], 3 => ["P", "D", "C"]}
    end

    test "launch task" do
      input =
        [
          "    [D]    ",
          "[N] [C]    ",
          "[Z] [M] [P]",
          " 1   2   3 ",
          "",
          "move 1 from 2 to 1",
          "move 3 from 1 to 3",
          "move 2 from 2 to 1",
          "move 1 from 1 to 2"
        ]
        |> Enum.join("\n")

      result = Day5.parse(input, :puzzle1)

      assert result == "CMZ"
    end
  end

  describe "puzzle2" do
    test "perform move (1 crate)" do
      stacks = %{1 => ["Z", "N"], 2 => ["M", "C", "D"], 3 => ["P"]}

      updated_stacks = stacks |> Day5.move(1, 2, 3, :puzzle2)

      assert updated_stacks == %{1 => ["Z", "N"], 2 => ["M", "C"], 3 => ["P", "D"]}
    end

    test "perform move (2 crates)" do
      stacks = %{1 => ["Z", "N"], 2 => ["M", "C", "D"], 3 => ["P"]}

      updated_stacks = stacks |> Day5.move(2, 2, 3, :puzzle2)

      assert updated_stacks == %{1 => ["Z", "N"], 2 => ["M"], 3 => ["P", "C", "D"]}
    end

    test "launch task" do
      input =
        [
          "    [D]    ",
          "[N] [C]    ",
          "[Z] [M] [P]",
          " 1   2   3 ",
          "",
          "move 1 from 2 to 1",
          "move 3 from 1 to 3",
          "move 2 from 2 to 1",
          "move 1 from 1 to 2"
        ]
        |> Enum.join("\n")

      result = Day5.parse(input, :puzzle2)

      assert result == "MCD"
    end
  end
end
