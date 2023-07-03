import gleam/io
import gleam/int
import gleam/option.{None, Option, Some}
import gleam/list
import gleam/string
import simplifile

pub type Outcome {
  Win
  Lose
  Draw
}

pub type RPS {
  Rock
  Paper
  Scissors
}

// Part 2 Instruction to win, lose or draw
fn expected_outcome(my_play: String) -> Outcome {
  case my_play {
    "X" -> Lose
    "Y" -> Draw
    _ -> Win
  }
}

// Opponents choice code to RPS Game
fn opponents_choice(op_play: String) -> RPS {
  case op_play {
    "A" -> Rock
    "B" -> Paper
    _ -> Scissors
  }
}

// Calculate the point for each choice
fn part2_choice_point(rps: RPS) -> Int {
  case rps {
    Rock -> 1
    Paper -> 2
    Scissors -> 3
  }
}

// Calculate the total score for the round, taking into account the point for each choice and 
// points based on the lose,win or draw
fn part2_round_point(round: #(String, String)) -> Int {
  let planned_outcome = expected_outcome(round.1)
  case planned_outcome {
    Lose ->
      case opponents_choice(round.0) {
        Rock -> part2_choice_point(Scissors)
        Paper -> part2_choice_point(Rock)
        Scissors -> part2_choice_point(Paper)
      }
    Draw ->
      case opponents_choice(round.0) {
        Rock ->
          part2_choice_point(Rock)
          |> int.add(3)
        Paper ->
          part2_choice_point(Paper)
          |> int.add(3)
        Scissors ->
          part2_choice_point(Scissors)
          |> int.add(3)
      }
    Win ->
      case opponents_choice(round.0) {
        Rock ->
          part2_choice_point(Paper)
          |> int.add(6)
        Paper ->
          part2_choice_point(Scissors)
          |> int.add(6)
        Scissors ->
          part2_choice_point(Rock)
          |> int.add(6)
      }
  }
}

pub fn main() {
  let assert Ok(input) = simplifile.read("./asset/input.txt")

  let tuples =
    input
    |> string.split("\n")
    |> list.map(line_to_tuple)
    |> option.values()

  // Part one
  tuples
  |> list.map(round_point)
  |> list.fold(0, int.add)
  |> int.to_string()
  |> io.println

  // Part 2
  tuples
  |> list.map(part2_round_point)
  |> list.fold(0, int.add)
  |> int.to_string()
  |> io.println
}

// Convert round string to tuple
fn line_to_tuple(line: String) -> Option(#(String, String)) {
  case string.split(line, " ") {
    [h, t] -> Some(#(h, t))
    _ -> None
  }
}

// Convert round choice to point
fn choice_point(choice: String) -> Int {
  case choice {
    "X" -> 1
    "Y" -> 2
    _ -> 3
  }
}

//Part1 Get the expected outcome based on the round
fn get_outcome(round: #(String, String)) -> Option(Outcome) {
  case round {
    #("A", "X") -> Some(Draw)
    #("A", "Y") -> Some(Win)
    #("A", "Z") -> Some(Lose)
    #("B", "X") -> Some(Lose)
    #("B", "Y") -> Some(Draw)
    #("B", "Z") -> Some(Win)
    #("C", "X") -> Some(Win)
    #("C", "Y") -> Some(Lose)
    #("C", "Z") -> Some(Draw)
    #(_, _) -> None
  }
}

// Points based on the expected outcome
fn choice_score(result: Outcome) -> Int {
  case result {
    Win -> 6
    Draw -> 3
    Lose -> 0
  }
}

// Calculate the total points for the round - Part 1
fn round_point(round: #(String, String)) -> Int {
  let my_score =
    get_outcome(round)
    |> option.map(choice_score)
    |> option.unwrap(0)
  my_score + choice_point(round.1)
}
