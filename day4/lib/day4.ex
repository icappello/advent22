defmodule Day4 do
  @spec section_bounds(binary) :: {integer(), integer()}
  def section_bounds(section) do
    [l1, l2] = section |> String.split("-") |> Enum.map(fn s -> String.to_integer(s) end)
    {l1, l2}
  end

  @spec is_contained({integer(), integer()}, {integer(), integer()}) :: boolean
  def is_contained({l1, u1}, {l2, u2}) do
    l1 >= l2 && u1 <= u2
  end

  @spec overlaps({integer(), integer()}, {integer(), integer()}) :: boolean
  def overlaps({l1, u1}, {l2, u2}) do
    l1 <= u2 && u1 >= l2
  end

  @spec check({{integer, integer}, {integer, integer}}, :puzzle1 | :puzzle2) :: boolean
  def check({s1, s2}, :puzzle1) do
    s1 |> is_contained(s2) || s2 |> is_contained(s1)
  end

  def check({s1, s2}, :puzzle2) do
    s1 |> overlaps(s2) || s2 |> overlaps(s1)
  end

  @spec count(binary | list, :puzzle1 | :puzzle2) :: non_neg_integer
  def count(pairings, puzzle) when is_list(pairings) do
    pairings
    |> Enum.map(fn pairing -> check(pairing, puzzle) end)
    |> Enum.filter(fn v -> v end)
    |> length()
  end

  def count(input, puzzle) when is_binary(input) do
    input
    |> String.split("\n")
    |> Enum.map(fn l ->
      [section1, section2] = l |> String.split(",")
      {section_bounds(section1), section_bounds(section2)}
    end)
    |> count(puzzle)
  end

  @spec launch(binary(), :puzzle1 | :puzzle2) :: non_neg_integer
  def launch(path, puzzle) do
    File.read!(path) |> count(puzzle)
  end
end
