defmodule Day11.Monkey do
  defstruct index: -1,
            items: [],
            operation: "",
            divisible_by: 1,
            test_true: nil,
            test_false: nil,
            handled: 0
end
