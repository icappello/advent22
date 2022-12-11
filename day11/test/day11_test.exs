defmodule Day11Test do
  use ExUnit.Case
  alias Enumerable.Date
  alias Day11.Monkey
  require Logger

  doctest Day11

  describe "common" do
    test "parse operation" do
      inputs = ["new = old * 11", "new = old * 19", "new = old * old", "new = old + 4"]

      results = inputs |> Enum.map(fn o -> Day11.parse_operation(o) end)

      assert results == [
               {:old, :mult, 11},
               {:old, :mult, 19},
               {:old, :mult, :old},
               {:old, :sum, 4}
             ]
    end

    test "parse input (one monkey)" do
      definition = """
      Monkey 0:
      Starting items: 63, 84, 80, 83, 84, 53, 88, 72
      Operation: new = old * 11
      Test: divisible by 13
      If true: throw to monkey 4
      If false: throw to monkey 7
      """

      parsed = Day11.parse(definition)

      assert parsed == %{
               0 => %Monkey{
                 index: 0,
                 items: [63, 84, 80, 83, 84, 53, 88, 72],
                 operation: {:old, :mult, 11},
                 divisible_by: 13,
                 test_true: 4,
                 test_false: 7,
                 handled: 0
               }
             }
    end

    test "parse full input" do
      initial_state = File.read!("./puzzle.in") |> Day11.parse()

      assert initial_state == %{
               0 => %Monkey{
                 index: 0,
                 items: [63, 84, 80, 83, 84, 53, 88, 72],
                 operation: {:old, :mult, 11},
                 divisible_by: 13,
                 test_true: 4,
                 test_false: 7,
                 handled: 0
               },
               1 => %Monkey{
                 index: 1,
                 items: [67, 56, 92, 88, 84],
                 operation: {:old, :sum, 4},
                 divisible_by: 11,
                 test_true: 5,
                 test_false: 3,
                 handled: 0
               },
               2 => %Monkey{
                 index: 2,
                 items: [52],
                 operation: {:old, :mult, :old},
                 divisible_by: 2,
                 test_true: 3,
                 test_false: 1,
                 handled: 0
               },
               3 => %Monkey{
                 index: 3,
                 items: [59, 53, 60, 92, 69, 72],
                 operation: {:old, :sum, 2},
                 divisible_by: 5,
                 test_true: 5,
                 test_false: 6,
                 handled: 0
               },
               4 => %Monkey{
                 index: 4,
                 items: [61, 52, 55, 61],
                 operation: {:old, :sum, 3},
                 divisible_by: 7,
                 test_true: 7,
                 test_false: 2
               },
               5 => %Monkey{
                 index: 5,
                 items: [79, 53],
                 operation: {:old, :sum, 1},
                 divisible_by: 3,
                 test_true: 0,
                 test_false: 6,
                 handled: 0
               },
               6 => %Monkey{
                 index: 6,
                 items: [59, 86, 67, 95, 92, 77, 91],
                 operation: {:old, :sum, 5},
                 divisible_by: 19,
                 test_true: 4,
                 test_false: 0,
                 handled: 0
               },
               7 => %Monkey{
                 index: 7,
                 items: [58, 83, 89],
                 operation: {:old, :mult, 19},
                 divisible_by: 17,
                 test_true: 2,
                 test_false: 1,
                 handled: 0
               }
             }
    end

    test "execute operations" do
      initial_state = 10
      operations = [{:old, :sum, -5}, {:old, :mult, 2}, {:old, :mult, :old}, {:old, :sum, -99}]

      result =
        operations
        |> Enum.reduce(initial_state, fn operation, acc -> acc |> Day11.compute(operation) end)

      assert result == 1
    end

    test "divisibility tests" do
      inputs = [
        [10, 2, 1, 2],
        [5, 3, 1, 2],
        [7, 1, 1, 2],
        [9, 9, 1, 2]
      ]

      results = inputs |> Enum.map(fn i -> apply(Day11, :test, i) end)

      assert results == [1, 2, 1, 1]
    end

    test "update recipient" do
      monkeys = %{
        2 => %Monkey{
          index: 0,
          items: [79, 98],
          operation: {:old, :mult, 19},
          divisible_by: 23,
          test_true: 2,
          test_false: 3,
          handled: 0
        }
      }

      result = monkeys |> Day11.update_recipient(50, 2)

      assert %{2 => %Monkey{items: [79, 98, 50]}} = result
    end
  end

  describe "test1" do
    test "monkey turn, empty list, skips" do
      input = %Monkey{
        index: 0,
        items: [],
        operation: {:old, :mult, 19},
        divisible_by: 23,
        test_true: 2,
        test_false: 3,
        handled: 0
      }

      common_divisor = 23

      assert {:skip, new_state} = Day11.handle_item(input, common_divisor, :puzzle1)

      assert new_state == input
    end

    test "monkey turn, handle one item, get recipient" do
      input = %Monkey{
        index: 0,
        items: [79, 98],
        operation: {:old, :mult, 19},
        divisible_by: 23,
        test_true: 2,
        test_false: 3,
        handled: 0
      }

      common_divisor = 23

      {new_value, recipient, new_state} = Day11.handle_item(input, common_divisor, :puzzle1)

      assert new_value == 500
      assert recipient == 3
      assert %Monkey{handled: 1, items: [98]} = new_state
    end

    test "compute one state transition" do
      initial_state = File.read!("./puzzle1_test.in") |> Day11.parse()
      current_monkey = 0
      common_divisor = 23 * 19 * 17 * 11

      {updated_state, next_monkey} =
        initial_state |> Day11.step(current_monkey, common_divisor, :puzzle1)

      monkey0 = updated_state |> Map.get(0)
      monkey3 = updated_state |> Map.get(3)

      assert next_monkey == current_monkey

      assert monkey0 == %Monkey{
               items: [98],
               handled: 1,
               divisible_by: 23,
               index: 0,
               operation: {:old, :mult, 19},
               test_false: 3,
               test_true: 2
             }

      assert monkey3 == %Monkey{
               divisible_by: 17,
               handled: 0,
               index: 3,
               items: [74, 500],
               operation: {:old, :sum, 3},
               test_false: 1,
               test_true: 0
             }
    end

    test "compute one round" do
      initial_state = File.read!("./puzzle1_test.in") |> Day11.parse()
      common_divisor = initial_state |> Day11.compute_common_divisor()

      updated_state = Day11.one_round(initial_state, common_divisor, :puzzle1)

      assert updated_state == %{
               0 => %Day11.Monkey{
                 index: 0,
                 items: [20, 23, 27, 26],
                 operation: {:old, :mult, 19},
                 divisible_by: 23,
                 test_true: 2,
                 test_false: 3,
                 handled: 2
               },
               1 => %Day11.Monkey{
                 index: 1,
                 items: [2080, 25, 167, 207, 401, 1046],
                 operation: {:old, :sum, 6},
                 divisible_by: 19,
                 test_true: 2,
                 test_false: 0,
                 handled: 4
               },
               2 => %Day11.Monkey{
                 index: 2,
                 items: [],
                 operation: {:old, :mult, :old},
                 divisible_by: 13,
                 test_true: 1,
                 test_false: 3,
                 handled: 3
               },
               3 => %Day11.Monkey{
                 index: 3,
                 items: [],
                 operation: {:old, :sum, 3},
                 divisible_by: 17,
                 test_true: 0,
                 test_false: 1,
                 handled: 5
               }
             }
    end

    test "compute 20 rounds" do
      initial_state = File.read!("./puzzle1_test.in") |> Day11.parse()

      [last_state | _rest] = initial_state |> Day11.rounds(20, :puzzle1)

      assert last_state == %{
               0 => %Day11.Monkey{
                 index: 0,
                 items: [10, 12, 14, 26, 34],
                 operation: {:old, :mult, 19},
                 divisible_by: 23,
                 test_true: 2,
                 test_false: 3,
                 handled: 101
               },
               1 => %Day11.Monkey{
                 index: 1,
                 items: [245, 93, 53, 199, 115],
                 operation: {:old, :sum, 6},
                 divisible_by: 19,
                 test_true: 2,
                 test_false: 0,
                 handled: 95
               },
               2 => %Day11.Monkey{
                 index: 2,
                 items: [],
                 operation: {:old, :mult, :old},
                 divisible_by: 13,
                 test_true: 1,
                 test_false: 3,
                 handled: 7
               },
               3 => %Day11.Monkey{
                 index: 3,
                 items: [],
                 operation: {:old, :sum, 3},
                 divisible_by: 17,
                 test_true: 0,
                 test_false: 1,
                 handled: 105
               }
             }
    end

    test "compute monkey business" do
      initial_state = File.read!("./puzzle1_test.in") |> Day11.parse()
      [last_state | _rest] = initial_state |> Day11.rounds(20, :puzzle1)

      monkey_business = Day11.compute_monkey_business(last_state)

      assert monkey_business == 10605
    end

    test "launch puzzle1" do
      assert File.read!("./puzzle1_test.in") |> Day11.launch(:puzzle1) == 10605
    end
  end

  describe "test2" do
    test "compute monkey business" do
      initial_state = File.read!("./puzzle1_test.in") |> Day11.parse()
      [last_state | _rest] = initial_state |> Day11.rounds(10000, :puzzle2)

      monkey_business = Day11.compute_monkey_business(last_state)

      assert monkey_business == 2_713_310_158
    end

    test "launch puzzle2" do
      assert File.read!("./puzzle1_test.in") |> Day11.launch(:puzzle2) == 2_713_310_158
    end
  end
end
