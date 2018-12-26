defmodule Aoc.ThirdTest do
  use ExUnit.Case
  alias Aoc.Third, as: Subject
  @moduletag timeout: :infinity
  @input_path "lib/aoc/third/input"

  test "works" do
    assert 107_820 =
             @input_path
             |> File.stream!()
             |> Subject.a()
  end
end
