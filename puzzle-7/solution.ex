defmodule Puzzle7 do
  def solve(bag_color) do
    data = read_data()
    |> parse_data()
    data
    |> list_bags(bag_color)
    |> Enum.count()
    |> IO.inspect()
    data
    |> count_bags_inside(bag_color)
    |> IO.inspect()
  end

  defp count_bags_inside(data, bag_color) do
    data
    |> Map.get(bag_color)
    |> Enum.reduce(0, fn ({bag_color, count}, acc) ->
      acc + count + count * count_bags_inside(data, bag_color)
    end)
  end

  defp list_bags(data, target_bag_color) do
    data
    |> Map.keys()
    |> Enum.reduce([], fn (bag_color, acc) ->
      bag_can_contain?(data, bag_color, target_bag_color)
      |> case do
        true -> [bag_color | acc]
        false -> acc
      end
    end)
    |> Enum.uniq()
  end

  defp bag_can_contain?(data, bag_color, target_bag_color) do
    contents = Map.get(data, bag_color)
    content_keys = Map.keys(contents)
    Enum.member?(content_keys, target_bag_color)
    |> case do
      true -> true
      false -> Enum.any?(content_keys, fn (bag_color) -> bag_can_contain?(data, bag_color, target_bag_color) end)
    end
  end

  defp parse_data(data) do
    data
    |> Enum.reduce(%{}, fn (row, acc) ->
      [bag_color, contents] = String.split(row,  " bags contain ")
      content_map = contents
      |> case do
        "no other bags." -> %{}
        _ ->
          contents
          |> String.replace(" bags.", "")
          |> String.replace(" bag.", "")
          |> String.split([" bags, ", " bag, "])
          |> Enum.reduce(%{}, fn (entries, acc) ->
            [number | color_words] = String.split(entries, " ")
            Map.put(acc, Enum.join(color_words, " "), String.to_integer(number))
          end)
      end
      Map.put(acc, bag_color, content_map)
    end)
  end

  defp read_data() do
    File.read!("input.txt")
    |> String.split("\n")
  end
end

Puzzle7.solve("shiny gold")
