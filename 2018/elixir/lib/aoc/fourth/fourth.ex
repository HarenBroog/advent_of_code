defmodule Aoc.Fourth do
  def a(stream) do
    stream
    |> prepare()
  end

  def prepare(stream) do
    stream
    |> Stream.map(&String.slice(&1, 0..-2))
    |> Enum.sort()
    |> Enum.chunk_by(fn x ->
      String.contains?(x, "Guard")
    end)
    |> Enum.reduce({%{}, nil}, fn row, {acc, last_row} ->
      if length(row) == 1 do
        {acc
         |> Map.put_new(row, []), row}
      else
        {acc
         |> Map.update(last_row, [], fn x -> x ++ [row] end), last_row}
      end
    end)
    |> (fn {acc, _} -> acc end).()
    |> Enum.map(fn {k, events} ->
      {k, events |> List.flatten() |> Enum.map(&extract_minute/1)}
    end)
    |> Enum.map(fn {k, events} ->
      {k,
       events
       |> Enum.chunk_every(2)
       |> Enum.map(fn [start, stop] ->
         [start, stop - 1]
       end)}
    end)
    |> Enum.map(fn {k, events} ->
      {k |> List.first() |> extract_guard_id(), events}
    end)
    |> Enum.group_by(
      fn {k, _events} ->
        k
      end,
      fn {_k, events} -> events end
    )
    |> Enum.map(fn {k, pairs} ->
      {k, pairs |> List.flatten() |> Enum.chunk_every(2)}
    end)
    |> Enum.map(fn {k, pairs} ->
      {k,
       pairs
       |> Enum.map(fn [start, stop] ->
         stop - start
       end)
       |> Enum.sum()}
    end)
  end

  def most_sleepy_minute(pairs) do
    pairs
    |> Enum.map(fn [a, b] -> a..b end)
    |> Enum.map(&Enum.to_list/1)
    |> List.flatten()
    |> Enum.reduce(%{}, fn min, acc ->
      acc
      |> Map.update(min, 1, &(&1 + 1))
    end)
  end

  defp extract_guard_id(row) do
    row
    |> String.replace("begins shift", "")
    |> String.trim()
    |> String.split("#")
    |> Enum.at(1)
  end

  defp extract_minute(row) do
    row
    |> String.replace("falls asleep", "")
    |> String.replace("wakes up", "")
    |> String.trim()
    |> String.split(" ")
    |> Enum.at(1)
    |> String.replace("]", "")
    |> String.split(":")
    |> Enum.at(1)
    |> String.to_integer()
  end
end
