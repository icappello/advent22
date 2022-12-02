defmodule Puzzle1 do
  @opponent_moves %{
    "A" => :rock,
    "B" => :paper,
    "C" => :scissors
  }

  @my_moves %{
    "X" => :rock,
    "Y" => :paper,
    "Z" => :scissors
  }

  @shape_scores %{
    rock: 1,
    paper: 2,
    scissors: 3
  }

  @loss_score 0
  @draw_score 3
  @win_score 6

  @my_winning_rules %{
    rock: :paper,
    paper: :scissors,
    scissors: :rock
  }

  def compute_score(opponent_move, my_move) do
    my_move_score = @shape_scores[my_move]

    cond do
      opponent_move == my_move -> @draw_score + my_move_score
      my_move == @my_winning_rules[opponent_move] -> @win_score + my_move_score
      true -> @loss_score + my_move_score
    end
  end

  def compute(contents) do
    contents
    |> String.split("\n")
    |> Enum.map(fn line -> Regex.run(~r/(.) (.)/, line) end)
    |> Enum.reduce(0, fn
      nil, acc ->
        acc

      [_, o, m], acc ->
        opponent_move = @opponent_moves[o]
        my_move = @my_moves[m]
        acc + compute_score(opponent_move, my_move)
    end)
  end

  def launch(path) do
    File.read!(path) |> compute
  end
end
