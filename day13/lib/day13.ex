defmodule Day13 do
  require Logger

  def parse(input) do
    input
    |> String.split("\n")
    |> Enum.chunk_every(3)
    |> Enum.map(fn
      [l1, l2, _] -> {parse_list(l1), parse_list(l2)}
      [l1, l2] -> {parse_list(l1), parse_list(l2)}
    end)
  end

  def compare_pair([], []), do: {true, :not_done}

  def compare_pair([], v) do
    Logger.warn("compare empty list vs #{inspect(v)}: true, done")
    # IO.read(:stdio, :line)
    {true, :done}
  end

  def compare_pair(v, []) do
    Logger.warn("compare #{inspect(v)} vs empty list: false, done")
    # IO.read(:stdio, :line)
    {false, :done}
  end

  def compare_pair(n1, n2) when is_number(n1) and is_number(n2) and n1 < n2 do
    Logger.warn("compare #{inspect({n1, n2})} true, done")
    # IO.read(:stdio, :line)
    {true, :done}
  end

  def compare_pair(n1, n2) when is_number(n1) and is_number(n2) and n1 > n2 do
    Logger.warn("compare #{inspect({n1, n2})} false, done")
    # IO.read(:stdio, :line)
    {false, :done}
  end

  def compare_pair(n1, n2) when is_number(n1) and is_number(n2) and n1 == n2 do
    Logger.warn("compare #{inspect({n1, n2})} true, not done")
    # IO.read(:stdio, :line)
    {true, :not_done}
  end

  def compare_pair(n1, l2) when is_number(n1) and is_list(l2) do
    compare_pair([n1], l2)
  end

  def compare_pair(l1, n2) when is_list(l1) and is_number(n2) do
    compare_pair(l1, [n2])
  end

  def compare_pair([hd1 | tl1] = l1, [hd2 | tl2] = l2) when is_list(l1) and is_list(l2) do
    case compare_pair(hd1, hd2) do
      {result, :done} ->
        Logger.warn("compare result #{result}, done")
        # IO.read(:stdio, :line)
        {result, :done}

      {true, :not_done} ->
        Logger.warn("compare result #{true}, not done")
        # IO.read(:stdio, :line)
        compare_pair(tl1, tl2)
    end
  end

  def compare_pair({a, b}), do: compare_pair(a, b)

  def launch(input, :puzzle1) do
    pairs = parse(input)

    pairs
    |> Enum.with_index(1)
    |> Enum.reduce(0, fn {pair, idx}, acc ->
      Logger.warn("outer cycle: #{inspect(pair)}")

      case compare_pair(pair) do
        {true, :done} -> acc + idx
        {false, :done} -> acc
        {_, :not_done} -> raise("ERR!")
      end
    end)
  end

  def launch(input, :puzzle2) do
    sorted =
      parse(input)
      |> Enum.reduce([[[2]], [[6]]], fn {l1, l2}, acc -> acc ++ [l1, l2] end)
      |> Enum.sort(fn l1, l2 ->
        {v, _} = compare_pair(l1, l2)
        v
      end)

    divider1_index = (sorted |> Enum.find_index(fn l -> l == [[2]] end)) + 1
    divider2_index = (sorted |> Enum.find_index(fn l -> l == [[6]] end)) + 1

    divider1_index * divider2_index
  end

  defp parse_list(l), do: Jason.decode!(l)
end
