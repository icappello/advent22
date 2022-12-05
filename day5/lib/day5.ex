defmodule Day5 do
  require Logger

  def parse_slice(slice) do
    slice
    |> String.split("")
    |> Enum.chunk_every(4)
    |> Enum.reduce([], fn
      [_, _, " ", _], acc ->
        [nil | acc]

      [_, _, crate, _], acc ->
        [crate | acc]

      _, acc ->
        acc
    end)
    |> Enum.reverse()
  end

  def parse_stacks(input) do
    {_, slices} = input |> List.pop_at(-1)

    slices
    |> Enum.reduce(%{}, fn slice, acc ->
      slice
      |> parse_slice()
      |> Enum.with_index()
      |> Enum.reduce(acc, fn
        {nil, _}, acc2 ->
          acc2

        {el, idx}, acc2 ->
          label = idx + 1
          current_stack = acc2 |> Map.get(label, [])

          acc2 |> Map.put(label, [el | current_stack])
      end)
    end)
  end

  def parse_move(move_line) do
    [_, how_many, from, to] = ~r/move (\d+) from (\d+) to (\d+)/ |> Regex.run(move_line)

    %{
      how_many: String.to_integer(how_many),
      from: String.to_integer(from),
      to: String.to_integer(to)
    }
  end

  def parse_moves(input) do
    input |> Enum.map(fn m -> parse_move(m) end)
  end

  def move(stacks, how_many, from, to, puzzle) do
    source = stacks |> Map.get(from)
    dest = stacks |> Map.get(to)

    {source, moving_part} = source |> Enum.split(length(source) - how_many)

    dest =
      case puzzle do
        :puzzle1 -> dest ++ (moving_part |> Enum.reverse())
        :puzzle2 -> dest ++ moving_part
      end

    stacks |> Map.merge(%{from => source, to => dest})
  end

  def parse(input, puzzle) do
    {s, m, _} =
      input
      |> String.split("\n")
      |> Enum.reduce({[], [], :stacks}, fn
        "", {stacks, moves, :stacks} ->
          {stacks, moves, :moves}

        line, {stacks, moves, :stacks} ->
          {[line | stacks], moves, :stacks}

        line, {stacks, moves, :moves} ->
          {stacks, [line | moves], :moves}

        _, acc ->
          acc
      end)

    stacks = s |> Enum.reverse() |> parse_stacks()
    moves = m |> Enum.reverse() |> parse_moves()

    final_stack =
      moves
      |> Enum.reduce(stacks, fn %{how_many: how_many, from: from, to: to}, acc ->
        acc |> move(how_many, from, to, puzzle)
      end)

    1..(final_stack |> Map.keys() |> length())
    |> Enum.map(fn idx ->
      case final_stack |> Map.get(idx) |> List.last() do
        nil -> "-"
        el -> el
      end
    end)
    |> Enum.join("")
  end

  @spec launch(binary(), :puzzle1 | :puzzle2) :: non_neg_integer
  def launch(path, puzzle) do
    File.read!(path) |> parse(puzzle)
  end
end
