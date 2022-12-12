defmodule Day12Test do
  use ExUnit.Case
  doctest Day12

  describe "common" do
    test "parse input (example)" do
      input = ["Sabqponm", "abcryxxl", "accszExk", "acctuvwj", "abdefghi"] |> Enum.join("\n")

      {start_position, end_position, grid} = Day12.parse(input)

      assert start_position == {0, 0}
      assert end_position == {5, 2}

      assert grid == %{
               {0, 0} => 0,
               {0, 1} => 0,
               {0, 2} => 0,
               {0, 3} => 0,
               {0, 4} => 0,
               {1, 0} => 0,
               {1, 1} => 1,
               {1, 2} => 2,
               {1, 3} => 2,
               {1, 4} => 1,
               {2, 0} => 1,
               {2, 1} => 2,
               {2, 2} => 2,
               {2, 3} => 2,
               {2, 4} => 3,
               {3, 0} => 16,
               {3, 1} => 17,
               {3, 2} => 18,
               {3, 3} => 19,
               {3, 4} => 4,
               {4, 0} => 15,
               {4, 1} => 24,
               {4, 2} => 25,
               {4, 3} => 20,
               {4, 4} => 5,
               {5, 0} => 14,
               {5, 1} => 23,
               {5, 2} => 25,
               {5, 3} => 21,
               {5, 4} => 6,
               {6, 0} => 13,
               {6, 1} => 23,
               {6, 2} => 23,
               {6, 3} => 22,
               {6, 4} => 7,
               {7, 0} => 12,
               {7, 1} => 11,
               {7, 2} => 10,
               {7, 3} => 9,
               {7, 4} => 8
             }
    end
  end

  describe "puzzle1" do
    test "get possible moves" do
      starting_positions = [{2, 2}, {1, 1}, {0, 0}]

      grid = %{
        {0, 0} => 0,
        {0, 1} => -1,
        {0, 2} => 0,
        {1, 0} => 2,
        {1, 1} => 1,
        {1, 2} => 3,
        {2, 0} => 0,
        {2, 1} => 3,
        {2, 2} => 1
      }

      moves = starting_positions |> Enum.map(fn pos -> pos |> Day12.get_moves(grid, :puzzle1) end)

      assert moves == [[], [{1, 0}, {0, 1}], [{0, 1}]]
    end

    test "BFS, one step" do
      queue = [{{2, 0}, 1}, {{0, 0}, 1}, {{1, 1}, 1}]
      visited = MapSet.new([{{1, 0}, 0}])

      grid = %{
        {0, 0} => 0,
        {0, 1} => -1,
        {0, 2} => 0,
        {1, 0} => 2,
        {1, 1} => 1,
        {1, 2} => 3,
        {2, 0} => 0,
        {2, 1} => 3,
        {2, 2} => 1
      }

      {queue, visited} = {queue, visited} |> Day12.bfs_step(grid, :puzzle1)

      assert queue == [{{0, 1}, 2}, {{2, 0}, 1}, {{0, 0}, 1}]
      assert visited == MapSet.new([{{1, 1}, 1}, {{1, 0}, 0}])
    end

    test "BFS (small grid)" do
      starting_position = {0, 0}
      destination = {2, 0}

      grid = %{
        {0, 0} => 0,
        {0, 1} => -1,
        {0, 2} => 0,
        {1, 0} => 1,
        {1, 1} => 1,
        {1, 2} => 3,
        {2, 0} => 0,
        {2, 1} => 3,
        {2, 2} => 1,
        {3, 0} => 1,
        {3, 1} => 2,
        {3, 2} => 1
      }

      {queue, visited} = {starting_position, [destination]} |> Day12.bfs(grid, :puzzle1)

      assert queue == []

      assert visited ==
               MapSet.new([
                 {{0, 0}, 0},
                 {{0, 1}, 1},
                 {{1, 0}, 1},
                 {{0, 2}, 2},
                 {{1, 1}, 2},
                 {{2, 0}, 2},
                 {{3, 0}, 3},
                 {{3, 1}, 4},
                 {{3, 2}, 5},
                 {{2, 1}, 5},
                 {{2, 2}, 6}
               ])
    end

    test "bfs on example grid" do
      {start_position, end_position, grid} =
        ["Sabqponm", "abcryxxl", "accszExk", "acctuvwj", "abdefghi"]
        |> Enum.join("\n")
        |> Day12.parse()

      {queue, visited} = {start_position, [end_position]} |> Day12.bfs(grid, :puzzle1)

      found = visited |> Enum.find(fn {el, _depth} -> el == {5, 2} end)
      assert queue == []
      assert found == {{5, 2}, 31}
    end

    test "launch puzzle1" do
      input = ["Sabqponm", "abcryxxl", "accszExk", "acctuvwj", "abdefghi"] |> Enum.join("\n")

      assert input |> Day12.launch(:puzzle1) == 31
    end
  end

  describe "puzzle2" do
    test "launch puzzle2" do
      input = ["Sabqponm", "abcryxxl", "accszExk", "acctuvwj", "abdefghi"] |> Enum.join("\n")

      assert input |> Day12.launch(:puzzle2) == 29
    end
  end
end
