defmodule Puzzle6 do
  def solve() do
    read_data()
    |> Enum.map(&count_everyone_yes/1)
    |> Enum.sum()
    |> IO.inspect()
  end

  defp count_everyone_yes(group_answers) do
    group_count = group_answers
    |> String.split("\n")
    |> Enum.count()
    group_answers
    |> String.replace("\n", "")
    |> String.split("")
    |> Enum.reject(fn (s) -> s == "" end)
    |> Enum.frequencies()
    |> Enum.reduce(0, fn ({_question, count}, acc) ->
      count
      |> case do
        x when x == group_count -> acc + 1
        _ -> acc
      end
    end)
  end

  defp count_unique_yes(group_answers) do
    group_answers
    |> String.replace("\n", "")
    |> String.split("")
    |> Enum.reject(fn (s) -> s == "" end)
    |> Enum.uniq()
    |> Enum.count()
  end

  defp read_data() do
    File.read!("input.txt")
    |> String.split("\n\n")
  end
end

Puzzle6.solve()
