import gleam/io
import gleam/int
import gleam/list
import gleam/string
import simplifile

pub fn main() {
  let assert Ok(input) = simplifile.read("./asset/input.txt")

  input
  |> string.split("\n\n")
  |> list.map(fn(xs) { string.split(xs, "\n") })
  |> list.map(fn(xs) {
    xs
    |> list.fold(0, fn(acc, x) { acc + convert_to_int(x) })
  })
  // |> list.fold(0, int.max)
  |> list.sort(int.compare)
  |> list.reverse
  |> list.take(3)
  |> int.sum
  |> io.debug
}

fn convert_to_int(number: String) -> Int {
  let assert Ok(number_int) = int.parse(number)
  number_int
}
