defmodule Puzzle2 do
  @opponent_moves %{
    "A" => :rock,
    "B" => :paper,
    "C" => :scissors
  }

  @outcomes %{
    "X" => :lose,
    "Y" => :draw,
    "Z" => :win
  }

  @shape_scores %{
    rock: 1,
    paper: 2,
    scissors: 3
  }

  @loss_score 0
  @draw_score 3
  @win_score 6

  @my_rules %{
    rock: %{win: :paper, lose: :scissors, draw: :rock},
    paper: %{win: :scissors, lose: :rock, draw: :paper},
    scissors: %{win: :rock, lose: :paper, draw: :scissors}
  }

  def compute_score(outcome, my_move) do
    my_move_score = @shape_scores[my_move]

    case outcome do
      :win -> @win_score + my_move_score
      :draw -> @draw_score + my_move_score
      :lose -> @loss_score + my_move_score
    end
  end

  def compute(contents) do
    contents
    |> String.split("\n")
    |> Enum.map(fn line -> Regex.run(~r/(.) (.)/, line) end)
    |> Enum.reduce(0, fn
      nil, acc ->
        acc

      [_, opponent, required_outcome], acc ->
        opponent_move = @opponent_moves[opponent]
        outcome = @outcomes |> Map.get(required_outcome)
        my_move = @my_rules |> Map.get(opponent_move, %{}) |> Map.get(outcome)
        acc + compute_score(outcome, my_move)
    end)
  end

  def launch(path) do
    File.read!(path) |> compute
  end
end
