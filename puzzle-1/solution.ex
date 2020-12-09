defmodule Permutations do
  def shuffle(array, length) do
    (0..length-1)
    |> Enum.reduce([[]], fn (_x, acc) ->
      for x <- array, y <- acc do
        Enum.member?(y, x)
        |> case do
          true -> nil
          false -> [x | y]
        end
      end
      |> Enum.reject(&is_nil/1)
    end)
  end
end

defmodule Puzzle1 do
  def solve() do
    data = read_data()
    data
    |> Enum.each(fn (el) ->
      Enum.find_index(data, fn(e) -> 2020 - el == e end)
      |> case do
        nil -> nil
        x when x >= 0 -> IO.puts((2020 - el) * el)
        _ -> nil
      end
    end)
  end

  def solve3() do
    data = read_data()
    Enum.each(data, fn (i) ->
      Enum.each(data, fn (j) ->
        Enum.each(data, fn (k) ->
          i + j + k
          |> case do
            2020 -> IO.puts(i * j * k)
            _ -> nil
          end
        end)
      end)
    end)
  end

  def solve_n(length, sum) do
    read_data()
    |> Permutations.shuffle(length)
    |> Enum.each(&check_permutation(&1, sum))
  end

  defp check_permutation(array, sum) do
    array
    |> Enum.reduce(&Kernel.+/2)
    |> case do
      x when x == sum ->
        array
        |> Enum.reduce(&Kernel.*/2)
        |> IO.puts()
      _ -> nil
    end
  end

  defp read_data() do
    File.read!("input.txt")
    |> String.split("\n")
    |> Enum.map(&String.to_integer/1)
  end
end

Puzzle1.solve()
Puzzle1.solve_n(2, 2020)
Puzzle1.solve3()
Puzzle1.solve_n(3, 2020)

