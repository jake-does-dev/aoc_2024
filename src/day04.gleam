import gleam/dict.{type Dict}
import gleam/io
import gleam/list
import gleam/string
import simplifile

type Coords =
  #(Int, Int)

type Grid(a) =
  Dict(Coords, a)

pub fn part_one(file: String) -> Int {
  let assert Ok(input) = simplifile.read(file)

  let grid = parse_grid(input)

  let windows =
    list.range(0, 9)
    |> list.window(4)
    |> list.append(
      list.range(9, 0)
      |> list.window(4),
    )

  list.range(0, 9)
  |> list.map(fn(i) {
    windows
    |> list.map(fn(window) {
      let assert Ok(#(i0, remainder)) = list.pop(window, fn(_) { True })
      let assert Ok(#(i1, remainder)) = list.pop(remainder, fn(_) { True })
      let assert Ok(#(i2, remainder)) = list.pop(remainder, fn(_) { True })
      let assert Ok(#(i3, _remainder)) = list.pop(remainder, fn(_) { True })

      let assert Ok(first) = dict.get(grid, #(i, i0))
      let assert Ok(second) = dict.get(grid, #(i, i1))
      let assert Ok(third) = dict.get(grid, #(i, i2))
      let assert Ok(fourth) = dict.get(grid, #(i, i3))

      case #(first, second, third, fourth) {
        #("X", "M", "A", "S") -> todo
        #("S", "A", "M", "X") -> todo
        _ -> todo
      }

      todo
    })
  })

  io.debug(windows)

  todo
}

pub fn part_two(file: String) -> Int {
  todo
}

fn parse_grid(input: String) -> Grid(String) {
  input
  |> string.split(on: "\n")
  |> list.index_map(fn(row, x) {
    row
    |> string.split(on: "")
    |> list.index_map(fn(char, y) { #(#(x, y), char) })
  })
  |> list.flatten
  |> dict.from_list
}
