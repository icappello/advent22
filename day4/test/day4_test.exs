defmodule Day4Test do
  use ExUnit.Case
  doctest Day4

  describe "common" do
    test "extract the bounds of a section" do
      input = "12-44"

      {lower, upper} = Day4.section_bounds(input)

      assert lower == 12
      assert upper == 44
    end
  end

  describe "puzzle1" do
    test "check if a section is contained in another section" do
      pairings = [
        {{12, 44}, {13, 43}},
        {{13, 43}, {12, 44}},
        {{12, 44}, {13, 45}},
        {{13, 45}, {12, 44}},
        {{12, 44}, {12, 45}},
        {{12, 45}, {12, 44}},
        {{12, 44}, {5, 10}},
        {{5, 10}, {12, 44}},
        {{11, 44}, {12, 44}},
        {{12, 44}, {11, 44}},
        {{12, 44}, {12, 44}}
      ]

      results = pairings |> Enum.map(fn {s1, s2} -> s1 |> Day4.is_contained(s2) end)

      assert results == [
               false,
               true,
               false,
               false,
               true,
               false,
               false,
               false,
               false,
               true,
               true
             ]
    end

    test "check if one (any) section in a pairing is contained in the other section" do
      pairings = [
        {{12, 44}, {13, 43}},
        {{12, 44}, {13, 45}},
        {{12, 44}, {12, 45}},
        {{12, 44}, {5, 10}},
        {{11, 44}, {12, 44}},
        {{12, 44}, {12, 44}}
      ]

      results = pairings |> Enum.map(fn pairing -> Day4.check(pairing, :puzzle1) end)

      assert results == [true, false, true, false, true, true]
    end

    test "count instances of subsections" do
      pairings = [
        {{12, 44}, {13, 43}},
        {{12, 44}, {13, 45}},
        {{12, 44}, {12, 45}},
        {{12, 44}, {5, 10}},
        {{11, 44}, {12, 44}},
        {{12, 44}, {12, 44}}
      ]

      result = Day4.count(pairings, :puzzle1)

      assert result == 4
    end

    test "count instances on input string" do
      input =
        ["2-4,6-8", "2-3,4-5", "5-7,7-9", "2-8,3-7", "6-6,4-6", "2-6,4-8"] |> Enum.join("\n")

      result = Day4.count(input, :puzzle1)

      assert result == 2
    end
  end

  describe "puzzle2" do
    test "check if a section overlaps to another section" do
      pairings = [
        {{12, 44}, {13, 43}},
        {{13, 43}, {12, 44}},
        {{12, 44}, {13, 45}},
        {{13, 45}, {12, 44}},
        {{12, 44}, {12, 45}},
        {{12, 45}, {12, 44}},
        {{12, 44}, {5, 10}},
        {{5, 10}, {12, 44}},
        {{11, 44}, {12, 44}},
        {{12, 44}, {11, 44}},
        {{12, 44}, {12, 44}}
      ]

      results = pairings |> Enum.map(fn {s1, s2} -> s1 |> Day4.overlaps(s2) end)

      assert results == [
               true,
               true,
               true,
               true,
               true,
               true,
               false,
               false,
               true,
               true,
               true
             ]
    end

    test "check if one (any) section in a pairing overlaps to the other section" do
      pairings = [
        {{12, 44}, {13, 43}},
        {{12, 44}, {13, 45}},
        {{12, 44}, {12, 45}},
        {{12, 44}, {5, 10}},
        {{11, 44}, {12, 44}},
        {{12, 44}, {12, 44}}
      ]

      results = pairings |> Enum.map(fn pairing -> Day4.check(pairing, :puzzle2) end)

      assert results == [true, true, true, false, true, true]
    end

    test "count instances of overlapping paired sections" do
      pairings = [
        {{12, 44}, {13, 43}},
        {{12, 44}, {13, 45}},
        {{12, 44}, {12, 45}},
        {{12, 44}, {5, 10}},
        {{11, 44}, {12, 44}},
        {{12, 44}, {12, 44}}
      ]

      result = Day4.count(pairings, :puzzle2)

      assert result == 5
    end

    test "count instances on input string" do
      input =
        ["2-4,6-8", "2-3,4-5", "5-7,7-9", "2-8,3-7", "6-6,4-6", "2-6,4-8"] |> Enum.join("\n")

      result = Day4.count(input, :puzzle2)

      assert result == 4
    end
  end
end
