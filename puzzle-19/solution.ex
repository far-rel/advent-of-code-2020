defmodule Puzzle19 do
  def solve() do
    {rules, messages} = read_data()
    regex_string = generate_regex(rules, 0) |> IO.inspect()
    {:ok, regex} = Regex.compile("^#{regex_string}$")
    messages
    |> Enum.filter(fn (message) -> Regex.match?(regex, message) end)
    |> Enum.count()
    |> IO.inspect()
  end

  defp generate_regex(rules, 11) do
    tmp_42 = generate_regex(rules, 42)
    tmp_31 = generate_regex(rules, 31)
    IO.inspect(generate_regex(rules, 42))
    string = 1..5
    |> Enum.map(fn (i) ->
      "#{String.duplicate(tmp_42, i)}#{String.duplicate(tmp_31, i)}"
    end)
    |> Enum.join("|")
    "(#{string})"
  end
  defp generate_regex(rules, 8) do
    "#{generate_regex(rules, 42)}+"
  end
  defp generate_regex(rules, rule_index) do
    Map.get(rules, rule_index)
    |> case do
      rule when is_list(rule) ->
        tmp = rule
        |> Enum.map(fn (rule_indexes) ->
          Enum.map(rule_indexes, fn (new_rule_index) ->
            generate_regex(rules, new_rule_index)
          end)
          |> Enum.join("")
        end)
        tmp
        |> Enum.count()
        |> case do
          1 -> Enum.at(tmp, 0)
          _ -> "(#{Enum.join(tmp, "|")})"
        end
      string -> string
    end
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
