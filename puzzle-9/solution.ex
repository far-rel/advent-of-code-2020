defmodule Puzzle9 do
  def solve() do
    data = read_data()
    {integer, _} = Enum.reduce(data, {nil, []}, &reduction/2)
    IO.inspect(integer)
    array = find_sum(data, [], integer)
    IO.inspect(Enum.min(array) + Enum.max(array))
  end

  defp find_sum(left_to_check, current_array, integer) do
    sum = Enum.sum(current_array)
    cond do
      sum == integer -> current_array
      sum > integer ->
        find_sum(
          left_to_check,
          Enum.slice(current_array, 0..(Enum.count(current_array) -  2)),
          integer
        )
      sum < integer ->
        [first | tail] = left_to_check
        find_sum(
          tail,
          [first | current_array],
          integer
        )
    end
  end

  defp reduction(integer, {nil, acc}) do
    acc
    |> Enum.count()
    |> case do
      25 ->
        check_sum(integer, acc)
        |> case do
          false -> {integer, acc}
          true -> {nil, [integer | Enum.slice(acc, 0..23)]}
        end
      _ -> {nil, [integer | acc]}
    end
  end
  defp reduction(integer, {int, acc}), do: {int, acc}

  defp check_sum(integer, list) do
    Enum.reduce(list, false, fn (el, acc) ->
      acc || Enum.any?(list, fn (el2) -> el + el2 == integer end)
    end)
  end

  defp read_data() do
    File.read!("input.txt")
    |> String.split("\n")
    |> Enum.map(&String.to_integer/1)
  end
end

Puzzle9.solve()
