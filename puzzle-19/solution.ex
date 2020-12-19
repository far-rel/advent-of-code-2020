defmodule Puzzle19 do
  def solve() do
    {rules, messages} = read_data()
    IO.inspect("Generating valid messages")
    valid_messages = generate_valid_messages(rules, 0) |> Enum.uniq()

    messages
    |> Enum.filter(fn (message) ->
      IO.inspect("Checking: #{message}")
      Enum.any?(valid_messages, fn (valid_message) ->
        {:ok, regex} = Regex.compile("$#{valid_message}^")
        Regex.match?(regex, message)
      end)
    end)
    |> Enum.count()
    |> IO.inspect()
  end

  defp generate_valid_messages(rules, 11) do
    tmp_42 = generate_valid_messages(rules, 42) |> Enum.map(fn (message) -> "(#{message})+" end)
    tmp_31 = generate_valid_messages(rules, 31) |> Enum.map(fn (message) -> "(#{message})+" end)
    combine(tmp_42, tmp_31)
  end
  defp generate_valid_messages(rules, 8) do
    generate_valid_messages(rules, 42)
    |> Enum.map(fn (message) -> "(#{message})+" end)
  end
  defp generate_valid_messages(rules, rule_index) do
    Map.get(rules, rule_index)
    |> case do
      rule when is_list(rule) ->
        rule
        |> Enum.map(fn (rule_indexes) ->
          Enum.map(rule_indexes, fn (new_rule_index) ->
            generate_valid_messages(rules, new_rule_index)
          end)
          |> Enum.reduce([""], fn (valid_messages, acc) ->
            Enum.map(acc, fn (acc1) ->
              Enum.map(valid_messages, fn (valid_message) ->
                acc1 <> valid_message
              end)
            end)
            |> List.flatten()
          end)
        end)
        |> List.flatten()
        |> Enum.uniq()
      string -> [string]
    end
  end

  defp combine(array1, array2) do
    Enum.reduce(array1, [], fn (el, acc) ->
      acc ++ Enum.map(array2, fn (el2) -> el <> el2 end)
    end)
  end

  defp read_data() do
    [rules, messages] = File.read!("input.txt")
    |> String.split("\n\n")
    {
      parse_rules(rules),
      String.split(messages, "\n")
    }
  end

  defp parse_rules(rules) do
    rules
    |> String.split("\n")
    |> Enum.reduce(%{}, fn (line, acc) ->
      [key, values] = String.split(line, ": ")
      case values do
        "\"a\"" -> Map.put(acc, String.to_integer(key), "a")
        "\"b\"" -> Map.put(acc, String.to_integer(key), "b")
        _ ->
          new_values = values
          |> String.split(" | ")
          |> Enum.map(fn (string) ->
            string
            |> String.split(" ")
            |> Enum.map(&String.to_integer/1)
          end)
          Map.put(acc, String.to_integer(key), new_values)
      end
    end)
  end
end

Puzzle19.solve()
