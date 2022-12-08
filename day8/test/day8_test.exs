defmodule Day8Test do
  use ExUnit.Case
  doctest Day8

  @test_input ["30373", "25512", "65332", "33549", "35390"] |> Enum.join("\n")

  describe "common" do
    test "parse grid" do
      result = Day8.parse(@test_input)

      assert result == %{
               {0, 0} => 3,
               {1, 0} => 0,
               {2, 0} => 3,
               {3, 0} => 7,
               {4, 0} => 3,
               {0, 1} => 2,
               {1, 1} => 5,
               {2, 1} => 5,
               {3, 1} => 1,
               {4, 1} => 2,
               {0, 2} => 6,
               {1, 2} => 5,
               {2, 2} => 3,
               {3, 2} => 3,
               {4, 2} => 2,
               {0, 3} => 3,
               {1, 3} => 3,
               {2, 3} => 5,
               {3, 3} => 4,
               {4, 3} => 9,
               {0, 4} => 3,
               {1, 4} => 5,
               {2, 4} => 3,
               {3, 4} => 9,
               {4, 4} => 0
             }
    end
  end

  describe "puzzle1" do
    test "compute visibility from left" do
      grid = @test_input |> Day8.parse()

      result = %{} |> Day8.add_visibility(grid, 5, :left)

      assert result == %{
               left: %{
                 0 => %{max: 7, visible: [{3, 0}, {0, 0}]},
                 1 => %{max: 5, visible: [{1, 1}, {0, 1}]},
                 2 => %{max: 6, visible: [{0, 2}]},
                 3 => %{max: 9, visible: [{4, 3}, {2, 3}, {0, 3}]},
                 4 => %{max: 9, visible: [{3, 4}, {1, 4}, {0, 4}]}
               }
             }
    end

    test "compute visibility from right" do
      grid = @test_input |> Day8.parse()

      result = %{} |> Day8.add_visibility(grid, 5, :right)

      assert result == %{
               right: %{
                 0 => %{max: 7, visible: [{3, 0}, {4, 0}]},
                 1 => %{max: 5, visible: [{2, 1}, {4, 1}]},
                 2 => %{max: 6, visible: [{0, 2}, {1, 2}, {3, 2}, {4, 2}]},
                 3 => %{max: 9, visible: [{4, 3}]},
                 4 => %{max: 9, visible: [{3, 4}, {4, 4}]}
               }
             }
    end

    test "compute visibility from bottom" do
      grid = @test_input |> Day8.parse()

      result = %{} |> Day8.add_visibility(grid, 5, :bottom)

      assert result == %{
               bottom: %{
                 0 => %{max: 6, visible: [{0, 2}, {0, 4}]},
                 1 => %{max: 5, visible: [{1, 4}]},
                 2 => %{max: 5, visible: [{2, 3}, {2, 4}]},
                 3 => %{max: 9, visible: [{3, 4}]},
                 4 => %{max: 9, visible: [{4, 3}, {4, 4}]}
               }
             }
    end

    test "compute visibility from top" do
      grid = @test_input |> Day8.parse()

      result = %{} |> Day8.add_visibility(grid, 5, :top)

      assert result == %{
               top: %{
                 0 => %{max: 6, visible: [{0, 2}, {0, 0}]},
                 1 => %{max: 5, visible: [{1, 1}, {1, 0}]},
                 2 => %{max: 5, visible: [{2, 1}, {2, 0}]},
                 3 => %{max: 9, visible: [{3, 4}, {3, 0}]},
                 4 => %{max: 9, visible: [{4, 3}, {4, 0}]}
               }
             }
    end

    test "determine all visibilities" do
      result = @test_input |> Day8.parse() |> Day8.determine_visibility()

      assert result == %{
               top: %{
                 0 => %{max: 6, visible: [{0, 2}, {0, 0}]},
                 1 => %{max: 5, visible: [{1, 1}, {1, 0}]},
                 2 => %{max: 5, visible: [{2, 1}, {2, 0}]},
                 3 => %{max: 9, visible: [{3, 4}, {3, 0}]},
                 4 => %{max: 9, visible: [{4, 3}, {4, 0}]}
               },
               bottom: %{
                 0 => %{max: 6, visible: [{0, 2}, {0, 4}]},
                 1 => %{max: 5, visible: [{1, 4}]},
                 2 => %{max: 5, visible: [{2, 3}, {2, 4}]},
                 3 => %{max: 9, visible: [{3, 4}]},
                 4 => %{max: 9, visible: [{4, 3}, {4, 4}]}
               },
               right: %{
                 0 => %{max: 7, visible: [{3, 0}, {4, 0}]},
                 1 => %{max: 5, visible: [{2, 1}, {4, 1}]},
                 2 => %{max: 6, visible: [{0, 2}, {1, 2}, {3, 2}, {4, 2}]},
                 3 => %{max: 9, visible: [{4, 3}]},
                 4 => %{max: 9, visible: [{3, 4}, {4, 4}]}
               },
               left: %{
                 0 => %{max: 7, visible: [{3, 0}, {0, 0}]},
                 1 => %{max: 5, visible: [{1, 1}, {0, 1}]},
                 2 => %{max: 6, visible: [{0, 2}]},
                 3 => %{max: 9, visible: [{4, 3}, {2, 3}, {0, 3}]},
                 4 => %{max: 9, visible: [{3, 4}, {1, 4}, {0, 4}]}
               }
             }
    end

    test "count visible trees" do
      assert @test_input |> Day8.parse() |> Day8.count_visible() == 21
    end

    test "launch puzzle1" do
      assert @test_input |> Day8.launch(:puzzle1) == 21
    end
  end

  describe "puzzle2" do
    test "directional scenic scores for {2, 1}" do
      grid = @test_input |> Day8.parse()

      assert grid |> Day8.compute_scenic_score({2, 1}, 5, :left) == 1
      assert grid |> Day8.compute_scenic_score({2, 1}, 5, :right) == 2
      assert grid |> Day8.compute_scenic_score({2, 1}, 5, :top) == 1
      assert grid |> Day8.compute_scenic_score({2, 1}, 5, :bottom) == 2
    end

    test "directional scenic scores for {2, 3}" do
      grid = @test_input |> Day8.parse()

      assert grid |> Day8.compute_scenic_score({2, 3}, 5, :left) == 2
      assert grid |> Day8.compute_scenic_score({2, 3}, 5, :right) == 2
      assert grid |> Day8.compute_scenic_score({2, 3}, 5, :top) == 2
      assert grid |> Day8.compute_scenic_score({2, 3}, 5, :bottom) == 1
    end

    test "scenic scores for specific trees" do
      grid = @test_input |> Day8.parse()

      assert grid |> Day8.compute_scenic_score({2, 1}, 5) == 4
      assert grid |> Day8.compute_scenic_score({2, 3}, 5) == 8
    end

    test "launch puzzle2" do
      assert @test_input |> Day8.launch(:puzzle2) == 8
    end
  end
end
