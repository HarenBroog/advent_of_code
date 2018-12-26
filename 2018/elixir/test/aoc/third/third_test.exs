defmodule Aoc.ThirdTest do
  use ExUnit.Case
  alias Aoc.Third, as: Subject
  @moduletag timeout: :infinity
  @input_path "lib/aoc/third/input"

  describe "a/0" do
    test "works" do
      assert 107_820 =
               @input_path
               |> File.stream!()
               |> Subject.a()
    end
  end

  describe "b/0" do
    test "works" do
      assert "661" =
               @input_path
               |> File.stream!()
               |> Subject.b()
    end
  end
end
