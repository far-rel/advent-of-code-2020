defmodule Puzzle14 do
  def solve() do
    data = read_data()
    data
    |> map_values()
    |> sum_values()
    |> IO.inspect()

    data
    |> map_addresses()
    |> sum_values()
    |> IO.inspect()
  end

  defp map_values(map) do
    Enum.reduce(map, %{}, fn ({mem, value}, acc) ->
      case mem do
        "mask" -> Map.put(acc, mem, value)
        _ -> Map.put(acc, mem, masked_value(value, Map.get(acc, "mask")))
      end
    end)
  end

  defp map_addresses(map) do
    Enum.reduce(map, %{}, fn ({mem, value}, acc) ->
      case mem do
        "mask" -> Map.put(acc, mem, value)
        _ ->
          generate_addresses(mem, Map.get(acc, "mask"))
          |> Enum.reduce(acc, fn (address, acc1) ->
            Map.put(acc1, address, value)
          end)
      end
    end)
  end

  defp generate_addresses(address, mask) do
    split_mask = mask |> String.split("") |> Enum.reject(fn (el) -> el == "" end)
    split_address = address
                  |> Integer.to_string(2)
                  |> String.split("")
                  |> Enum.reject(fn (el) -> el == "" end)
                  |> pad_zeros(Enum.count(split_mask))
    List.zip([split_mask, split_address])
    |> Enum.map(&apply_address_mask/1)
    |> Enum.reduce([[]], fn (el, array) ->
      case el do
        "X" -> Enum.reduce(array, [], fn (array_1, acc) ->
          [["0" | array_1], ["1" | array_1] | acc]
        end)
        _ -> Enum.map(array, fn (array_1) -> [el | array_1] end)
      end
    end)
    |> Enum.map(fn (el) ->
      el
      |> Enum.reverse()
      |> Enum.join("")
      |> String.to_integer(2)
    end)
  end

  defp apply_address_mask({"0", a}), do: a
  defp apply_address_mask({m, _}), do: m

  defp sum_values(map) do
    Enum.reduce(map, 0, fn ({k, v}, acc) ->
      case k do
        "mask" -> acc
        _ -> acc + v
      end
    end)
  end

  defp masked_value(value, mask) do
    split_mask = mask |> String.split("") |> Enum.reject(fn (el) -> el == "" end)
    split_value = value
                  |> Integer.to_string(2)
                  |> String.split("")
                  |> Enum.reject(fn (el) -> el == "" end)
                  |> pad_zeros(Enum.count(split_mask))
    List.zip([split_mask, split_value])
    |> Enum.map(&apply_mask/1)
    |> Enum.join("")
    |> String.to_integer(2)
  end

  def apply_mask({"X", n}), do: n
  def apply_mask({m, _}), do: m

  defp pad_zeros(array, target_length) do
    current_length = Enum.count(array)
    current_length..(target_length - 1)
    |> Enum.reduce(array, fn (_, acc) -> ["0" | acc] end)
  end

  defp read_data() do
    File.read!("input.txt")
    |> String.split("\n")
    |> Enum.map(fn (string) ->
      [mem, value] = string |> String.split(" = ")
      case mem do
        "mask" -> {mem, value}
        _ ->
          [_, address] = mem |> String.split("[")
          {address |> String.replace("]", "") |> String.to_integer(), String.to_integer(value)}
      end
    end)
  end
end

Puzzle14.solve()
