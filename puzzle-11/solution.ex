defmodule Puzzle11 do
  def solve() do
    read_data()
    |> process_data()
  end

  defp process_data(data) do
    next_iteration = data
    |> Enum.with_index()
    |> Enum.map(fn ({array, y}) ->
      array
      |> Enum.with_index()
      |> Enum.map(fn ({cell, x}) ->
        cell
        |> case do
          "." -> "."
          "#" ->
            data
            |> number_of_occupied_visible(x, y)
            |> case do
              x when x >= 5 -> "L"
              _ -> "#"
            end
          "L" ->
              data
              |> number_of_occupied_visible(x, y)
              |> case do
                0 -> "#"
                _ -> "L"
              end
        end
      end)
    end)
    (join_to_string(data) == join_to_string(next_iteration))
    |> case do
      true ->
        next_iteration
        |> Enum.reduce(0, fn (array, acc) ->
          acc + Enum.reduce(array, 0, fn (el, acc1) ->
            case el do
              "#" -> acc1 + 1
              _ -> acc1
            end
          end)
        end)
        |> IO.inspect()
      false -> process_data(next_iteration)
    end
  end

  defp join_to_string(data) do
    data
    |> Enum.map(fn (array) -> Enum.join(array, "") end)
    |> Enum.join("\n")
  end

  defp number_of_occupied_visible(data, x, y) do
    taken_in_direction(data, x, y, 0, 1) +
      taken_in_direction(data, x, y, 0, -1) +
      taken_in_direction(data, x, y, 1, 0) +
      taken_in_direction(data, x, y, -1, 0) +
      taken_in_direction(data, x, y, 1, 1) +
      taken_in_direction(data, x, y, 1, -1) +
      taken_in_direction(data, x, y, -1, 1) +
      taken_in_direction(data, x, y, -1, -1)
  end

  defp taken_in_direction(data, x, y, del_x, del_y) do
    new_x = x + del_x
    new_y = y + del_y
    in_boundaries(data, new_x, new_y)
    |> case do
      false -> 0
      true ->
        take(data, new_x, new_y)
        |> case do
          "#" -> 1
          "L" -> 0
          "." -> taken_in_direction(data, new_x, new_y, del_x, del_y)
        end
    end
  end

  defp in_boundaries(data, x, y) do
    max_y = Enum.count(data) - 1
    max_x = Enum.count(Enum.at(data, 0)) - 1
    Enum.member?(0..max_y, y)
    |> case do
      true -> Enum.member?(0..max_x, x)
      false -> false
    end
  end

  defp take(data, x, y), do: Enum.at(Enum.at(data, y), x)

#  defp number_of_occupied_around(data, x, y) do
#    x_size = data |> Enum.at(0) |> Enum.count()
#    y_size = data |> Enum.count()
#    min_x = max(0, x - 1)
#    max_x = min(x_size - 1, x + 1)
#    min_y = max(0, y - 1)
#    max_y = min(y_size - 1, y + 1)
#    data
#    |> Enum.slice(min_y..max_y)
#    |> Enum.map(fn (array) -> Enum.slice(array, min_x..max_x) end)
#    |> List.flatten()
#    |> Enum.reject(fn (el) -> el != "#" end)
#    |> Enum.count()
#  end

  defp read_data() do
    File.read!("input.txt")
    |> String.split("\n")
    |> Enum.map(fn (string) ->
      string
      |> String.split("")
      |> Enum.reject(fn (el) -> el == "" end)
    end)
  end
end

Puzzle11.solve()
