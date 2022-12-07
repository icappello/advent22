defmodule Day7Test do
  use ExUnit.Case
  doctest Day7

  @test_input_1 [
                  "$ cd /",
                  "$ ls",
                  "dir a",
                  "14848514 b.txt",
                  "8504156 c.dat",
                  "dir d",
                  "$ cd a",
                  "$ ls",
                  "dir e",
                  "29116 f",
                  "2557 g",
                  "62596 h.lst",
                  "$ cd e",
                  "$ ls",
                  "584 i",
                  "$ cd ..",
                  "$ cd ..",
                  "$ cd d",
                  "$ ls",
                  "4060174 j",
                  "8033020 d.log",
                  "5626152 d.ext",
                  "7214296 k"
                ]
                |> Enum.join("\n")

  @test_input_2 [
                  "$ cd /",
                  "$ ls",
                  "dir a",
                  "14848514 b.txt",
                  "8504156 c.dat",
                  "dir d",
                  "$ cd a",
                  "$ ls",
                  "dir e",
                  "dir a",
                  "29116 f",
                  "2557 g",
                  "62596 h.lst",
                  "$ cd e",
                  "$ ls",
                  "584 i",
                  "$ cd ..",
                  "$ cd a",
                  "$ ls",
                  "15000 in.a",
                  "$ cd ..",
                  "$ cd ..",
                  "$ cd d",
                  "$ ls",
                  "4060174 j",
                  "8033020 d.log",
                  "5626152 d.ext",
                  "7214296 k",
                  "16000 in.a"
                ]
                |> Enum.join("\n")

  describe "common" do
    test "parse command" do
      inputs = ["$ ls", "$ cd abc", "$ cd ..", "$ cd /"]

      results = inputs |> Enum.map(fn input -> Day7.parse_command(input) end)

      assert results == [{:cmd, :list}, {:cmd, :subdir, "abc"}, {:cmd, :parent}, {:cmd, :root}]
    end

    test "parse response" do
      inputs = ["dir zabcv", "998 abc", "4 agc.dot", "72 k"]

      results = inputs |> Enum.map(fn input -> Day7.parse_output(input) end)

      assert results == [
               {:result, :dir, "zabcv"},
               {:result, :file, "abc", 998},
               {:result, :file, "agc.dot", 4},
               {:result, :file, "k", 72}
             ]
    end

    test "input to structs" do
      result = Day7.input_to_structs(@test_input_1)

      assert result == [
               {:cmd, :root},
               {:cmd, :list},
               {:result, :dir, "a"},
               {:result, :file, "b.txt", 14_848_514},
               {:result, :file, "c.dat", 8_504_156},
               {:result, :dir, "d"},
               {:cmd, :subdir, "a"},
               {:cmd, :list},
               {:result, :dir, "e"},
               {:result, :file, "f", 29116},
               {:result, :file, "g", 2557},
               {:result, :file, "h.lst", 62596},
               {:cmd, :subdir, "e"},
               {:cmd, :list},
               {:result, :file, "i", 584},
               {:cmd, :parent},
               {:cmd, :parent},
               {:cmd, :subdir, "d"},
               {:cmd, :list},
               {:result, :file, "j", 4_060_174},
               {:result, :file, "d.log", 8_033_020},
               {:result, :file, "d.ext", 5_626_152},
               {:result, :file, "k", 7_214_296}
             ]
    end

    test "parse empty dir" do
      assert Day7.parse("") == %{"/" => %{}}
    end

    test "parse input to tree" do
      result = Day7.parse(@test_input_1)

      assert result == %{
               "/" => %{
                 "a" => %{"f" => 29116, "g" => 2557, "h.lst" => 62596, "e" => %{"i" => 584}},
                 "b.txt" => 14_848_514,
                 "c.dat" => 8_504_156,
                 "d" => %{
                   "j" => 4_060_174,
                   "d.log" => 8_033_020,
                   "d.ext" => 5_626_152,
                   "k" => 7_214_296
                 }
               }
             }
    end

    test "parse input with duplicates to tree" do
      result = Day7.parse(@test_input_2)

      assert result == %{
               "/" => %{
                 "a" => %{
                   "f" => 29116,
                   "g" => 2557,
                   "h.lst" => 62596,
                   "e" => %{"i" => 584},
                   "a" => %{"in.a" => 15000}
                 },
                 "b.txt" => 14_848_514,
                 "c.dat" => 8_504_156,
                 "d" => %{
                   "j" => 4_060_174,
                   "d.log" => 8_033_020,
                   "d.ext" => 5_626_152,
                   "k" => 7_214_296,
                   "in.a" => 16000
                 }
               }
             }
    end

    test "compute sizes on empty dir" do
      assert Day7.get_sizes("") == [0]
    end

    test "compute sizes" do
      assert Day7.get_sizes(@test_input_1) == [584, 94853, 24_933_642, 48_381_165]
    end

    test "compute sizes with duplicate entries" do
      assert Day7.get_sizes(@test_input_2) == [584, 15000, 109_853, 24_949_642, 48_412_165]
    end
  end

  describe "puzzle1" do
    test "filter sizes" do
      assert Day7.filter_sizes(@test_input_1, :puzzle1) == [94853, 584] |> Enum.sort()
    end

    test "compute result" do
      assert Day7.launch(@test_input_1, :puzzle1) == 95437
    end
  end

  describe "puzzle2" do
    test "filter sizes" do
      assert Day7.filter_sizes(@test_input_1, :puzzle2) == [24_933_642, 48_381_165] |> Enum.sort()
    end

    test "compute result" do
      assert Day7.launch(@test_input_1, :puzzle2) == 24_933_642
    end
  end
end
