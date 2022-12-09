defmodule Day9.Puzzle2 do
  require Logger

  @spec parse(binary) :: list(:up | :down | :left | :right)
  def parse(input) do
    input
    |> String.split("\n")
    |> Enum.filter(fn line -> line != "" end)
    |> Enum.map(fn line ->
      [direction, m] = line |> String.split(" ")
      mult = String.to_integer(m)

      case direction do
        "R" -> :right |> List.duplicate(mult)
        "L" -> :left |> List.duplicate(mult)
        "U" -> :up |> List.duplicate(mult)
        "D" -> :down |> List.duplicate(mult)
      end
    end)
    |> List.flatten()
  end

  def compute_move({{_old_hdx, _old_hdy}, {hdx, hdy}, {old_tlx, old_tly}}) do
    deltax = hdx - old_tlx
    deltay = hdy - old_tly

    cond do
      touching({hdx, hdy}, {old_tlx, old_tly}) ->
        {old_tlx, old_tly}

      deltax == 0 ->
        {old_tlx, old_tly + ((deltay / abs(deltay)) |> trunc())}

      deltay == 0 ->
        {old_tlx + ((deltax / abs(deltax)) |> trunc()), old_tly}

      true ->
        {old_tlx + ((deltax / abs(deltax)) |> trunc()),
         old_tly + ((deltay / abs(deltay)) |> trunc())}
    end
  end

  def move(l, direction) when is_list(l) do
    [h, h1 | rest] = l
    {new_head, new_h1} = move({h, h1}, direction)
    acc0 = {[new_h1, new_head], {h1, new_h1}}

    {new_positions, _} =
      rest
      |> Enum.reduce(acc0, fn old_tl, {acc, {old_hd, hd}} ->
        new_tl = compute_move({old_hd, hd, old_tl})

        {[new_tl | acc], {old_tl, new_tl}}
      end)

    new_positions |> Enum.reverse()
  end

  def move({{hx, hy}, {tx, _ty}}, :right) when hx == tx + 1, do: {{hx + 1, hy}, {hx, hy}}
  def move({{hx, hy}, {_tx, ty}}, :down) when hy == ty - 1, do: {{hx, hy - 1}, {hx, hy}}
  def move({{hx, hy}, {tx, _ty}}, :left) when hx == tx - 1, do: {{hx - 1, hy}, {hx, hy}}
  def move({{hx, hy}, {_tx, ty}}, :up) when hy == ty + 1, do: {{hx, hy + 1}, {hx, hy}}

  def move({{hx, hy}, {tx, ty}}, :right), do: {{hx + 1, hy}, {tx, ty}}
  def move({{hx, hy}, {tx, ty}}, :left), do: {{hx - 1, hy}, {tx, ty}}
  def move({{hx, hy}, {tx, ty}}, :up), do: {{hx, hy + 1}, {tx, ty}}
  def move({{hx, hy}, {tx, ty}}, :down), do: {{hx, hy - 1}, {tx, ty}}

  def path(position, move, acc), do: [move(position, move) | acc]

  def compute_path(moves, size) do
    initial_position = {0, 0} |> List.duplicate(size)

    moves
    |> Enum.reduce([initial_position], fn move, [hd | _] = acc ->
      hd |> path(move, acc)
    end)
    |> Enum.reverse()
  end

  def count_unique_tail_positions(positions, size) do
    positions
    |> Enum.reduce(MapSet.new([]), fn l, acc ->
      acc |> MapSet.put(l |> Enum.at(size - 1))
    end)
    |> MapSet.size()
  end

  def launch(input, size) do
    input
    |> parse()
    |> compute_path(size)
    |> count_unique_tail_positions(size)
  end

  defp touching({x1, y1}, {x2, y2}) do
    abs(x1 - x2) <= 1 and abs(y1 - y2) <= 1
  end
end
