defmodule Day15Test do
  use ExUnit.Case
  doctest Day15

  @test_input_1 [
                  "Sensor at x=2, y=18: closest beacon is at x=-2, y=15",
                  "Sensor at x=9, y=16: closest beacon is at x=10, y=16",
                  "Sensor at x=13, y=2: closest beacon is at x=15, y=3",
                  "Sensor at x=12, y=14: closest beacon is at x=10, y=16",
                  "Sensor at x=10, y=20: closest beacon is at x=10, y=16",
                  "Sensor at x=14, y=17: closest beacon is at x=10, y=16",
                  "Sensor at x=8, y=7: closest beacon is at x=2, y=10",
                  "Sensor at x=2, y=0: closest beacon is at x=2, y=10",
                  "Sensor at x=0, y=11: closest beacon is at x=2, y=10",
                  "Sensor at x=20, y=14: closest beacon is at x=25, y=17",
                  "Sensor at x=17, y=20: closest beacon is at x=21, y=22",
                  "Sensor at x=16, y=7: closest beacon is at x=15, y=3",
                  "Sensor at x=14, y=3: closest beacon is at x=15, y=3",
                  "Sensor at x=20, y=1: closest beacon is at x=15, y=3"
                ]
                |> Enum.join("\n")

  describe "common" do
    test "parse line" do
      {sensor, beacon, distance} =
        "Sensor at x=2, y=18: closest beacon is at x=-2, y=15" |> Day15.parse_line()

      assert sensor == {2, 18}
      assert beacon == {-2, 15}
      assert distance == 7
    end

    test "parse example" do
      {sensors, beacons} = Day15.parse(@test_input_1)

      assert sensors == %{
               {0, 11} => {{2, 10}, 3},
               {2, 0} => {{2, 10}, 10},
               {2, 18} => {{-2, 15}, 7},
               {8, 7} => {{2, 10}, 9},
               {9, 16} => {{10, 16}, 1},
               {10, 20} => {{10, 16}, 4},
               {12, 14} => {{10, 16}, 4},
               {13, 2} => {{15, 3}, 3},
               {14, 3} => {{15, 3}, 1},
               {14, 17} => {{10, 16}, 5},
               {16, 7} => {{15, 3}, 5},
               {17, 20} => {{21, 22}, 6},
               {20, 1} => {{15, 3}, 7},
               {20, 14} => {{25, 17}, 8}
             }

      assert beacons == %{
               {-2, 15} => [{{2, 18}, 7}],
               {2, 10} => [{{0, 11}, 3}, {{8, 7}, 9}, {{2, 0}, 10}],
               {10, 16} => [{{9, 16}, 1}, {{10, 20}, 4}, {{12, 14}, 4}, {{14, 17}, 5}],
               {15, 3} => [{{14, 3}, 1}, {{13, 2}, 3}, {{16, 7}, 5}, {{20, 1}, 7}],
               {21, 22} => [{{17, 20}, 6}],
               {25, 17} => [{{20, 14}, 8}]
             }
    end
  end

  describe "puzzle1" do
    test "find relevant sensors" do
      {sensors, _} = Day15.parse(@test_input_1)

      filtered = sensors |> Day15.find_relevant_sensors(10, :puzzle1)

      assert filtered == %{
               {0, 11} => {2, 3, 1},
               {2, 0} => {0, 10, 10},
               {8, 7} => {6, 9, 3},
               {12, 14} => {0, 4, 4},
               {16, 7} => {2, 5, 3},
               {20, 14} => {4, 8, 4}
             }
    end

    test "cover row 10" do
      {sensors, beacons} = Day15.parse(@test_input_1)

      covered = sensors |> Day15.cover(beacons, 10, :puzzle1)

      assert covered ==
               MapSet.new([
                 {-2, 10},
                 {-1, 10},
                 {0, 10},
                 {1, 10},
                 {3, 10},
                 {4, 10},
                 {5, 10},
                 {6, 10},
                 {7, 10},
                 {8, 10},
                 {9, 10},
                 {10, 10},
                 {11, 10},
                 {12, 10},
                 {13, 10},
                 {14, 10},
                 {15, 10},
                 {16, 10},
                 {17, 10},
                 {18, 10},
                 {19, 10},
                 {20, 10},
                 {21, 10},
                 {22, 10},
                 {23, 10},
                 {24, 10}
               ])
    end

    test "cover row 11" do
      {sensors, beacons} = Day15.parse(@test_input_1)

      covered = sensors |> Day15.cover(beacons, 11, :puzzle1)

      assert covered ==
               MapSet.new([
                 {-3, 11},
                 {-2, 11},
                 {-1, 11},
                 {0, 11},
                 {1, 11},
                 {2, 11},
                 {3, 11},
                 {4, 11},
                 {5, 11},
                 {6, 11},
                 {7, 11},
                 {8, 11},
                 {9, 11},
                 {10, 11},
                 {11, 11},
                 {12, 11},
                 {13, 11},
                 {15, 11},
                 {16, 11},
                 {17, 11},
                 {18, 11},
                 {19, 11},
                 {20, 11},
                 {21, 11},
                 {22, 11},
                 {23, 11},
                 {24, 11},
                 {25, 11}
               ])
    end

    test "launch puzzle 1" do
      assert @test_input_1 |> Day15.launch(10, :puzzle1) == 26
    end
  end

  describe "puzzle 2" do
    test "cover row 11" do
      {sensors, beacons} = Day15.parse(@test_input_1)

      covered = sensors |> Day15.cover(beacons, 11, 20, :puzzle2)

      assert covered ==
               MapSet.new([
                 {{0, 11}, {3, 11}},
                 {{2, 11}, {2, 11}},
                 {{3, 11}, {13, 11}},
                 {{11, 11}, {13, 11}},
                 {{15, 11}, {17, 11}},
                 {{15, 11}, {20, 11}}
               ])
    end

    test "find free position" do
      {sensors, beacons} = @test_input_1 |> Day15.parse()

      position = {sensors, beacons} |> Day15.find_free_position(20, 20)

      assert position == {14, 11}
    end

    test "find frequency" do
      {sensors, beacons} = @test_input_1 |> Day15.parse()

      frequency = {sensors, beacons} |> Day15.find_frequency(20, 20)

      assert frequency == 56_000_011
    end

    test "launch puzzle2" do
      assert @test_input_1 |> Day15.launch(20, 20, :puzzle2) == 56_000_011
    end
  end
end
