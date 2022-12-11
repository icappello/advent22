defmodule Day11 do
  alias Day11.Monkey

  @monkey_input_definition_regex ~r/Monkey (\d+):\n\s*Starting items: ([^\n]+)\n\s*Operation: ([^\n]+)\n\s*Test: divisible by (\d+)\n\s*If true: throw to monkey (\d)\n\s*If false: throw to monkey (\d)/s
  @operation_regex ~r/new = (.*) ([\+\*]) (.*)/

  def parse_operation(op) do
    [_, op1, operator, op2] = @operation_regex |> Regex.run(op)

    mapper = fn el ->
      case el do
        "old" -> :old
        "+" -> :sum
        "*" -> :mult
        v -> String.to_integer(v)
      end
    end

    {mapper.(op1), mapper.(operator), mapper.(op2)}
  end

  def parse(input) do
    @monkey_input_definition_regex
    |> Regex.scan(input)
    |> Enum.map(fn [_, idx, items, operation, divisibility, true_operation, false_operation] ->
      idx = String.to_integer(idx)
      divisor = String.to_integer(divisibility)

      {idx,
       %Monkey{
         index: idx,
         operation: parse_operation(operation),
         items:
           items
           |> String.split([",", " "], trim: true)
           |> Enum.map(fn v -> String.to_integer(v) end),
         divisible_by: divisor,
         test_false: String.to_integer(false_operation),
         test_true: String.to_integer(true_operation)
       }}
    end)
    |> Enum.into(%{})
  end

  def compute(value, {op1, operator, op2}) do
    replacer = fn
      :old, value -> value
      operand, _ -> operand
    end

    compute_operation(replacer.(op1, value), operator, replacer.(op2, value))
  end

  def relax(value, _divisor, :puzzle1), do: div(value, 3)
  def relax(value, divisor, :puzzle2), do: rem(value, divisor)

  def test(value, divisor, true_recipient, false_recipient),
    do: (rem(value, divisor) == 0) |> get_recipient(true_recipient, false_recipient)

  def handle_item(%Monkey{items: []} = monkey, _, _), do: {:skip, monkey}

  def handle_item(
        %Monkey{
          items: [hd | tl],
          divisible_by: divisible_by,
          test_false: false_recipient,
          test_true: true_recipient,
          operation: op,
          handled: handled
        } = monkey,
        common_divisor,
        puzzle
      ) do
    new_value = hd |> compute(op) |> relax(common_divisor, puzzle)
    recipient = new_value |> test(divisible_by, true_recipient, false_recipient)

    {new_value, recipient, monkey |> Map.merge(%{handled: handled + 1, items: tl})}
  end

  def update_recipient(monkeys, new_value, recipient) do
    queue = monkeys |> get_in([recipient, Access.key(:items)])
    monkeys |> put_in([recipient, Access.key(:items)], queue ++ [new_value])
  end

  def step(state, current_monkey_index, common_divisor, puzzle) do
    state_size = state |> map_size()

    case state |> Map.get(current_monkey_index) |> handle_item(common_divisor, puzzle) do
      {:skip, _} ->
        {state, rem(current_monkey_index + 1, state_size)}

      {new_value, recipient, updated_monkey} ->
        new_state =
          state
          |> Map.put(current_monkey_index, updated_monkey)
          |> update_recipient(new_value, recipient)

        {new_state, current_monkey_index}
    end
  end

  def one_round(initial_state, common_divisor, puzzle) do
    state_size = map_size(initial_state)

    0..(state_size - 1)
    |> Enum.reduce(initial_state, fn current_monkey_index, state ->
      round_rec(state, current_monkey_index, common_divisor, puzzle)
    end)
  end

  def rounds(initial_state, round_number, puzzle) do
    common_divisor = compute_common_divisor(initial_state)

    1..round_number
    |> Enum.reduce([initial_state], fn _idx, [hd | _] = acc ->
      new_state_after_round = one_round(hd, common_divisor, puzzle)

      [new_state_after_round | acc]
    end)
  end

  def compute_monkey_business(state) do
    [{_, monkey1}, {_, monkey2} | _] =
      state
      |> Enum.to_list()
      |> Enum.sort(fn {_, m1}, {_, m2} -> m1 |> Map.get(:handled) > m2 |> Map.get(:handled) end)

    (monkey1 |> Map.get(:handled)) * (monkey2 |> Map.get(:handled))
  end

  def launch(input, :puzzle1) do
    [last_state | _] = input |> parse() |> rounds(20, :puzzle1)

    compute_monkey_business(last_state)
  end

  def launch(input, :puzzle2) do
    [last_state | _] = input |> parse() |> rounds(10000, :puzzle2)

    compute_monkey_business(last_state)
  end

  def compute_common_divisor(state) do
    state |> Map.values() |> Enum.reduce(1, fn monkey, acc -> acc * monkey.divisible_by end)
  end

  defp round_rec(state, current_monkey_index, common_divisor, puzzle) do
    {new_state, new_monkey_index} = state |> step(current_monkey_index, common_divisor, puzzle)

    new_state
    |> maybe_continue_round(
      new_monkey_index,
      common_divisor,
      current_monkey_index == new_monkey_index,
      puzzle
    )
  end

  defp maybe_continue_round(state, monkey_index, common_divisor, true, puzzle),
    do: state |> round_rec(monkey_index, common_divisor, puzzle)

  defp maybe_continue_round(state, _monkey_index, _common_divisor, false, _puzzle), do: state

  defp get_recipient(true, true_recipient, _), do: true_recipient
  defp get_recipient(false, _, false_recipient), do: false_recipient

  defp compute_operation(op1, :sum, op2), do: op1 + op2
  defp compute_operation(op1, :mult, op2), do: op1 * op2
end
