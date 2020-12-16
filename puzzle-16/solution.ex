defmodule Puzzle16 do
  def solve() do
    {requirements, my_ticket, other_tickets} = read_data()
    other_tickets
    |> List.flatten()
    |> Enum.reduce(0, fn (value, acc) ->
      Enum.any?(requirements, fn ({_, range_1, range_2}) ->
        (Enum.member?(range_1, value) || Enum.member?(range_2, value))
      end)
      |> case do
        true -> acc
        false -> acc + value
      end
    end)
    |> IO.inspect()

    valid_tickets = other_tickets
    |> Enum.filter(fn (ticket) ->
      Enum.all?(ticket, fn (value) ->
        Enum.any?(requirements, fn ({_, range_1, range_2}) ->
          (Enum.member?(range_1, value) || Enum.member?(range_2, value))
        end)
      end)
    end)

    ticket_size = Enum.count(my_ticket)
    requirements
    |> Enum.map(fn ({name, range_1, range_2}) ->
      indexes = (0..(ticket_size - 1))
      |> Enum.filter(fn (i) ->
        Enum.all?(valid_tickets, fn (ticket_1) ->
          value = Enum.at(ticket_1, i)
          (Enum.member?(range_1, value) || Enum.member?(range_2, value))
        end)
      end)
      {name, range_1, range_2, indexes}
    end)
    |> remove_unique()
    |> Enum.reduce(1, fn ({name, _r1, _r2, [index]}, acc) ->
      String.starts_with?(name, "departure")
      |> case do
        true -> Enum.at(my_ticket, index) * acc
        false -> acc
      end
    end)
    |> IO.inspect()
  end

  defp remove_unique(requirements) do
    uniques = requirements
    |> Enum.map(fn {_n, _r1, _r2, indexes} -> indexes end)
    |> Enum.filter(fn (indexes) -> Enum.count(indexes) == 1 end)
    |> List.flatten()
    new_requirements = requirements
    |> Enum.map(fn {name, range_1, range_2, indexes} ->
      Enum.count(indexes)
      |> case do
        1 -> {name, range_1, range_2, indexes}
        _ ->
          new_indexes = Enum.filter(indexes, fn (idx) -> !Enum.member?(uniques, idx) end)
          {name, range_1, range_2, new_indexes}
      end
    end)
    (Enum.count(uniques) == Enum.count(new_requirements))
    |> case do
      true -> new_requirements
      false -> remove_unique(new_requirements)
    end
  end

  defp read_data() do
    [requirements, my_ticket, other_tickets] = File.read!("input.txt")
    |> String.split("\n\n")
    {
      parse_requirements(requirements),
      parse_my_ticket(my_ticket),
      parse_nearby_tickets(other_tickets)
    }
  end

  defp parse_requirements(requirements) do
    requirements
    |> String.split("\n")
    |> Enum.map(fn (string) ->
      [name, ranges] = string
      |> String.split(": ")
      [r1, r2, r3, r4] = ranges
      |> String.split([" or ", "-"])
      |> Enum.map(&String.to_integer/1)
      {name, r1..r2, r3..r4}
    end)
  end

  defp parse_my_ticket(my_ticket) do
    my_ticket
    |> String.replace("your ticket:\n", "")
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end

  defp parse_nearby_tickets(other_tickets) do
    other_tickets
    |> String.replace("nearby tickets:\n", "")
    |> String.split("\n")
    |> Enum.map(fn (string) ->
      string
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)
    end)
  end
end

Puzzle16.solve()
