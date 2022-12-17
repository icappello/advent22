defmodule Day15 do
  require Logger

  def parse_line(line) do
    [_, sensor_x, sensor_y, beacon_x, beacon_y] =
      ~r/Sensor at x=(-?\d+), y=(-?\d+): closest beacon is at x=(-?\d+), y=(-?\d+)/
      |> Regex.run(line)

    sensor = {String.to_integer(sensor_x), String.to_integer(sensor_y)}
    beacon = {String.to_integer(beacon_x), String.to_integer(beacon_y)}
    distance = sensor |> manhattan_distance(beacon)

    {sensor, beacon, distance}
  end

  def parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.reduce({%{}, %{}}, fn line, {sensors, beacons} ->
      {sensor_position, beacon_position, distance} = parse_line(line)
      sensors = sensors |> Map.put(sensor_position, {beacon_position, distance})
      beacon_info = beacons |> Map.get(beacon_position, [])

      beacons =
        beacons
        |> Map.put(
          beacon_position,
          [{sensor_position, distance} | beacon_info]
          |> Enum.sort(fn {_, d1}, {_, d2} -> d1 < d2 end)
        )

      {sensors, beacons}
    end)
  end

  def find_relevant_sensors(sensors, y, :puzzle1) do
    sensors
    |> Enum.reduce(%{}, fn {{x_sensor, _} = sensor, {_, distance}}, acc ->
      projection = {x_sensor, y}
      projection_distance = manhattan_distance(sensor, projection)

      acc |> maybe_add_relevant_sensor(sensor, projection_distance, distance, :puzzle1)
    end)
  end

  def cover(sensors, beacons, y, :puzzle1) do
    sensors
    |> find_relevant_sensors(y, :puzzle1)
    |> Enum.reduce(MapSet.new(), fn {{sensor_x, _}, {delta, _, _}}, acc0 ->
      delta..0
      |> Enum.reduce(acc0, fn d, acc ->
        acc |> MapSet.put({sensor_x - d, y}) |> MapSet.put({sensor_x + d, y})
      end)
    end)
    |> remove_entities_from_row(beacons, y, :puzzle1)
  end

  def cover(sensors, _beacons, y, xmax, :puzzle2) do
    sensors
    |> find_relevant_sensors(y, :puzzle1)
    |> Enum.reduce(MapSet.new(), fn {{sensor_x, _}, {delta, _, _}}, acc0 ->
      acc0 |> add_cover_segment({sensor_x, y}, delta, xmax)
    end)
  end

  def cover_rows(sensors, beacons, xmax, ymax, :puzzle2) do
    0..ymax
    |> Enum.reduce({false, nil}, fn
      y, {false, _} ->
        Logger.warn("row #{y}")
        cover(sensors, beacons, y, xmax, :puzzle2) |> return_not_covered_position(xmax)

      _, {true, pos} ->
        {true, pos}
    end)
  end

  def find_free_position({sensors, beacons}, xmax, ymax) do
    case cover_rows(sensors, beacons, xmax, ymax, :puzzle2) do
      {true, pos} -> pos
      {false, _} -> nil
    end
  end

  def find_frequency({sensors, beacons}, xmax, ymax) do
    case {sensors, beacons} |> find_free_position(xmax, ymax) do
      {x, y} -> x * 4_000_000 + y
      _ -> nil
    end
  end

  def launch(input, y, :puzzle1) do
    {sensors, beacons} = parse(input)

    sensors |> cover(beacons, y, :puzzle1) |> MapSet.size()
  end

  def launch(input, xmax, ymax, :puzzle2) do
    input |> parse |> find_frequency(xmax, ymax)
  end

  defp manhattan_distance({x1, y1}, {x2, y2}) do
    abs(x2 - x1) + abs(y2 - y1)
  end

  defp maybe_add_relevant_sensor(acc, sensor, projection_distance, beacon_distance, :puzzle1)
       when projection_distance <= beacon_distance do
    acc
    |> Map.put(
      sensor,
      {beacon_distance - projection_distance, beacon_distance, projection_distance}
    )
  end

  defp maybe_add_relevant_sensor(acc, _, _, _, :puzzle1), do: acc

  defp remove_entities_from_row(acc, entities, y, :puzzle1) do
    to_be_removed =
      entities
      |> Map.keys()
      |> Enum.filter(fn {_, entity_y} -> entity_y == y end)
      |> MapSet.new()

    acc |> MapSet.difference(to_be_removed)
  end

  defp add_cover_segment(acc, {x, y}, delta, xmax) do
    acc |> MapSet.put({{max(0, x - delta), y}, {min(xmax, x + delta), y}})
  end

  defp return_not_covered_position(ms, xmax) do
    case ms |> MapSet.size() <= xmax do
      true -> find_not_covered_position(ms, xmax)
      false -> {false, nil}
    end
  end

  defp find_not_covered_position(ms, xmax) do
    merged = ms |> rec_merge()

    merged |> MapSet.to_list() |> maybe_retrieve_solution(xmax)
  end

  defp maybe_merge_segments({{sx1, y}, {ex1, _}}, {{sx2, _}, {ex2, _}} = s2) do
    cond do
      (sx1 <= sx2 and ex1 >= sx2 - 1) or (sx2 <= sx1 and ex2 >= sx1 - 1) ->
        [{{min(sx1, sx2), y}, {max(ex1, ex2), y}}]

      true ->
        [s2]
    end
  end

  defp maybe_retrieve_solution([{{x1, y}, {x2, _}}], xmax) when x1 > 0 and x2 == xmax do
    solution = {true, {x1 - 1, y}}
    solution
  end

  defp maybe_retrieve_solution([{{0, _}, {x2, y}}], xmax) when x2 > 0 and x2 < xmax do
    solution = {true, {x2 + 1, y}}
    solution
  end

  defp maybe_retrieve_solution([{{_, y}, {x1e, _}}, {{x2s, _}, {_, _}}], _)
       when x1e < x2s do
    solution = {true, {x1e + 1, y}}
    solution
  end

  defp maybe_retrieve_solution(_, _) do
    {false, nil}
  end

  defp rec_merge(ms), do: rec_merge(ms, MapSet.size(ms))

  defp rec_merge(ms, size) when size <= 1, do: ms

  defp rec_merge(ms, _) do
    [hd | tl] = ms |> MapSet.to_list()

    new_ms =
      tl
      |> MapSet.new()
      |> rec_merge()
      |> Enum.map(fn other_segment ->
        maybe_merged = maybe_merge_segments(hd, other_segment)

        maybe_merged
      end)
      |> Enum.flat_map(fn i -> i end)
      |> MapSet.new()

    cond do
      new_ms |> MapSet.put(hd) == ms ->
        new_ms

      new_ms |> MapSet.delete(hd) == new_ms ->
        new_ms |> rec_merge()

      true ->
        new_ms |> MapSet.delete(hd) |> rec_merge() |> MapSet.put(hd)
    end
  end
end
