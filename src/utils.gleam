import gleam/int
import gleam/list
import gleam/result
import gleam/string
import simplifile

pub fn list_of_lists(
  file: String,
  new_line_separator: String,
  line_separator: String,
) -> List(List(Int)) {
  let assert Ok(contents) = simplifile.read(file)

  let reports =
    contents
    |> string.split(on: new_line_separator)
    |> list.map(fn(numbers_str) {
      numbers_str
      |> string.split(on: line_separator)
      |> list.map(fn(str) { int.parse(str) |> result.unwrap(0) })
    })
}
