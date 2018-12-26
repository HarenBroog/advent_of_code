defmodule Aoc.Second do
  alias Aoc.Second.Counter

  def a do
    Counter.input() |> Counter.rows() |> Counter.checksum()
  end
end

defmodule Aoc.Second.Counter do
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

  defp increment(val) do
    val + 1
  end
end
