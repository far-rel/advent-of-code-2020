defmodule Puzzle5 do
  def solve() do
    seats = read_data()
    |> Enum.map(&seat_id/1)

    0..871
    |> Enum.reject(fn el -> Enum.member?(seats, el) end)
    |> IO.inspect()
  end

  defp seat_id(binary_partition) do
    binary_partition
    |> String.split("")
    |> Enum.reduce([0, 128, 0, 8], fn(direction, [row_min, row_max, col_min, col_max]) ->
      half_row_range = div(row_max - row_min, 2)
      half_col_range = div(col_max - col_min, 2)
      direction
      |> case do
        "F" -> [row_min, row_max - half_row_range, col_min, col_max]
        "B" -> [row_min + half_row_range, row_max, col_min, col_max]
        "L" -> [row_min, row_max, col_min, col_max - half_col_range]
        "R" -> [row_min, row_max, col_min + half_col_range, col_max]
        _ -> [row_min, row_max, col_min, col_max]
      end
    end)
    |> seat_id_from_row_and_columns()
  end

  defp seat_id_from_row_and_columns([row_min, _row_max, col_min, _col_max]), do: row_min * 8 + col_min

  defp read_data() do
    File.read!("input.txt")
    |> String.split("\n")
  end
end

Puzzle5.solve()
