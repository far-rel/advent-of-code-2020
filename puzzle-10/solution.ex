defmodule Puzzle10 do
  def solve() do
    read_data()
    |> Enum.sort()
    |> print_one_and_three()
    |> print_one_streaks()
  end

  defp print_one_streaks(data) do
    {one_streaks, _} = data
    |> Enum.reduce({[0], 0}, fn (adapter, {[current_streak | tail], previous}) ->
      (adapter - previous)
      |> case do
        1 -> {[current_streak + 1 | tail], adapter}
        _ ->
          current_streak
          |> case do
            0 -> {[current_streak | tail], adapter}
            _ -> {[ 0, current_streak | tail], adapter}
          end
        end
      end)
    |> IO.inspect()
    one_streaks
    |> Enum.map(&combinations_for_streak/1)
    |> Enum.reduce(1, &Kernel.*/2)
    |> IO.inspect()
    data
  end

  defp combinations_for_streak(n) do
    Enum.map(0..(:math.pow(4, n + 1) |> trunc()), fn (x) ->
      Integer.to_string(x, 4)
    end)
    |> Enum.map(fn (string) ->
      string
      |> String.split("")
      |> Enum.reject(fn (el) -> el == "" end)
      |> Enum.map(&String.to_integer/1)
      |> Enum.reject(fn (el) -> el == 0 end)
    end)
    |> Enum.reject(fn (array) ->
      Enum.sum(array) != n
    end)
    |> Enum.uniq()
    |> Enum.count()
  end

  defp print_one_and_three(data) do
    {jolt_1, jolt_3, _} = data
    |> Enum.reduce({0, 0, 0}, fn (adapter, {jolt_1, jolt_3, previous}) ->
        (adapter - previous)
        |> case do
           1 -> {jolt_1 + 1, jolt_3, adapter}
           3 -> {jolt_1, jolt_3 + 1, adapter}
           _ -> {jolt_1, jolt_3, adapter} |> IO.inspect()
         end
      end)
    |> IO.inspect()
    IO.inspect(jolt_1 * (jolt_3 + 1))
    data
  end

  defp read_data() do
    File.read!("input.txt")
    |> String.split("\n")
    |> Enum.map(&String.to_integer/1)
  end
end

Puzzle10.solve()
