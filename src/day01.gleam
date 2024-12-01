import gleam/int
import gleam/list
import gleam/pair
import gleam/result
import gleam/string
import simplifile

pub fn part_one(file: String) -> Result(Int, Nil) {
  let assert Ok(contents) = simplifile.read(file)
  let #(first, second) = extract_lists(contents)

  list.zip(first, second)
  |> list.map(fn(p) { pair.second(p) - pair.first(p) })
  |> list.map(fn(n) { int.absolute_value(n) })
  |> list.reduce(int.add)
}

pub fn part_two(file: String) -> Result(Int, Nil) {
  let assert Ok(contents) = simplifile.read(file)
  let #(first, second) = extract_lists(contents)

  first
  |> list.map(fn(first_number) {
    second
    |> list.count(fn(second_number) { second_number == first_number })
    |> int.multiply(first_number)

    first_number
    * list.count(second, fn(second_number) { second_number == first_number })
  })
  |> list.reduce(int.add)
}

fn extract_lists(contents: String) -> #(List(Int), List(Int)) {
  let pairs =
    contents
    |> string.split("\n")
    |> list.map(fn(s) { pair(s) })

  let first =
    pairs
    |> list.map(fn(p) { pair.first(p) })
    |> list.sort(by: int.compare)

  let second =
    pairs
    |> list.map(fn(p) { pair.second(p) })
    |> list.sort(by: int.compare)

  #(first, second)
}

fn pair(string_pair: String) -> #(Int, Int) {
  string.split(string_pair, "   ")
  |> list.map(fn(x) { int.parse(x) })
  |> result.values()
  |> fn(list) {
    #(list.first(list) |> result.unwrap(0), list.last(list) |> result.unwrap(0))
  }
}
