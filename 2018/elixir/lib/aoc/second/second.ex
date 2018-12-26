defmodule Aoc.Second do
  alias Aoc.Second.Counter

  def a do
    Counter.input() |> Counter.rows() |> Counter.checksum()
  end

  def b do
    Counter.input() |> Counter.rows() |> Counter.letters()
  end
end

defmodule Aoc.Second.Counter do
  use Bitwise
  @input_path "lib/aoc/second/input"

  def input do
    @input_path
    |> File.stream!()
  end

  def rows(stream) do
    stream
    |> Stream.map(&String.slice(&1, 0..-2))
    |> Stream.map(&String.to_charlist/1)
  end

  def checksum(stream) do
    stream
    |> Stream.transform(%{3 => 0, 2 => 0}, fn x, acc ->
      result =
        x
        |> Enum.reduce(%{}, fn char, acc ->
          acc
          |> Map.update(char, 1, &increment/1)
        end)
        |> Enum.into(%{}, fn {k, v} -> {v, k} end)

      update_counter = fn map, key ->
        map
        |> Map.update(key, 0, fn x -> if Map.has_key?(result, key), do: x + 1, else: x end)
      end

      acc =
        acc
        |> update_counter.(3)
        |> update_counter.(2)

      {[acc], acc}
    end)
    |> Enum.take(-1)
    |> List.first()
    |> Map.values()
    |> Enum.reduce(1, &Kernel.*/2)
  end

  def letters(stream) do
    ids =
      stream
      |> Stream.filter(fn x ->
        x
        |> Enum.reduce(%{}, fn char, acc ->
          acc
          |> Map.update(char, 1, &increment/1)
        end)
        |> Map.values()
        |> valid_id?()
      end)
      |> Enum.to_list()

    for x <- ids, y <- ids, x != y do
      {{x, y}, hamming(x, y)}
    end
    |> Enum.filter(fn {_, difference} -> difference == 1 end)
  end

  defp valid_id?(chars) do
    Enum.count(chars, &(&1 == 2)) >= 2 or Enum.count(chars, &(&1 == 3)) >= 2 or
      (Enum.count(chars, &(&1 == 2)) >= 1 and Enum.count(chars, &(&1 == 3)) >= 1)
  end

  defp increment(val) do
    val + 1
  end

  defp hamming(s1, s2, acc \\ 0)
  defp hamming([h1 | t1], [h1 | t2], acc), do: hamming(t1, t2, acc)
  defp hamming([_h1 | t1], [_h2 | t2], acc), do: hamming(t1, t2, acc + 1)
  defp hamming(_, _, acc), do: acc
end
