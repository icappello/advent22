defmodule Day10Test do
  use ExUnit.Case
  alias Test.Support.Util
  doctest Day10

  describe "common" do
    test "parse input" do
      assert Util.short_input() |> Day10.parse() == [{:noop}, {:addx, 3}, {:addx, -5}]
    end

    test "execute :noop" do
      state = Day10.initial_state()

      new_state = state |> Day10.execute({:noop})

      assert new_state == {1, 1}
    end

    test "execute :addx (positive)" do
      state = Day10.initial_state()

      new_state = state |> Day10.execute({:addx, 3})

      assert new_state == {4, 2}
    end

    test "execute :addx (negative)" do
      state = Day10.initial_state()

      new_state = state |> Day10.execute({:addx, -5})

      assert new_state == {-4, 2}
    end

    test "execute sequence of actions (short input)" do
      history = Util.short_input() |> Day10.parse() |> Day10.execute()

      assert history == [{-1, 5}, {4, 3}, {1, 1}, {1, 0}]
    end

    test "execute sequence of actions (long input)" do
      history = Util.long_input() |> Day10.parse() |> Day10.execute()

      [{17, 240} | _] = history
    end
  end

  describe "puzzle1" do
    test "values at interesting cycles" do
      interesting =
        Util.long_input()
        |> Day10.parse()
        |> Day10.execute()
        |> Day10.interesting([20, 60, 100, 140, 180, 220])

      assert interesting ==
               MapSet.new([{21, 20}, {19, 60}, {18, 100}, {21, 140}, {16, 180}, {18, 220}])
    end

    test "compute result" do
      assert Util.long_input() |> Day10.launch(:puzzle1) == 13140
    end
  end

  describe "puzzle2" do
    test "compute output for single states" do
      drawing_clock = 11
      assert Day10.put_char(8, drawing_clock) == "."
      assert Day10.put_char(10, drawing_clock) == "█"
      assert Day10.put_char(11, drawing_clock) == "█"
      assert Day10.put_char(12, drawing_clock) == "█"
      assert Day10.put_char(13, drawing_clock) == "."
    end

    test "compute result" do
      assert Util.long_input() |> Day10.launch(:puzzle2) == Util.puzzle2_long_input_result()
    end
  end
end
