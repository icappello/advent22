defmodule Day7 do
  require Logger

  @puzzle1_max_size 100_000

  @puzzle2_disk_space 70_000_000
  @puzzle2_min_free_space 30_000_000

  def parse_command(input) do
    cond do
      input == "$ ls" ->
        {:cmd, :list}

      input == "$ cd /" ->
        {:cmd, :root}

      input == "$ cd .." ->
        {:cmd, :parent}

      [_, name] = ~r/\$ cd (.+)/ |> Regex.run(input) ->
        {:cmd, :subdir, name}

      true ->
        nil
    end
  end

  def parse_output(line) do
    case ~r/(.*) (.+)/ |> Regex.run(line) do
      [_, "dir", name] -> {:result, :dir, name}
      [_, size, name] -> {:result, :file, name, String.to_integer(size)}
      _ -> nil
    end
  end

  def input_to_structs(input) do
    input
    |> String.split("\n")
    |> Enum.map(fn line -> _parse_line(line, line |> String.starts_with?("$")) end)
  end

  def parse(input) do
    {filesystem, _} =
      input
      |> input_to_structs()
      |> Enum.reduce({%{"/" => %{}}, ["/"]}, fn
        {:cmd, :list}, {filesystem, cwd} ->
          {filesystem, cwd}

        {:cmd, :root}, {filesystem, _cwd} ->
          {filesystem, ["/"]}

        {:cmd, :parent}, {filesystem, [_h | tl]} ->
          {filesystem, tl}

        {:cmd, :subdir, name}, {filesystem, cwd} ->
          {filesystem, [name | cwd]}

        {:result, :dir, name}, {filesystem, cwd} ->
          {filesystem |> put_in([name | cwd] |> Enum.reverse(), %{}), cwd}

        {:result, :file, name, size}, {filesystem, cwd} ->
          {filesystem |> put_in([name | cwd] |> Enum.reverse(), size), cwd}

        nil, {filesystem, cwd} ->
          {filesystem, cwd}
      end)

    filesystem
  end

  def get_sizes(input) do
    {_, [_ | sizes]} = input |> parse() |> _size_rec("/")

    sizes |> Enum.sort()
  end

  def filter_sizes(input, :puzzle1) do
    input
    |> get_sizes()
    |> Enum.filter(fn v -> v <= @puzzle1_max_size end)
    |> Enum.sort()
  end

  def filter_sizes(input, :puzzle2) do
    sizes = input |> get_sizes() |> Enum.sort()

    max = sizes |> Enum.reverse() |> Enum.at(0)

    already_free_space = @puzzle2_disk_space - max

    sizes |> Enum.filter(fn v -> already_free_space + v >= @puzzle2_min_free_space end)
  end

  def launch(input, :puzzle1) do
    input |> filter_sizes(:puzzle1) |> Enum.reduce(0, fn el, acc -> el + acc end)
  end

  def launch(input, :puzzle2) do
    input |> filter_sizes(:puzzle2) |> Enum.sort() |> Enum.at(0)
  end

  defp _parse_line(line, true), do: parse_command(line)
  defp _parse_line(line, false), do: parse_output(line)

  defp _size_rec(m, _parent_name) when is_map(m) do
    {parent_size, children} =
      m
      |> Enum.reduce({0, []}, fn {k, v}, {parent_size, children} ->
        {child_size, nephews} = _size_rec(v, k)
        {parent_size + child_size, children ++ nephews}
      end)

    {parent_size, [parent_size | children]}
  end

  defp _size_rec(v, _k) when is_number(v), do: {v, []}
end
