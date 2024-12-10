import gleam/dict.{type Dict}
import gleam/int
import gleam/list
import gleam/string

pub type Coords =
  #(Int, Int)

pub type Grid(a) =
  Dict(Coords, a)

pub fn parse(input: String) -> Grid(String) {
  input
  |> string.split(on: "\n")
  |> list.index_map(fn(row, y) {
    row
    |> string.split(on: "")
    |> list.index_map(fn(char, x) { #(#(x, y), char) })
  })
  |> list.flatten
  |> dict.from_list
}

pub fn size(grid: Grid(a)) -> Coords {
  #(max(grid, fn(coords) { coords.0 }), max(grid, fn(coords) { coords.1 }))
}

fn max(grid: Grid(a), coord_map: fn(Coords) -> Int) {
  let assert Ok(max) =
    grid
    |> dict.keys()
    |> list.map(coord_map)
    |> list.unique
    |> list.sort(by: int.compare)
    |> list.reverse
    |> list.first

  max
}
