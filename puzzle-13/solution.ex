# Credit: https://rosettacode.org/wiki/Modular_inverse#Elixir
defmodule Modular do
  def extended_gcd(a, b) do
    {last_remainder, last_x} = extended_gcd(abs(a), abs(b), 1, 0, 0, 1)
    {last_remainder, last_x * (if a < 0, do: -1, else: 1)}
  end

  defp extended_gcd(last_remainder, 0, last_x, _, _, _), do: {last_remainder, last_x}
  defp extended_gcd(last_remainder, remainder, last_x, x, last_y, y) do
    quotient   = div(last_remainder, remainder)
    remainder2 = rem(last_remainder, remainder)
    extended_gcd(remainder, remainder2, x, last_x - quotient*x, y, last_y - quotient*y)
  end

  def inverse(e, et) do
    {g, x} = extended_gcd(e, et)
    if g != 1, do: raise "The maths are broken!"
    rem(x+et, et)
  end
end

defmodule Puzzle13 do
  def solve() do
    {timestamp, buses} = read_data()
    {earliest_bus_id, waiting_time} = buses
    |> Enum.reduce({nil, nil}, fn (bus_id, {earliest_bus_id, waiting_time}) ->
      case bus_id do
        "x" -> {earliest_bus_id, waiting_time}
        _ ->
          new_waiting_time = bus_id - rem(timestamp, bus_id)
          case waiting_time do
            nil -> {bus_id, new_waiting_time}
            x when x > new_waiting_time -> {bus_id, new_waiting_time}
            _ -> {earliest_bus_id, waiting_time}
          end
      end
    end)
    (earliest_bus_id * waiting_time)
    |> IO.inspect()

    mod_equations = buses
    |> Enum.with_index()
    |> Enum.reject(fn ({bus_id, _}) -> bus_id == "x" end)
    |> Enum.map(fn {bus_id, index} ->
      {bus_id, bus_id - rem(index, bus_id)}
    end)
    n = Enum.reduce(mod_equations, 1, fn ({mod1, _}, acc) -> mod1 * acc end)
    mod_equations
    |> Enum.map(fn ({mod1, result}) ->
      small_n = div(n, mod1)
      small_n * Modular.inverse(small_n, mod1) * result
    end)
    |> Enum.sum()
    |> rem(n)
    |> IO.inspect()
  end

  defp read_data() do
    [timestamp, buses] = File.read!("input.txt")
    |> String.split("\n")
    mapped_buses = buses
    |> String.split(",")
    |> Enum.map(fn (string) ->
      string
      |> case do
        "x" -> "x"
        n -> String.to_integer(n)
      end
    end)
    {String.to_integer(timestamp), mapped_buses}
  end
end

Puzzle13.solve()
