import gleam/dict.{type Dict}
import gleam/list
import gleam/pair
import grid.{type Coords, type Grid}
import simplifile

pub fn part_one(file: String) -> Int {
  let assert Ok(input) = simplifile.read(file)
  let grid = grid.parse(input)
  let grid_size = grid.size(grid)

  grid.parse(input)
  |> grid.remove(".")
  |> group_by_node_value()
  |> dict.map_values(fn(_key, nodes) {
    nodes
    |> list.map(coords_from_node)
    |> list.permutations()
    |> list.flat_map(fn(perms) {
      list.combination_pairs(perms)
      |> list.map(move_to_antinode)
    })
  })
  |> dict.values
  |> list.flatten
  |> list.unique
  |> list.filter(within_grid(_, grid_size))
  |> list.length
}

pub fn part_two(file: String) -> Int {
  let assert Ok(input) = simplifile.read(file)
  let grid = grid.parse(input)
  let grid_size = grid.size(grid)

  grid.parse(input)
  |> grid.remove(".")
  |> group_by_node_value()
  |> dict.map_values(fn(_key, nodes) {
    nodes
    |> list.map(coords_from_node)
    |> list.permutations()
    |> list.flat_map(fn(perms) {
      list.combination_pairs(perms)
      |> list.flat_map(fn(pair) {
        do_move_to_antinodes(pair, [pair.0], grid_size)
      })
    })
  })
  |> dict.values
  |> list.flatten
  |> list.unique
  |> list.filter(within_grid(_, grid_size))
  |> list.length
}

fn group_by_node_value(grid: Grid(a)) -> Dict(a, List(#(Coords, a))) {
  grid
  |> dict.to_list
  |> list.group(by: fn(pair) {
    let #(_key, value) = pair
    value
  })
}

fn coords_from_node(grid_point: #(Coords, a)) -> Coords {
  pair.first(grid_point)
}

fn move_to_antinode(pair: #(Coords, Coords)) -> Coords {
  let #(first, second): #(Coords, Coords) = pair
  let translation = grid.translation(first, second)
  let antinode = grid.move(second, translation)
  antinode
}

fn do_move_to_antinodes(
  pair: #(Coords, Coords),
  antinodes: List(Coords),
  grid_size: #(Int, Int),
) -> List(Coords) {
  let #(first, second): #(Coords, Coords) = pair
  let translation = grid.translation(first, second)
  let antinode = grid.move(second, translation)

  case within_grid(antinode, grid_size) {
    False -> antinodes
    True ->
      do_move_to_antinodes(
        #(second, antinode),
        [antinode, ..antinodes],
        grid_size,
      )
  }
}

fn within_grid(coords: Coords, grid_size: #(Int, Int)) -> Bool {
  let #(max_x, max_y) = grid_size

  case coords {
    #(x, _) if x < 0 -> False
    #(x, _) if x > max_x -> False
    #(_, y) if y < 0 -> False
    #(_, y) if y > max_y -> False
    _ -> True
  }
}
