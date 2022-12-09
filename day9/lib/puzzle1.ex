defmodule Day9.Puzzle1 do
  @spec parse(binary) :: list(:up | :down | :left | :right)
  def parse(input) do
    input
    |> String.split("\n")
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

  @spec move({{integer(), integer()}, {integer(), integer()}}, :down | :left | :right | :up) ::
          {{integer(), integer()}, {integer(), integer()}}
  def move({{hx, hy}, {tx, _ty}}, :right) when hx == tx + 1, do: {{hx + 1, hy}, {hx, hy}}
  def move({{hx, hy}, {_tx, ty}}, :down) when hy == ty - 1, do: {{hx, hy - 1}, {hx, hy}}
  def move({{hx, hy}, {tx, _ty}}, :left) when hx == tx - 1, do: {{hx - 1, hy}, {hx, hy}}
  def move({{hx, hy}, {_tx, ty}}, :up) when hy == ty + 1, do: {{hx, hy + 1}, {hx, hy}}

  def move({{hx, hy}, {tx, ty}}, :right), do: {{hx + 1, hy}, {tx, ty}}
  def move({{hx, hy}, {tx, ty}}, :left), do: {{hx - 1, hy}, {tx, ty}}
  def move({{hx, hy}, {tx, ty}}, :up), do: {{hx, hy + 1}, {tx, ty}}
  def move({{hx, hy}, {tx, ty}}, :down), do: {{hx, hy - 1}, {tx, ty}}

  def path(position, move, acc), do: [move(position, move) | acc]

  def compute_path(moves) do
    initial_position = {{0, 0}, {0, 0}}

    moves
    |> Enum.reduce([initial_position], fn move, [hd | _] = acc ->
      hd |> path(move, acc)
    end)
    |> Enum.reverse()
  end

  def count_unique_tail_positions(positions) do
    positions
    |> Enum.reduce(MapSet.new([]), fn {_, tl}, acc ->
      acc |> MapSet.put(tl)
    end)
    |> MapSet.size()
  end

  def launch(input) do
    input
    |> parse()
    |> compute_path()
    |> count_unique_tail_positions()
  end
end
