defmodule Puzzle3 do
  def solve() do
    data = read_data()
    IO.puts(
      solve(data, 1, 1) * solve(data, 3, 1) * solve(data, 5, 1) * solve(data, 7, 1) * solve(data, 1, 2)
    )
  end

  def solve(data, x, y) do
    [_col, trees] = data
    |> Enum.with_index
    |> Enum.reduce([0, 0], fn ({string, index}, [column, trees]) ->
      rem(index, y)
      |> case do
        0 ->
          string
          |> String.at(column)
          |> case do
            "#" -> [rem(column + x, String.length(string)), trees + 1]
            _ -> [rem(column + x, String.length(string)), trees]
          end
        _ -> [column, trees]
      end
    end)
    trees
  end

  defp read_data() do
    File.read!("input.txt")
    |> String.split("\n")
  end
end

Puzzle3.solve()
