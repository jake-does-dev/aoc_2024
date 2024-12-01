import gleam/int
import gleam/list
import gleam/result
import gleam/string
import simplifile

pub fn part_one(file: String) -> Result(Int, Nil) {
  let assert Ok(contents) = simplifile.read(file)

  let #(first, second) = extract_lists(contents)

  list.zip(first, second)
  |> list.map(fn(p) { int.absolute_value(p.1 - p.0) })
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
  let transposed =
    contents
    |> string.split(on: "\n")
    |> list.map(fn(str) { string.split(str, on: "   ") })
    |> list.map(fn(str_list) {
      list.map(str_list, fn(str) { int.parse(str) |> result.unwrap(0) })
    })
    |> list.transpose()

  let first =
    list.first(transposed) |> result.unwrap([]) |> list.sort(by: int.compare)
  let second =
    list.last(transposed) |> result.unwrap([]) |> list.sort(by: int.compare)

  #(first, second)
}
