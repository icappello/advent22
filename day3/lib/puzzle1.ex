defmodule Puzzle1 do
  require Logger

  @lowercase for x <- ?a..?z, do: <<x::utf8>>
  @uppercase for x <- ?A..?Z, do: <<x::utf8>>
  @ordered @lowercase ++ @uppercase

  def split(input) do
    middle = input |> String.length() |> div(2)
    input |> String.split_at(middle)
  end

  def find_common({p1, p2}) do
    set1 = p1 |> String.split("") |> MapSet.new() |> MapSet.delete("")
    set2 = p2 |> String.split("") |> MapSet.new() |> MapSet.delete("")

    set1 |> MapSet.intersection(set2) |> MapSet.to_list() |> Enum.at(0)
  end

  def score_line(input) do
    input |> split() |> find_common() |> score_char()
  end

  def score_input(input) do
    input |> String.split("\n") |> Enum.reduce(0, fn l, acc -> acc + score_line(l) end)
  end

  def launch(path) do
    File.read!(path) |> score_input()
  end

  defp score_char(c) do
    (@ordered |> Enum.find_index(fn v -> v == c end)) + 1
  end
end
