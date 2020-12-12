defmodule Puzzle12 do
  def solve() do
    {n, e, _wn, _we} = read_data()
    |> Enum.reduce({0, 0, 1, 10}, fn ({action, value}, {north, east, waypoint_north, waypoint_east}) ->
      IO.inspect({action, value})
      action
      |> case do
        "R" ->
          {n, e} = rotate({waypoint_north, waypoint_east}, 360 - value)
          {north, east, n, e}
        "L" ->
          {n, e} = rotate({waypoint_north, waypoint_east}, value)
          {north, east, n, e}
        "F" -> {north + value * waypoint_north, east + value * waypoint_east, waypoint_north, waypoint_east}
        "N" -> {north, east, waypoint_north + value, waypoint_east}
        "E" -> {north, east, waypoint_north, waypoint_east + value}
        "S" -> {north, east, waypoint_north - value, waypoint_east}
        "W" -> {north, east, waypoint_north, waypoint_east - value}
      end
      |> IO.inspect()
    end)
    (abs(n) + abs(e))
    |> IO.inspect()
  end

  defp rotate({north, east}, 90), do: {east, -north}
  defp rotate(position, value), do: position |> rotate(90) |> rotate(value - 90)

  defp read_data() do
    File.read!("input.txt")
    |> String.split("\n")
    |> Enum.map(fn (string) ->
      [action | tail] = string
      |> String.split("")
      |> Enum.reject(fn (el) -> el == "" end)
      {action, String.to_integer(Enum.join(tail, ""))}
    end)
  end
end

Puzzle12.solve()
