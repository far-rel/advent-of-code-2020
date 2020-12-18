defmodule Puzzle18 do
  def solve() do
    data = read_data()
    data
    |> Enum.map(fn (equation) ->
      equation
      |> build_tree({nil, nil, nil})
      |> evaluate()
    end)
    |> Enum.sum()
    |> IO.inspect()

    data
    |> Enum.map(fn (equation) ->
      group_parenthesis([], equation)
      |> build_advanced_tree()
      |> evaluate()
    end)
    |> Enum.sum()
    |> IO.inspect()
  end


  defp build_tree(["(" | tail], {left, op, nil}) do
    {tree, new_tail} = build_tree(tail, {nil, nil, nil})
    case left do
      nil -> build_tree(new_tail, {tree, nil, nil})
      _ -> build_tree(new_tail, {{left, op, tree}, nil, nil})
    end
  end
  defp build_tree([")" | tail], {left, nil, nil}), do: {left, tail}
  defp build_tree([s | tail], {nil, nil, nil}), do: build_tree(tail, {s, nil, nil})
  defp build_tree(["+" | tail], {left, nil, nil}), do: build_tree(tail, {left, "+", nil})
  defp build_tree(["*" | tail], {left, nil, nil}), do: build_tree(tail, {left, "*", nil})
  defp build_tree([], {left, nil, nil}), do: left
  defp build_tree([], {left, op, right}), do: {left, op, right}
  defp build_tree([s | tail], {left, op, nil}), do: build_tree(tail, {{left, op, s}, nil, nil})

  defp evaluate({left, "*", right}), do: evaluate(left) * evaluate(right)
  defp evaluate({left, "+", right}), do: evaluate(left) + evaluate(right)
  defp evaluate(value), do: String.to_integer(value)

  defp group_parenthesis(acc, ["(" | tail]) do
    {array, new_tail} = group_parenthesis([], tail)
    group_parenthesis(acc ++ [array], new_tail)
  end
  defp group_parenthesis(acc, [")" | tail]), do: {acc, tail}
  defp group_parenthesis(acc, []), do: acc
  defp group_parenthesis(acc, [head | tail]), do: group_parenthesis(acc ++ [head], tail)

  defp build_advanced_tree([a]), do: build_advanced_tree(a)
  defp build_advanced_tree(array) when is_list(array) do
    index = Enum.find_index(array, fn (el) -> el == "*" end)
    case index do
      nil ->
        index1 = Enum.find_index(array, fn (el) -> el == "+" end)
        left = Enum.slice(array, 0..(index1 - 1))
        right = Enum.slice(array, (index1 + 1)..(Enum.count(array)))
        {build_advanced_tree(left), "+", build_advanced_tree(right)}
      _ ->
        left = Enum.slice(array, 0..(index - 1))
        right = Enum.slice(array, (index + 1)..(Enum.count(array)))
        {build_advanced_tree(left), "*", build_advanced_tree(right)}
    end
  end
  defp build_advanced_tree(a), do: a

  defp read_data() do
    File.read!("input.txt")
    |> String.split("\n")
    |> Enum.map(fn (string) ->
      string
      |> String.split("")
      |> Enum.reject(fn (s) -> (s == "") || (s == " ") end)
    end)
  end
end

Puzzle18.solve()
