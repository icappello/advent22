defmodule Day9.Puzzle1Test do
  use ExUnit.Case
  doctest Day9.Puzzle1

  @test_input ["R 4", "U 4", "L 3", "D 1", "R 4", "D 1", "L 5", "R 2"] |> Enum.join("\n")

  describe "puzzle1" do
    test "parse input" do
      assert @test_input |> Day9.Puzzle1.parse() ==
               (:right |> List.duplicate(4)) ++
                 (:up |> List.duplicate(4)) ++
                 (:left |> List.duplicate(3)) ++
                 (:down |> List.duplicate(1)) ++
                 (:right |> List.duplicate(4)) ++
                 (:down |> List.duplicate(1)) ++
                 (:left |> List.duplicate(5)) ++
                 (:right |> List.duplicate(2))
    end

    test "move the head from superimposition" do
      assert {{0, 0}, {0, 0}} |> Day9.Puzzle1.move(:right) == {{1, 0}, {0, 0}}
      assert {{0, 0}, {0, 0}} |> Day9.Puzzle1.move(:up) == {{0, 1}, {0, 0}}
      assert {{0, 0}, {0, 0}} |> Day9.Puzzle1.move(:down) == {{0, -1}, {0, 0}}
      assert {{0, 0}, {0, 0}} |> Day9.Puzzle1.move(:left) == {{-1, 0}, {0, 0}}
    end

    test "move the head into superimposition" do
      assert {{1, 1}, {2, 1}} |> Day9.Puzzle1.move(:right) == {{2, 1}, {2, 1}}
      assert {{1, 1}, {1, 2}} |> Day9.Puzzle1.move(:up) == {{1, 2}, {1, 2}}
      assert {{1, 1}, {1, 0}} |> Day9.Puzzle1.move(:down) == {{1, 0}, {1, 0}}
      assert {{1, 1}, {0, 1}} |> Day9.Puzzle1.move(:left) == {{0, 1}, {0, 1}}
    end

    test "moving head causes tail to follow" do
      assert {{1, 0}, {0, 0}} |> Day9.Puzzle1.move(:right) == {{2, 0}, {1, 0}}
      assert {{0, 1}, {0, 0}} |> Day9.Puzzle1.move(:up) == {{0, 2}, {0, 1}}
      assert {{0, 3}, {0, 4}} |> Day9.Puzzle1.move(:down) == {{0, 2}, {0, 3}}
      assert {{5, 3}, {6, 3}} |> Day9.Puzzle1.move(:left) == {{4, 3}, {5, 3}}
      assert {{5, 3}, {6, 4}} |> Day9.Puzzle1.move(:down) == {{5, 2}, {5, 3}}
      assert {{5, 3}, {6, 2}} |> Day9.Puzzle1.move(:up) == {{5, 4}, {5, 3}}
      assert {{5, 3}, {4, 2}} |> Day9.Puzzle1.move(:right) == {{6, 3}, {5, 3}}
      assert {{5, 3}, {6, 4}} |> Day9.Puzzle1.move(:left) == {{4, 3}, {5, 3}}
    end

    test "moving head right when tail is diagonal" do
      computed =
        [:right, :right, :right]
        |> Enum.reduce([{{0, 0}, {1, 1}}], fn move, [{head, tail} | _] = acc ->
          {head, tail} |> Day9.Puzzle1.path(move, acc)
        end)

      assert computed == [{{3, 0}, {2, 0}}, {{2, 0}, {1, 1}}, {{1, 0}, {1, 1}}, {{0, 0}, {1, 1}}]
    end

    test "moving head left when tail is diagonal" do
      computed =
        [:left, :left, :left]
        |> Enum.reduce([{{0, 0}, {-1, -1}}], fn move, [{head, tail} | _] = acc ->
          {head, tail} |> Day9.Puzzle1.path(move, acc)
        end)

      assert computed == [
               {{-3, 0}, {-2, 0}},
               {{-2, 0}, {-1, -1}},
               {{-1, 0}, {-1, -1}},
               {{0, 0}, {-1, -1}}
             ]
    end

    test "moving head up when tail is diagonal" do
      computed =
        [:up, :up, :up]
        |> Enum.reduce([{{0, 0}, {1, 1}}], fn move, [{head, tail} | _] = acc ->
          {head, tail} |> Day9.Puzzle1.path(move, acc)
        end)

      assert computed == [{{0, 3}, {0, 2}}, {{0, 2}, {1, 1}}, {{0, 1}, {1, 1}}, {{0, 0}, {1, 1}}]
    end

    test "moving head down when tail is diagonal" do
      computed =
        [:down, :down, :down]
        |> Enum.reduce([{{3, 3}, {2, 2}}], fn move, [{head, tail} | _] = acc ->
          {head, tail} |> Day9.Puzzle1.path(move, acc)
        end)

      assert computed == [{{3, 0}, {3, 1}}, {{3, 1}, {2, 2}}, {{3, 2}, {2, 2}}, {{3, 3}, {2, 2}}]
    end

    test "moving the head around the tail leaves the tail where it is" do
      computed =
        [:right, :down, :down, :left, :left, :up, :up, :right]
        |> Enum.reduce([{{4, 4}, {4, 3}}], fn move, [pos | _] = acc ->
          pos |> Day9.Puzzle1.path(move, acc)
        end)

      assert computed == [
               {{4, 4}, {4, 3}},
               {{3, 4}, {4, 3}},
               {{3, 3}, {4, 3}},
               {{3, 2}, {4, 3}},
               {{4, 2}, {4, 3}},
               {{5, 2}, {4, 3}},
               {{5, 3}, {4, 3}},
               {{5, 4}, {4, 3}},
               {{4, 4}, {4, 3}}
             ]
    end

    test "compute path for test input" do
      ["R 4", "U 4", "L 3", "D 1", "R 4", "D 1", "L 5", "R 2"]

      assert @test_input |> Day9.Puzzle1.parse() |> Day9.Puzzle1.compute_path() == [
               {{0, 0}, {0, 0}},
               {{1, 0}, {0, 0}},
               {{2, 0}, {1, 0}},
               {{3, 0}, {2, 0}},
               {{4, 0}, {3, 0}},
               {{4, 1}, {3, 0}},
               {{4, 2}, {4, 1}},
               {{4, 3}, {4, 2}},
               {{4, 4}, {4, 3}},
               {{3, 4}, {4, 3}},
               {{2, 4}, {3, 4}},
               {{1, 4}, {2, 4}},
               {{1, 3}, {2, 4}},
               {{2, 3}, {2, 4}},
               {{3, 3}, {2, 4}},
               {{4, 3}, {3, 3}},
               {{5, 3}, {4, 3}},
               {{5, 2}, {4, 3}},
               {{4, 2}, {4, 3}},
               {{3, 2}, {4, 3}},
               {{2, 2}, {3, 2}},
               {{1, 2}, {2, 2}},
               {{0, 2}, {1, 2}},
               {{1, 2}, {1, 2}},
               {{2, 2}, {1, 2}}
             ]
    end

    test "count unique tail positions" do
      assert @test_input
             |> Day9.Puzzle1.parse()
             |> Day9.Puzzle1.compute_path()
             |> Day9.Puzzle1.count_unique_tail_positions() == 13
    end

    test "launch puzzle1" do
      assert Day9.Puzzle1.launch(@test_input) == 13
    end
  end
end
