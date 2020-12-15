defmodule Puzzle15 do
  def solve() do
    acc = [5, 1, 9, 18, 13, 8, 0]
          |> Enum.with_index()
          |> Enum.reduce(%{}, fn ({el, index}, acc) ->
            Map.put(acc, el, {index + 1, nil})
          end)

    offset = Enum.count(acc) + 1
#    last_iteration = 2020
    last_iteration = 30_000_000
    {_, last_element} = offset..last_iteration
    |> Enum.reduce({acc, 0}, fn (i, {prev_indexes, last_item}) ->
      IO.inspect(i)
      {last_index, next_to_last_index} = prev_indexes |> Map.get(last_item)
      next_item = next_to_last_index
      |> case do
        nil -> 0
        _ -> last_index - next_to_last_index
      end
      new_indexes = prev_indexes
      |> Map.get(next_item)
      |> case do
         nil -> {i, nil}
         {last_index, _} -> {i, last_index}
      end
      {Map.put(prev_indexes, next_item, new_indexes), next_item}
    end)

    IO.inspect(last_element)
  end
end

Puzzle15.solve()
