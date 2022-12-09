defmodule Day9.Puzzle2Test do
  use ExUnit.Case
  doctest Day9.Puzzle2

  @test_input ["R 5", "U 8", "L 8", "D 3", "R 17", "D 10", "L 25", "U 20"] |> Enum.join("\n")

  describe "puzzle 2" do
    test "parse input" do
      assert @test_input |> Day9.Puzzle2.parse() ==
               (:right |> List.duplicate(5)) ++
                 (:up |> List.duplicate(8)) ++
                 (:left |> List.duplicate(8)) ++
                 (:down |> List.duplicate(3)) ++
                 (:right |> List.duplicate(17)) ++
                 (:down |> List.duplicate(10)) ++
                 (:left |> List.duplicate(25)) ++
                 (:up |> List.duplicate(20))
    end

    test "move right once" do
      assert Day9.Puzzle2.compute_path([:right], 10) == [
               [{0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}],
               [{1, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}]
             ]
    end

    test "move right 4 times" do
      assert Day9.Puzzle2.compute_path([:right, :right, :right, :right], 10) == [
               [{0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}],
               [{1, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}],
               [{2, 0}, {1, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}],
               [{3, 0}, {2, 0}, {1, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}],
               [{4, 0}, {3, 0}, {2, 0}, {1, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}]
             ]
    end

    test "move right 10 times" do
      assert Day9.Puzzle2.compute_path(List.duplicate(:right, 10), 10) == [
               [{0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}],
               [{1, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}],
               [{2, 0}, {1, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}],
               [{3, 0}, {2, 0}, {1, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}],
               [{4, 0}, {3, 0}, {2, 0}, {1, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}],
               [{5, 0}, {4, 0}, {3, 0}, {2, 0}, {1, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}],
               [{6, 0}, {5, 0}, {4, 0}, {3, 0}, {2, 0}, {1, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}],
               [{7, 0}, {6, 0}, {5, 0}, {4, 0}, {3, 0}, {2, 0}, {1, 0}, {0, 0}, {0, 0}, {0, 0}],
               [{8, 0}, {7, 0}, {6, 0}, {5, 0}, {4, 0}, {3, 0}, {2, 0}, {1, 0}, {0, 0}, {0, 0}],
               [{9, 0}, {8, 0}, {7, 0}, {6, 0}, {5, 0}, {4, 0}, {3, 0}, {2, 0}, {1, 0}, {0, 0}],
               [{10, 0}, {9, 0}, {8, 0}, {7, 0}, {6, 0}, {5, 0}, {4, 0}, {3, 0}, {2, 0}, {1, 0}]
             ]
    end

    test "diagonal moves" do
      assert [{2, 2}, {1, 1}, {0, 0}] |> Day9.Puzzle2.move(:up) == [{2, 3}, {2, 2}, {1, 1}]
      assert [{2, 2}, {3, 3}, {4, 4}] |> Day9.Puzzle2.move(:down) == [{2, 1}, {2, 2}, {3, 3}]
      assert [{2, 2}, {1, 3}, {0, 4}] |> Day9.Puzzle2.move(:right) == [{3, 2}, {2, 2}, {1, 3}]
      assert [{2, 2}, {3, 3}, {4, 4}] |> Day9.Puzzle2.move(:down) == [{2, 1}, {2, 2}, {3, 3}]
      assert [{2, 2}, {3, 3}, {4, 4}] |> Day9.Puzzle2.move(:left) == [{1, 2}, {2, 2}, {3, 3}]
      assert [{5, 1}, {4, 0}, {3, 0}] |> Day9.Puzzle2.move(:up) == [{5, 2}, {5, 1}, {4, 1}]
    end

    test "head sumperimposing" do
      assert [{2, 2}, {2, 1}, {1, 1}] |> Day9.Puzzle2.move(:down) == [{2, 1}, {2, 1}, {1, 1}]

      assert [{2, 2}, {2, 3}, {2, 4}, {2, 5}, {3, 5}, {3, 4}, {3, 3}, {3, 2}]
             |> Day9.Puzzle2.move(:right) == [
               {3, 2},
               {2, 3},
               {2, 4},
               {2, 5},
               {3, 5},
               {3, 4},
               {3, 3},
               {3, 2}
             ]
    end

    test "count positions after one move" do
      assert Day9.Puzzle2.launch("R 1", 10) == 1
    end

    test "count positions after moving right 10 times" do
      assert Day9.Puzzle2.launch("R 10", 10) == 2
    end

    test "puzzle2 example" do
      assert Day9.Puzzle2.launch(@test_input, 10) == 36
    end
  end
end
