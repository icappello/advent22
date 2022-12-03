defmodule Puzzle2 do
  require Logger

  @lowercase for x <- ?a..?z, do: <<x::utf8>>
  @uppercase for x <- ?A..?Z, do: <<x::utf8>>
  @ordered @lowercase ++ @uppercase

  def find_common([_s1, _s2, _s3] = group) do
    [set1, set2, set3] =
      group |> Enum.map(fn l -> l |> String.split("") |> MapSet.new() |> MapSet.delete("") end)

    set1
    |> MapSet.intersection(set2)
    |> MapSet.intersection(set3)
    |> MapSet.to_list()
    |> Enum.at(0)
  end

  def score_group(g) do
    g |> find_common() |> score_char()
  end

  def score_input(input) do
    input
    |> String.split("\n")
    |> Enum.chunk_every(3)
    |> Enum.reduce(0, fn g, acc -> acc + score_group(g) end)
  end

  def launch(path) do
    File.read!(path) |> score_input()
  end

  defp score_char(c) do
    (@ordered |> Enum.find_index(fn v -> v == c end)) + 1
  end
end
