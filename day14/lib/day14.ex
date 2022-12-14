defmodule Day14 do
  @source {500, 0}

  def parse_segment({sx, sy}, {ex, ey}) when sx == ex do
    for y <- sy..ey do
      {{sx, y}, :wall}
    end
    |> Enum.into(%{})
  end

  def parse_segment({sx, sy}, {ex, ey}) when sy == ey do
    for x <- sx..ex do
      {{x, sy}, :wall}
    end
    |> Enum.into(%{})
  end

  def parse_line(line) do
    [h | tl] =
      line
      |> String.split(" -> ", trim: true)
      |> Enum.map(fn n ->
        [s, e] = n |> String.split(",", trim: true)
        {String.to_integer(s), String.to_integer(e)}
      end)

    tl
    |> Enum.reduce({%{h => :wall}, h}, fn next_node, {acc, prev_node} ->
      acc = acc |> Map.merge(parse_segment(prev_node, next_node))
      {acc, next_node}
    end)
  end

  def parse(input) do
    grid =
      input
      |> String.split("\n", trim: true)
      |> Enum.reduce(%{}, fn line, acc ->
        {segment_result, _} = parse_line(line)
        acc |> Map.merge(segment_result)
      end)

    {grid, find_max_y(grid)}
  end

  def get_next_resting_point(grid, max_y, puzzle) do
    grid |> move_grain(max_y, @source, puzzle)
  end

  def move_grain(grid, max_y, {current_x, current_y}, :puzzle1) do
    cond do
      current_y > max_y ->
        {grid, {current_x, :inf}}

      grid |> Map.get({current_x, current_y + 1}, :air) == :air ->
        move_grain(grid, max_y, {current_x, current_y + 1}, :puzzle1)

      grid |> Map.get({current_x - 1, current_y + 1}, :air) == :air ->
        move_grain(grid, max_y, {current_x - 1, current_y + 1}, :puzzle1)

      grid |> Map.get({current_x + 1, current_y + 1}, :air) == :air ->
        move_grain(grid, max_y, {current_x + 1, current_y + 1}, :puzzle1)

      true ->
        {grid |> Map.put({current_x, current_y}, :sand), {current_x, current_y}}
    end
  end

  def move_grain(grid, max_y, {current_x, current_y}, :puzzle2) do
    cond do
      current_y == max_y + 2 ->
        {grid |> Map.put({current_x, current_y - 1}, :sand), {current_x, current_y - 1}}

      grid |> Map.get({current_x, current_y + 1}, :air) == :air ->
        move_grain(grid, max_y, {current_x, current_y + 1}, :puzzle2)

      grid |> Map.get({current_x - 1, current_y + 1}, :air) == :air ->
        move_grain(grid, max_y, {current_x - 1, current_y + 1}, :puzzle2)

      grid |> Map.get({current_x + 1, current_y + 1}, :air) == :air ->
        move_grain(grid, max_y, {current_x + 1, current_y + 1}, :puzzle2)

      true ->
        {grid |> Map.put({current_x, current_y}, :sand), {current_x, current_y}}
    end
  end

  def launch(input, :puzzle1) do
    {grid, max_y} = input |> parse()

    puzzle_rec(grid, max_y, nil, 0, :puzzle1) - 1
  end

  def launch(input, :puzzle2) do
    {grid, max_y} = input |> parse()

    puzzle_rec(grid, max_y, nil, 0, :puzzle2)
  end

  defp puzzle_rec(_, _, {_, :inf}, counter, :puzzle1) do
    counter
  end

  defp puzzle_rec(grid, max_y, _, counter, :puzzle1) do
    {updated, rest_position} = grid |> get_next_resting_point(max_y, :puzzle1)
    updated |> puzzle_rec(max_y, rest_position, counter + 1, :puzzle1)
  end

  defp puzzle_rec(_, _, @source, counter, :puzzle2) do
    counter
  end

  defp puzzle_rec(grid, max_y, _, counter, :puzzle2) do
    {updated, rest_position} = grid |> get_next_resting_point(max_y, :puzzle2)
    updated |> puzzle_rec(max_y, rest_position, counter + 1, :puzzle2)
  end

  defp find_max_y(grid) do
    [{_, max_y} | _] = grid |> Map.keys() |> Enum.sort(fn {_, y1}, {_, y2} -> y1 > y2 end)

    max_y
  end
end
