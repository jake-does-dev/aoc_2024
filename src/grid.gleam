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

pub fn remove(grid: Grid(a), value: a) -> Grid(a) {
  grid
  |> dict.to_list
  |> list.filter(fn(pair) {
    let #(_key, grid_value) = pair
    grid_value != value
  })
  |> dict.from_list
}

pub fn size(grid: Grid(a)) -> Coords {
  #(max(grid, fn(coords) { coords.0 }), max(grid, fn(coords) { coords.1 }))
}

pub fn translation(a: Coords, b: Coords) -> Coords {
  #(b.0 - a.0, b.1 - a.1)
}

pub fn move(coords: Coords, vector: Coords) -> Coords {
  #(coords.0 + vector.0, coords.1 + vector.1)
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
