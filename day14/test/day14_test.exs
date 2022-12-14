defmodule Day14Test do
  use ExUnit.Case
  doctest Day14

  describe "common" do
    test "parse input" do
      input = ["498,4 -> 498,6 -> 496,6", "503,4 -> 502,4 -> 502,9 -> 494,9"] |> Enum.join("\n")

      {grid, max_y} = Day14.parse(input)

      assert grid == %{
               {498, 4} => :wall,
               {498, 5} => :wall,
               {498, 6} => :wall,
               {497, 6} => :wall,
               {496, 6} => :wall,
               {503, 4} => :wall,
               {502, 4} => :wall,
               {502, 5} => :wall,
               {502, 6} => :wall,
               {502, 7} => :wall,
               {502, 8} => :wall,
               {502, 9} => :wall,
               {501, 9} => :wall,
               {500, 9} => :wall,
               {499, 9} => :wall,
               {498, 9} => :wall,
               {497, 9} => :wall,
               {496, 9} => :wall,
               {495, 9} => :wall,
               {494, 9} => :wall
             }

      assert max_y == 9
    end
  end

  describe "puzzle1" do
    test "get next resting point (example)" do
      input = ["498,4 -> 498,6 -> 496,6", "503,4 -> 502,4 -> 502,9 -> 494,9"] |> Enum.join("\n")
      {grid, max_y} = Day14.parse(input)

      {grid, next_resting_point} = grid |> Day14.get_next_resting_point(max_y, :puzzle1)

      assert next_resting_point == {500, 8}
      assert grid |> Map.get({500, 8}) == :sand
    end

    test "update example with 25 grains" do
      input = ["498,4 -> 498,6 -> 496,6", "503,4 -> 502,4 -> 502,9 -> 494,9"] |> Enum.join("\n")
      {grid, max_y} = Day14.parse(input)

      {updated_grid, next_resting_point} =
        1..25
        |> Enum.reduce({grid, nil}, fn _idx, {acc, _} ->
          acc |> Day14.get_next_resting_point(max_y, :puzzle1)
        end)

      assert updated_grid == %{
               {494, 9} => :wall,
               {495, 8} => :sand,
               {495, 9} => :wall,
               {496, 6} => :wall,
               {496, 9} => :wall,
               {497, 5} => :sand,
               {497, 6} => :wall,
               {497, 8} => :sand,
               {497, 9} => :wall,
               {498, 4} => :wall,
               {498, 5} => :wall,
               {498, 6} => :wall,
               {498, 7} => :sand,
               {498, 8} => :sand,
               {498, 9} => :wall,
               {499, 3} => :sand,
               {499, 4} => :sand,
               {499, 5} => :sand,
               {499, 6} => :sand,
               {499, 7} => :sand,
               {499, 8} => :sand,
               {499, 9} => :wall,
               {500, 2} => :sand,
               {500, 3} => :sand,
               {500, 4} => :sand,
               {500, 5} => :sand,
               {500, 6} => :sand,
               {500, 7} => :sand,
               {500, 8} => :sand,
               {500, 9} => :wall,
               {501, 3} => :sand,
               {501, 4} => :sand,
               {501, 5} => :sand,
               {501, 6} => :sand,
               {501, 7} => :sand,
               {501, 8} => :sand,
               {501, 9} => :wall,
               {502, 4} => :wall,
               {502, 5} => :wall,
               {502, 6} => :wall,
               {502, 7} => :wall,
               {502, 8} => :wall,
               {502, 9} => :wall,
               {503, 4} => :wall
             }

      assert next_resting_point == {493, :inf}
    end

    test "launch puzzle1 on example" do
      input = ["498,4 -> 498,6 -> 496,6", "503,4 -> 502,4 -> 502,9 -> 494,9"] |> Enum.join("\n")

      result = input |> Day14.launch(:puzzle1)

      assert result == 24
    end
  end

  describe "puzzle2" do
    test "get next resting point" do
      input = ["498,4 -> 498,6 -> 496,6"] |> Enum.join("\n")
      {grid, max_y} = Day14.parse(input)

      {grid, next_resting_point} = grid |> Day14.get_next_resting_point(max_y, :puzzle2)

      assert next_resting_point == {500, 7}
      assert grid |> Map.get({500, 7}) == :sand
    end

    test "launch puzzle2 on example" do
      input = ["498,4 -> 498,6 -> 496,6", "503,4 -> 502,4 -> 502,9 -> 494,9"] |> Enum.join("\n")

      result = input |> Day14.launch(:puzzle2)

      assert result == 93
    end
  end
end
