defmodule Aoc.Third.Claim do
  alias __MODULE__
  defstruct [:id, :width, :height, :top, :left, :squares]

  def squares(%Claim{left: left, width: width, top: top, height: height}) do
    for x <- left..(left + width - 1), y <- top..(top + height - 1) do
      {x, y}
    end
  end

  def with_squares(%Claim{} = claim) do
    %Claim{claim | squares: squares(claim)}
  end
end

defmodule Aoc.Third.Matrix do
  alias __MODULE__

  defstruct [:value]

  def new do
    %{}
  end

  def increment_at(map, {_x, _y} = key) do
    map
    |> Map.update(key, 1, &(&1 + 1))
  end
end

defmodule Aoc.Third do
  alias Aoc.Third.Claim
  alias Aoc.Third.Matrix

  def a(stream) do
    stream
    |> squares()
    |> Stream.flat_map(fn claim ->
      claim |> Claim.squares()
    end)
    |> Enum.reduce(%{}, fn key, acc ->
      acc
      |> Matrix.increment_at(key)
    end)
    |> Enum.to_list()
    |> Enum.filter(fn {_, x} -> x >= 2 end)
    |> length()
  end

  def b(stream) do
    potential_squares =
      stream
      |> squares()
      |> Stream.flat_map(fn claim ->
        claim |> Claim.squares()
      end)
      |> Enum.reduce(%{}, fn key, acc ->
        acc
        |> Matrix.increment_at(key)
      end)
      |> Enum.to_list()
      |> Enum.filter(fn {_, x} -> x == 1 end)
      |> Enum.map(fn {square, _y} -> square end)

    stream
    |> squares()
    |> Stream.map(&Claim.with_squares/1)
    |> Stream.filter(fn %Claim{squares: squares} ->
      squares |> Enum.all?(fn square -> square in potential_squares end)
    end)
    |> Enum.to_list()
    |> List.first()
  end

  def squares(stream) do
    stream
    |> Stream.map(&String.slice(&1, 0..-2))
    |> Stream.map(fn x ->
      [id, position, dimensions] =
        x
        |> String.split(" ")
        |> Enum.reject(&(&1 == "@"))

      [left, top] =
        position
        |> String.replace(",", " ")
        |> String.replace(":", " ")
        |> String.trim()
        |> String.split(" ")

      [width, height] = dimensions |> String.split("x")

      %Claim{
        id: id |> String.replace("#", ""),
        left: left |> String.to_integer(),
        top: top |> String.to_integer(),
        width: width |> String.to_integer(),
        height: height |> String.to_integer()
      }
    end)
  end
end
