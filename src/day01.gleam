import gleam/int
import gleam/list
import gleam/result
import utils

pub fn part_one(file: String) -> Result(Int, Nil) {
  let contents = utils.list_of_lists(file, "\n", "   ")
  let #(first, second) = extract_pair(contents)

  list.zip(first, second)
  |> list.map(fn(p) { int.absolute_value(p.1 - p.0) })
  |> list.reduce(int.add)
}

pub fn part_two(file: String) -> Result(Int, Nil) {
  let contents = utils.list_of_lists(file, "\n", "   ")
  let #(first, second) = extract_pair(contents)

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

fn extract_pair(contents: List(List(Int))) -> #(List(Int), List(Int)) {
  let transposed = list.transpose(contents)

  let first =
    list.first(transposed) |> result.unwrap([]) |> list.sort(by: int.compare)
  let second =
    list.last(transposed) |> result.unwrap([]) |> list.sort(by: int.compare)

  #(first, second)
}
