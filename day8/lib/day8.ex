defmodule Day8 do
  require Logger

  def parse(input) do
    input
    |> String.split("\n")
    |> Enum.with_index()
    |> Enum.reduce(
      %{},
      fn {line, row_idx}, acc ->
        line
        |> String.graphemes()
        |> Enum.with_index()
        |> Enum.map(fn {c, col_idx} -> {{col_idx, row_idx}, c |> String.to_integer()} end)
        |> Enum.into(%{})
        |> Map.merge(acc)
      end
    )
  end

  def determine_visibility(grid) do
    grid_size = grid |> map_size() |> :math.sqrt() |> trunc()

    %{}
    |> add_visibility(grid, grid_size, :left)
    |> add_visibility(grid, grid_size, :right)
    |> add_visibility(grid, grid_size, :top)
    |> add_visibility(grid, grid_size, :bottom)
  end

  def add_visibility(acc, grid, grid_size, :left) do
    visibility =
      0..(grid_size - 1)
      |> Enum.map(fn idx ->
        {idx, %{max: grid |> Map.get({0, idx}), visible: [{0, idx}]}}
      end)
      |> Enum.into(%{})

    grid_coords =
      for x <- 1..(grid_size - 1), y <- 0..(grid_size - 1) do
        {x, y}
      end

    visibility =
      grid_coords
      |> Enum.reduce(visibility, fn {x, y}, acc ->
        element = grid |> Map.get({x, y})
        current_max = acc |> get_in([y, :max])

        acc
        |> update_visibility(grid, {x, y}, element > current_max, :left)
      end)

    acc |> Map.put(:left, visibility)
  end

  def add_visibility(acc, grid, grid_size, :right) do
    visibility =
      (grid_size - 1)..0
      |> Enum.map(fn idx ->
        {idx, %{max: grid |> Map.get({grid_size - 1, idx}), visible: [{grid_size - 1, idx}]}}
      end)
      |> Enum.into(%{})

    grid_coords =
      for x <- (grid_size - 2)..0, y <- 0..(grid_size - 1) do
        {x, y}
      end

    visibility =
      grid_coords
      |> Enum.reduce(visibility, fn {x, y}, acc ->
        element = grid |> Map.get({x, y})
        current_max = acc |> get_in([y, :max])

        acc
        |> update_visibility(grid, {x, y}, element > current_max, :left)
      end)

    acc |> Map.put(:right, visibility)
  end

  def add_visibility(acc, grid, grid_size, :bottom) do
    visibility =
      (grid_size - 1)..0
      |> Enum.map(fn idx ->
        {idx, %{max: grid |> Map.get({idx, grid_size - 1}), visible: [{idx, grid_size - 1}]}}
      end)
      |> Enum.into(%{})

    grid_coords =
      for x <- 0..(grid_size - 1), y <- (grid_size - 2)..0 do
        {x, y}
      end

    visibility =
      grid_coords
      |> Enum.reduce(visibility, fn {x, y}, acc ->
        element = grid |> Map.get({x, y})
        current_max = acc |> get_in([x, :max])

        acc
        |> update_visibility(grid, {x, y}, element > current_max, :bottom)
      end)

    acc |> Map.put(:bottom, visibility)
  end

  def add_visibility(acc, grid, grid_size, :top) do
    visibility =
      (grid_size - 1)..0
      |> Enum.map(fn idx ->
        {idx, %{max: grid |> Map.get({idx, 0}), visible: [{idx, 0}]}}
      end)
      |> Enum.into(%{})

    grid_coords =
      for x <- 0..(grid_size - 1), y <- 1..(grid_size - 1) do
        {x, y}
      end

    visibility =
      grid_coords
      |> Enum.reduce(visibility, fn {x, y}, acc ->
        element = grid |> Map.get({x, y})
        current_max = acc |> get_in([x, :max])

        acc
        |> update_visibility(grid, {x, y}, element > current_max, :top)
      end)

    acc |> Map.put(:top, visibility)
  end

  def update_visibility(visibility, _, _, false, _), do: visibility

  def update_visibility(visibility, grid, {x, y}, true, direction)
      when direction in [:left, :right] do
    element = grid |> Map.get({x, y})
    current_visible = visibility |> get_in([y, :visible])

    visibility |> Map.put(y, %{max: element, visible: [{x, y} | current_visible]})
  end

  def update_visibility(visibility, grid, {x, y}, true, direction)
      when direction in [:bottom, :top] do
    element = grid |> Map.get({x, y})
    current_visible = visibility |> get_in([x, :visible])

    visibility |> Map.put(x, %{max: element, visible: [{x, y} | current_visible]})
  end

  def count_visible(grid) do
    grid
    |> determine_visibility()
    |> Enum.reduce([], fn {_direction, slices}, acc1 ->
      slices |> Enum.reduce(acc1, fn {_idx, %{visible: l}}, acc2 -> acc2 ++ l end)
    end)
    |> MapSet.new()
    |> MapSet.size()
  end

  def compute_scenic_score(grid, {x, y}, _grid_size, :left) when x > 0 do
    tree = grid |> Map.get({x, y})

    {counter, _, _} =
      (x - 1)..0
      |> Enum.reduce({0, tree, true}, fn
        other_x, {counter, current_max, true} ->
          other_tree = grid |> Map.get({other_x, y})
          new_max = max(other_tree, current_max)
          {counter + 1, new_max, other_tree < new_max}

        _other_x, {counter, current_max, false} ->
          {counter, current_max, false}
      end)

    counter
  end

  def compute_scenic_score(grid, {x, y}, grid_size, :right) when x < grid_size - 1 do
    tree = grid |> Map.get({x, y})

    {counter, _, _} =
      (x + 1)..(grid_size - 1)
      |> Enum.reduce({0, tree, true}, fn
        other_x, {counter, current_max, true} ->
          other_tree = grid |> Map.get({other_x, y})
          new_max = max(other_tree, current_max)
          {counter + 1, new_max, other_tree < new_max}

        _other_x, {counter, current_max, false} ->
          {counter, current_max, false}
      end)

    counter
  end

  def compute_scenic_score(grid, {x, y}, grid_size, :bottom) when y < grid_size - 1 do
    tree = grid |> Map.get({x, y})

    {counter, _, _} =
      (y + 1)..(grid_size - 1)
      |> Enum.reduce({0, tree, true}, fn
        other_y, {counter, current_max, true} ->
          other_tree = grid |> Map.get({x, other_y})
          new_max = max(other_tree, current_max)
          {counter + 1, new_max, other_tree < new_max}

        _other_x, {counter, current_max, false} ->
          {counter, current_max, false}
      end)

    counter
  end

  def compute_scenic_score(grid, {x, y}, _grid_size, :top) when y > 0 do
    tree = grid |> Map.get({x, y})

    {counter, _, _} =
      (y - 1)..0
      |> Enum.reduce({0, tree, true}, fn
        other_y, {counter, current_max, true} ->
          other_tree = grid |> Map.get({x, other_y})
          new_max = max(other_tree, current_max)
          {counter + 1, new_max, other_tree < new_max}

        _other_x, {counter, current_max, false} ->
          {counter, current_max, false}
      end)

    counter
  end

  def compute_scenic_score(_, _, _, _), do: 0

  def compute_scenic_score(grid, {x, y}, grid_size) do
    [:left, :right, :top, :bottom]
    |> Enum.reduce(1, fn direction, acc ->
      acc * compute_scenic_score(grid, {x, y}, grid_size, direction)
    end)
  end

  def find_most_scenic_tree(grid) do
    grid_size = grid |> map_size() |> :math.sqrt() |> trunc()

    grid_coords =
      for x <- 0..(grid_size - 1), y <- 1..(grid_size - 1) do
        {x, y}
      end

    grid_coords
    |> Enum.reduce(-1, fn {x, y}, current_max ->
      grid |> compute_scenic_score({x, y}, grid_size) |> max(current_max)
    end)
  end

  def launch(input, :puzzle1) do
    input |> parse() |> count_visible()
  end

  def launch(input, :puzzle2) do
    input |> parse() |> find_most_scenic_tree()
  end
end
