defmodule Day12 do
  require Logger

  def parse(input) do
    acc0 = {nil, nil, %{}}

    input
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.reduce(acc0, fn {line, col}, {sp, ep, grid} ->
      line
      |> String.split("", trim: true)
      |> Enum.with_index()
      |> Enum.reduce({sp, ep, grid}, fn {ch, row}, {sp, ep, grid} ->
        case ch do
          "S" -> {{row, col}, ep, grid |> Map.put({row, col}, get_height("a"))}
          "E" -> {sp, {row, col}, grid |> Map.put({row, col}, get_height("z"))}
          ch -> {sp, ep, grid |> Map.put({row, col}, get_height(ch))}
        end
      end)
    end)
  end

  def get_moves({x, y}, grid, puzzle) do
    res =
      [{-1, 0}, {1, 0}, {0, -1}, {0, 1}]
      |> Enum.reduce([], fn {dx, dy}, acc ->
        current_value = grid |> Map.get({x, y})
        other_x = x + dx
        other_y = y + dy
        other_value = grid |> Map.get({other_x, other_y})

        cond do
          other_value == nil -> acc
          puzzle == :puzzle1 and other_value - current_value > 1 -> acc
          puzzle == :puzzle2 and current_value - other_value > 1 -> acc
          true -> [{other_x, other_y} | acc]
        end
      end)

    res
  end

  def bfs_step({current_queue, current_visited}, grid, puzzle) do
    {q, [{current_position, depth}]} = current_queue |> Enum.split(-1)

    updated_queue =
      current_position
      |> get_moves(grid, puzzle)
      |> Enum.reduce(q, fn pos, queue ->
        maybe_add_position(
          pos,
          {current_position, depth},
          queue,
          queue |> Enum.find(fn {p, _} -> p == pos end),
          current_visited |> Enum.find(fn {p, _} -> p == pos end),
          current_visited |> Enum.find(fn {p, _} -> grid |> Map.get(p) == 0 end),
          puzzle
        )
      end)

    updated_visited = current_visited |> MapSet.put({current_position, depth})

    {updated_queue, updated_visited}
  end

  def bfs({starting_position, destinations}, grid, puzzle) do
    destinations
    |> bfs_rec(
      [{starting_position, 0}],
      MapSet.new(),
      grid,
      puzzle
    )
  end

  defp bfs_rec(destinations, queue, visited, grid, puzzle) do
    cond do
      visited |> Enum.find(fn p -> destinations |> Enum.find(fn d -> p == d end) !== nil end) ->
        {queue, visited}

      queue == [] ->
        {queue, visited}

      true ->
        {step_queue, step_visited} = {queue, visited} |> bfs_step(grid, puzzle)
        bfs_rec(destinations, step_queue, step_visited, grid, puzzle)
    end
  end

  def launch(input, :puzzle1) do
    {start_position, destination, grid} = parse(input)
    {_, visited} = {start_position, [destination]} |> bfs(grid, :puzzle1)
    {_, depth} = visited |> Enum.find(fn {pos, _} -> pos == destination end)

    depth
  end

  def launch(input, :puzzle2) do
    {_, start_position, grid} = parse(input)

    destinations = grid |> get_possible_destinations()

    {_, visited} = {start_position, destinations} |> bfs(grid, :puzzle2)

    {_, depth} =
      visited
      |> Enum.filter(fn {pos, _} -> destinations |> Enum.find(fn d -> pos == d end) != nil end)
      |> Enum.sort_by(fn {_, d} -> d end)
      |> Enum.at(0)

    depth
  end

  defp get_height(ch) do
    <<base::utf8>> = "a"
    <<ch_value::utf8>> = ch

    ch_value - base
  end

  defp maybe_add_position(
         position,
         {current_position, depth},
         queue,
         nil,
         nil,
         nil,
         :puzzle2
       )
       when position != current_position do
    [{position, depth + 1} | queue]
  end

  defp maybe_add_position(position, {current_position, depth}, queue, nil, nil, _, :puzzle1)
       when position != current_position do
    [{position, depth + 1} | queue]
  end

  defp maybe_add_position(_, _, queue, _, _, _, _), do: queue

  defp get_possible_destinations(grid) do
    grid
    |> Enum.reduce([], fn
      {pos, 0}, acc -> [pos | acc]
      _, acc -> acc
    end)
  end
end
