defmodule Aoc.FourthTest do
  use ExUnit.Case
  alias Aoc.Fourth, as: Subject
  @moduletag timeout: :infinity

  @input_path "lib/aoc/fourth/input"

  describe "a/0" do
    test "works" do
      assert @input_path
             |> File.stream!()
             |> Subject.a()
    end
  end
end
