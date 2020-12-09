defmodule Puzzle8 do
  def solve() do
    read_data()
    |> parse_data()
    |> generate_variants()
    |> Enum.map(&process_instructions_until_duplicate/1)
  end

  defp generate_variants(data) do
    data
    |> Enum.reduce([], fn ({index, instruction, value}, acc) ->
      instruction
      |> case do
        "acc" -> acc
        "nop" -> [List.replace_at(data, index, {index, "jmp", value}) | acc]
        "jmp" -> [List.replace_at(data, index, {index, "nop", value}) | acc]
      end
    end)
  end

  defp process_instructions_until_duplicate(instructions, accumulator \\ 0, instruction_sequence \\ [0]) do
    stack_count = Enum.count(instruction_sequence)
    instruction_sequence
    |> Enum.uniq()
    |> Enum.count()
    |> case do
      x when x != stack_count ->
        Enum.at(instruction_sequence, 0)
        |> case do
          0 ->
            IO.inspect(instruction_sequence)
            IO.inspect(accumulator)
            accumulator
          _ -> nil
        end
      _ ->
        instructions_count = Enum.count(instructions)
        instruction_index = Enum.at(instruction_sequence, 0)
        instructions
        |> Enum.at(instruction_index)
        |> case do
          {_, "acc", value} ->
            process_instructions_until_duplicate(
              instructions,
              accumulator + value,
              [rem(instruction_index + 1, instructions_count) | instruction_sequence]
            )
          {_, "nop", _} ->
            process_instructions_until_duplicate(
              instructions,
              accumulator,
              [rem(instruction_index + 1, instructions_count) | instruction_sequence]
            )
          {_, "jmp", value} ->
            process_instructions_until_duplicate(
              instructions,
              accumulator,
              [rem(instruction_index + value, instructions_count) | instruction_sequence]
            )
        end
    end
  end

  defp parse_data(data) do
    data
    |> Enum.with_index()
    |> Enum.map(fn ({string, index}) ->
      [instruction, value] = String.split(string, " ")
      {index, instruction, String.to_integer(value)}
    end)
  end

  defp read_data() do
    File.read!("input.txt")
    |> String.split("\n")
  end
end

Puzzle8.solve()
