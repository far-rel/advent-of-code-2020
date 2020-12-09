defmodule Puzzle4 do
  def solve do
    read_data()
    |> Enum.reduce(0, fn (passport, acc) ->
      passport
      |> validate_passport()
      |> case do
        true -> acc + 1
        false -> acc
      end
    end)
    |> IO.puts()
  end

  defp validate_passport(passport) do
    passport
    |> Enum.reduce(0, fn (entry, acc) ->
      entry
      |> validate_entry()
      |> case do
        true -> acc + 1
        false -> acc
      end
    end)
    |> case do
      7 -> true
      _ -> false
    end
  end

  defp validate_entry(["byr", value]) do
    Enum.member?(1920..2002, String.to_integer(value))
  end
  defp validate_entry(["iyr", value]) do
    Enum.member?(2010..2020, String.to_integer(value))
  end
  defp validate_entry(["eyr", value]) do
    Enum.member?(2020..2030, String.to_integer(value))
  end
  defp validate_entry(["hgt", value]) do
    value
    |> String.ends_with?("cm")
    |> case do
      true ->
        int = value
        |> String.replace("cm", "")
        |> String.to_integer()
        Enum.member?(150..193, int)
      false ->
        value
        |> String.ends_with?("in")
        |> case do
             true ->
               int = value
                     |> String.replace("in", "")
                     |> String.to_integer()
               Enum.member?(59..76, int)
             false -> false
        end
    end
  end
  defp validate_entry(["hcl", value]) do
    {:ok, regex} = Regex.compile("#[0-9a-f]{6}")
    String.match?(value, regex)
  end
  defp validate_entry(["ecl", value]) do
    Enum.member?(["amb", "blu", "brn", "gry", "grn", "hzl", "oth"], value)
  end
  defp validate_entry(["pid", value]) do
    {:ok, regex} = Regex.compile("[0-9]{9}")
    (String.match?(value, regex) && String.length(value) == 9)
    |> IO.inspect(label: value)
  end
  defp validate_entry(_), do: false

  defp read_data() do
    File.read!("input.txt")
    |> String.split("\n\n")
    |> Enum.map(fn (entries) ->
      entries
      |> String.split("\n")
      |> Enum.flat_map(&String.split(&1, " "))
      |> Enum.map(&String.split(&1, ":"))
    end)
  end
end

Puzzle4.solve()
