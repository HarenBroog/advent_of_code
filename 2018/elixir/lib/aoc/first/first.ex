defmodule Aoc.First do
  alias Aoc.First.Counter

  def a do
    Counter.input() |> Counter.frequencies() |> Counter.sum()
  end

  def b do
    Counter.input() |> Stream.cycle() |> Counter.frequencies() |> Counter.first_reached_twice()
  end
end

defmodule Aoc.First.Counter do
  @input_path "lib/aoc/first/input"

  def input do
    @input_path
    |> File.stream!()
  end

  def frequencies(stream) do
    stream
    |> Stream.map(&String.slice(&1, 0..-2))
    |> Stream.map(&String.to_integer/1)
  end

  def sum(stream) do
    stream
    |> Enum.sum()
  end

  def first_reached_twice(stream) do
    stream
    |> Stream.transform(%{sum: 0}, fn x, acc ->
      sum = acc.sum + x

      acc
      |> Map.put(:sum, sum)
      |> Map.update(sum, 1, &increment/1)
      |> case do
        %{halted: true} = acc ->
          {:halt, acc}

        %{^sum => occurences} when occurences >= 2 ->
          {[sum], acc |> Map.put(:halted, true)}

        acc ->
          {[x], acc}
      end
    end)
    |> Enum.take(-1)
    |> List.first()
  end

  defp increment(val) do
    val + 1
  end
end
