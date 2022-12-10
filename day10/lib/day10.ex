defmodule Day10 do
  require Logger

  def parse(input) do
    input
    |> String.split("\n")
    |> Enum.map(fn
      "noop" ->
        {:noop}

      line ->
        [_, v] = ~r/addx (.+)/ |> Regex.run(line)
        {:addx, String.to_integer(v)}
    end)
  end

  def execute({x, cycle}, {:noop}) do
    {x, cycle + 1}
  end

  def execute({x, cycle}, {:addx, v}) do
    {x + v, cycle + 2}
  end

  def execute(l, state) when is_list(l) do
    l
    |> Enum.reduce([state], fn operation, [s | _] = acc ->
      new_state = s |> execute(operation)
      [new_state | acc]
    end)
  end

  def execute(l) when is_list(l) do
    l |> execute(initial_state())
  end

  def interesting(history, clocks) do
    acc = {clocks |> Enum.sort(:desc), MapSet.new()}

    {_, interesting_states} =
      history
      |> Enum.reduce(acc, fn
        _, {[], interesting_states} ->
          {[], interesting_states}

        state, {remaining_clocks, interesting_states} ->
          {clocks, interesting_states} =
            state
            |> maybe_add_next_interesting_state(remaining_clocks, interesting_states)

          {clocks, interesting_states}
      end)

    interesting_states
  end

  def initial_state(), do: {1, 0}

  def put_char(sprite_position, x)
      when is_number(sprite_position) and is_number(x) and
             abs(sprite_position - x) <= 1 do
    "█"
  end

  def put_char(_, _), do: "."

  @spec put_chars(nonempty_maybe_improper_list, integer, integer, pos_integer) :: list
  def put_chars([{initial_value, _} | rest], initial_drawing_clock, final_drawing_clock, chunks) do
    acc0 = {initial_value, rest, ""}

    {_, _, output} =
      initial_drawing_clock..final_drawing_clock
      |> Enum.reduce(acc0, fn
        drawing_clock, {current_sprite_value, [], output} ->
          {current_sprite_value, [], "#{output}#{put_char(current_sprite_value, drawing_clock)}"}

        drawing_clock, {current_sprite_value, states, output} ->
          {sprite_value, updated_states} =
            maybe_change_state(current_sprite_value, drawing_clock, states)

          x = rem(drawing_clock - 1, chunks)

          added_char = put_char(current_sprite_value, x)

          {sprite_value, updated_states, "#{output}#{added_char}"}
      end)

    output
    |> String.split("")
    |> Enum.filter(fn c -> c != "" end)
    |> Enum.chunk_every(chunks)
    |> Enum.map(fn c -> c |> Enum.join("") end)
  end

  def launch(input, :puzzle1) do
    input
    |> parse()
    |> execute()
    |> interesting([20, 60, 100, 140, 180, 220])
    |> Enum.reduce(0, fn {value, clock}, acc -> value * clock + acc end)
  end

  def launch(input, :puzzle2) do
    input
    |> parse()
    |> execute()
    |> Enum.reverse()
    |> put_chars(1, 240, 40)
  end

  defp maybe_add_next_interesting_state({v, value_clock}, [next_clock | rest], interesting_states)
       when value_clock < next_clock do
    {rest, interesting_states |> MapSet.put({v, next_clock})}
  end

  defp maybe_add_next_interesting_state(_s, clocks, interesting_states) do
    {clocks, interesting_states}
  end

  defp maybe_change_state(_, drawing_clock, [{next_value, next_clock} | tl])
       when next_clock <= drawing_clock do
    {next_value, tl}
  end

  defp maybe_change_state(sprite_value, _, states), do: {sprite_value, states}
end
