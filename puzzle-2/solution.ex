defmodule Puzzle2 do

  def solve() do
    read_data()
    |> Enum.map(&parse_row/1)
    |> Enum.reduce(0, fn (definition, acc) ->
      definition
      |> validate_password()
      |> case do
        true -> acc + 1
        false -> acc
      end
    end)
    |> IO.puts()
  end

#  defp validate_password([min, max, letter, password | _tail]) do
#    size = password
#    |> String.split("")
#    |> Enum.filter(fn (e) -> e == letter end)
#    |> Enum.count()
#    Enum.member?(String.to_integer(min)..String.to_integer(max), size)
#  end

  defp validate_password([pos_1, pos_2, letter, password | _tail]) do
    [pos_1, pos_2]
    |> Enum.map(&String.to_integer/1)
    |> Enum.reduce(0, fn (position, acc) ->
      password
      |> String.at(position - 1)
      |> case do
        x when x == letter -> acc + 1
        _ -> acc
      end
    end)
    |> case do
      1 -> true
      _ -> false
    end
  end

  defp parse_row(entry) do
    entry
    |> extract_password()
    |> extract_letter()
    |> extract_min_max()
  end

  defp extract_password(string), do: String.split(string, ": ")
  defp extract_letter([definition | tail]), do: String.split(definition, " ") ++ tail
  defp extract_min_max([definition | tail]), do: String.split(definition, "-") ++ tail

  defp read_data() do
    File.read!("input.txt")
    |> String.split("\n")
  end
end

Puzzle2.solve()
