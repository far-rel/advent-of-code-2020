defmodule Puzzle17 do
  def solve() do
    initial_data = read_data() |> nicely_print()
    1..6
    |> Enum.reduce(initial_data, &generate_next/2)
    |> Map.get(:data)
    |> Map.values()
    |> Enum.sum()
    |> IO.inspect()
  end

  defp generate_next(_, %{min_x: min_x, max_x: max_x, min_y: min_y, max_y: max_y, min_z: min_z, max_z: max_z, min_w: min_w, max_w: max_w, data: data}) do
    new_data = (min_x-1)..(max_x+1)
    |> Enum.reduce(%{}, fn (x, acc) ->
      (min_y-1)..(max_y+1)
      |> Enum.reduce(acc, fn (y, acc1) ->
        (min_z-1)..(max_z+1)
        |> Enum.reduce(acc1, fn (z, acc2) ->
          (min_w-1)..(max_w+1)
          |> Enum.reduce(acc2, fn (w, acc3) ->
            neighbours = count_neighbours(data, x, y, z, w)
            Map.get(data, {x,y,z,w})
            |> case do
              nil ->
                case neighbours do
                  3 -> Map.put(acc3, {x, y, z, w}, 1)
                  _ -> acc3
                end
              1 ->
                case neighbours do
                  2 -> Map.put(acc3, {x, y, z, w}, 1)
                  3 -> Map.put(acc3, {x, y, z, w}, 1)
                  _ -> acc3
                end
            end
          end)
        end)
      end)
    end)

    get_boundaries(new_data)
    |> Map.put(:data, new_data)
    |> nicely_print()
  end

  defp get_boundaries(data) do
    keys = data |> Map.keys()
    min_x = keys |> Enum.map(fn ({x, _, _, _}) -> x end) |> Enum.min()
    max_x = keys |> Enum.map(fn ({x, _, _, _}) -> x end) |> Enum.max()
    min_y = keys |> Enum.map(fn ({_, y, _, _}) -> y end) |> Enum.min()
    max_y = keys |> Enum.map(fn ({_, y, _, _}) -> y end) |> Enum.max()
    min_z = keys |> Enum.map(fn ({_, _, z, _}) -> z end) |> Enum.min()
    max_z = keys |> Enum.map(fn ({_, _, z, _}) -> z end) |> Enum.max()
    min_w = keys |> Enum.map(fn ({_, _, _, w}) -> w end) |> Enum.min()
    max_w = keys |> Enum.map(fn ({_, _, _, w}) -> w end) |> Enum.max()
    %{
      min_x: min_x,
      max_x: max_x,
      min_y: min_y,
      max_y: max_y,
      min_z: min_z,
      max_z: max_z,
      min_w: min_w,
      max_w: max_w
    }
  end

  defp nicely_print(%{min_x: min_x, max_x: max_x, min_y: min_y, max_y: max_y, min_z: min_z, max_z: max_z, min_w: min_w, max_w: max_w, data: data}) do
    min_w..max_w
    |> Enum.each(fn (w) ->
      min_z..max_z
      |> Enum.each(fn (z) ->
        IO.puts("w=#{w} z=#{z}")
        max_y..min_y
        |> Enum.each(fn (y) ->
          min_x..max_x
          |> Enum.reduce("", fn  (x, acc) ->
            tmp = case Map.get(data, {x,y,z,w}) do
              1 -> "#"
              nil -> "."
            end
            acc <> tmp
          end)
          |> IO.puts()
        end)
      end)
    end)
    %{min_x: min_x, max_x: max_x, min_y: min_y, max_y: max_y, min_z: min_z, max_z: max_z, min_w: min_w, max_w: max_w, data: data}
  end

  defp generate_coordinates_around(x, y, z, w) do
    -1..1
    |> Enum.reduce([], fn (del_x, acc) ->
      -1..1
      |> Enum.reduce(acc, fn (del_y, acc1) ->
        -1..1
        |> Enum.reduce(acc1, fn (del_z, acc2) ->
          -1..1
          |> Enum.reduce(acc2, fn (del_w, acc3) ->
            {del_x, del_y, del_z, del_w}
            |> case do
              {0, 0, 0, 0} -> acc3
              _ -> [{x + del_x, y + del_y, z + del_z, w + del_w} | acc3]
            end
          end)
        end)
      end)
    end)
  end

  def count_neighbours(data, x, y, z, w) do
    generate_coordinates_around(x, y, z, w)
    |> Enum.map(fn (coords) -> Map.get(data, coords) end)
    |> Enum.reject(fn (val) -> val == nil end)
    |> Enum.sum()
  end

  defp read_data() do
    tmp = File.read!("input.txt")
    |> String.split("\n")
    initial_size = Enum.count(tmp)
    dict = tmp
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn ({string, y}, acc) ->
      string
      |> String.split("")
      |> Enum.reject(fn (s) -> s == "" end)
      |> Enum.with_index()
      |> Enum.reduce(acc, fn ({s, x}, acc1) ->
        case s do
          "#" -> Map.put(acc1, {x, -y, 0, 0}, 1)
          "." -> acc1
        end
      end)
    end)
    %{
      min_x: 0,
      max_x: initial_size - 1,
      max_y: 0,
      min_y: -(initial_size - 1),
      min_z: 0,
      max_z: 0,
      min_w: 0,
      max_w: 0,
      data: dict
    }
  end

end

Puzzle17.solve()
