defmodule Day13Test do
  use ExUnit.Case
  doctest Day13

  describe "common" do
    test "parse the input (one pair of plain lists)" do
      input = ["[1,1,3,1,1]", "[1,1,5,1,1]"] |> Enum.join("\n")

      parsed = Day13.parse(input)

      assert parsed == [{[1, 1, 3, 1, 1], [1, 1, 5, 1, 1]}]
    end

    test "parse the input (two pairs of nested lists)" do
      input =
        ["[1,1,3,[1,1]]", "[1,1,5,[1,1]]", "", "[[1],[2,3,4]]", "[[1],4]"] |> Enum.join("\n")

      parsed = Day13.parse(input)

      assert parsed == [{[1, 1, 3, [1, 1]], [1, 1, 5, [1, 1]]}, {[[1], [2, 3, 4]], [[1], 4]}]
    end

    test "compare pair" do
      input = [
        {[1, 1, 3, 1, 1], [1, 1, 5, 1, 1]},
        {[[1], [2, 3, 4]], [[1], 4]},
        {[9], [[8, 7, 6]]},
        {[[4, 4], 4, 4], [[4, 4], 4, 4, 4]},
        {[7, 7, 7, 7], [7, 7, 7]},
        {[], [3]},
        {[[[]]], [[]]},
        {[1, [2, [3, [4, [5, 6, 7]]]], 8, 9], [1, [2, [3, [4, [5, 6, 0]]]], 8, 9]}
      ]

      results = input |> Enum.map(fn pair -> Day13.compare_pair(pair) end)

      assert results == [
               {true, :done},
               {true, :done},
               {false, :done},
               {true, :done},
               {false, :done},
               {true, :done},
               {false, :done},
               {false, :done}
             ]
    end
  end

  describe "puzzle1" do
    test "launch puzzle1" do
      input =
        [
          "[1,1,3,1,1]",
          "[1,1,5,1,1]",
          "",
          "[[1],[2,3,4]]",
          "[[1],4]",
          "",
          "[9]",
          "[[8,7,6]]",
          "",
          "[[4,4],4,4]",
          "[[4,4],4,4,4]",
          "",
          "[7,7,7,7]",
          "[7,7,7]",
          "",
          "[]",
          "[3]",
          "",
          "[[[]]]",
          "[[]]",
          "",
          "[1,[2,[3,[4,[5,6,7]]]],8,9]",
          "[1,[2,[3,[4,[5,6,0]]]],8,9]"
        ]
        |> Enum.join("\n")

      assert input |> Day13.launch(:puzzle1) == 13
    end
  end

  describe "puzzle2" do
    test "launch puzzle2" do
      input =
        [
          "[1,1,3,1,1]",
          "[1,1,5,1,1]",
          "",
          "[[1],[2,3,4]]",
          "[[1],4]",
          "",
          "[9]",
          "[[8,7,6]]",
          "",
          "[[4,4],4,4]",
          "[[4,4],4,4,4]",
          "",
          "[7,7,7,7]",
          "[7,7,7]",
          "",
          "[]",
          "[3]",
          "",
          "[[[]]]",
          "[[]]",
          "",
          "[1,[2,[3,[4,[5,6,7]]]],8,9]",
          "[1,[2,[3,[4,[5,6,0]]]],8,9]"
        ]
        |> Enum.join("\n")

      assert input |> Day13.launch(:puzzle2) == 140
    end
  end
end
