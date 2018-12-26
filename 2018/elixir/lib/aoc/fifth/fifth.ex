defmodule Aoc.Fifth do
  @input_path "lib/aoc/fifth/input"

  def a(string \\ File.read!(@input_path) |> String.slice(0..-2)) do
    string
    |> reduce()
    |> String.length()
  end

  def b(string \\ File.read!(@input_path) |> String.slice(0..-2)) do
    units = string |> reduce() |> String.downcase() |> String.graphemes() |> Enum.uniq()

    units
    |> Enum.map(fn u ->
      {u,
       string
       |> String.replace(u, "")
       |> String.replace(u |> String.upcase(), "")
       |> reduce()
       |> String.length()}
    end)
  end

  def reduce(string), do: reduce(string |> String.graphemes(), [])
  def reduce([h_l | t_l], []), do: reduce(t_l, [h_l])
  def reduce([], processed), do: processed |> List.to_string()

  def reduce([h_l | t_l], [h_r | t_r] = r) do
    if reacts?(h_l, h_r) do
      reduce(t_l, t_r)
    else
      reduce(t_l, [h_l | r])
    end
  end

  def reacts?(a, b) when a != b do
    String.downcase(a) == String.downcase(b)
  end

  def reacts?(_, _), do: false
end
