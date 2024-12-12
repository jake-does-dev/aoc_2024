import gleam/dict.{type Dict}
import gleam/list
import gleam/set.{type Set}
import grid.{type Coords, type Grid}
import simplifile

type Direction {
  Left
  Right
  Up
  Down
}

type Step {
  Step(
    number: Int,
    coords: Coords,
    next_direction: Direction,
    visited: Set(Coords),
  )
}

type Move {
  Move(coords: Coords, direction: Direction)
}

pub fn part_one(file: String) -> Int {
  let assert Ok(input) = simplifile.read(file)

  let grid = grid.parse(input)
  let assert Ok(origin) = origin(grid)

  let steps =
    do_walk(grid, [
      Step(
        number: 0,
        coords: origin,
        next_direction: Up,
        visited: set.from_list([origin]),
      ),
    ])

  let assert Ok(last_step) = list.first(steps)
  set.size(last_step.visited)
}

pub fn part_two(file: String) -> Int {
  let assert Ok(input) = simplifile.read(file)

  let grid = grid.parse(input)
  let assert Ok(origin) = origin(grid)

  let #(size_x, size_y) = grid.size(grid)

  let obstructed_grids =
    list.range(0, size_x)
    |> list.map(fn(x) {
      list.range(0, size_y)
      |> list.map(fn(y) {
        let coords = #(x, y)
        dict.insert(grid, coords, "#")
      })
    })
    |> list.flatten

  obstructed_grids
  |> list.count(fn(grid) {
    do_overlapping_walk(grid, Move(origin, Up), dict.new())
  })
}

fn do_overlapping_walk(
  grid: Grid(String),
  current_move: Move,
  all_moves: Dict(Move, Int),
) -> Bool {
  let all_moves = case dict.get(all_moves, current_move) {
    Ok(count) -> dict.insert(all_moves, current_move, count + 1)
    Error(_) -> dict.insert(all_moves, current_move, 1)
  }

  case dict.get(all_moves, current_move) {
    Ok(2) -> {
      True
    }
    // walk contains a loop if we see the same coordinate AND the same direction at a future point
    _ -> {
      let coords = current_move.coords
      let direction = current_move.direction

      case dict.get(grid, move(coords, direction)) {
        Ok(_) -> {
          let next_direction = case
            dict.get(grid, move(coords, direction)),
            dict.get(grid, move(coords, rotate(direction))),
            dict.get(grid, move(coords, rotate(rotate(direction)))),
            dict.get(grid, move(coords, rotate(rotate(rotate(direction)))))
          {
            d, _, _, _ if d != Ok("#") -> direction
            _, d, _, _ if d != Ok("#") -> rotate(direction)
            _, _, d, _ if d != Ok("#") -> rotate(rotate(direction))
            _, _, _, _ -> rotate(rotate(rotate(direction)))
          }

          do_overlapping_walk(
            grid,
            Move(move(coords, next_direction), next_direction),
            dict.insert(all_moves, current_move, 1),
          )
        }
        // error as out of bounds
        Error(Nil) -> False
      }
    }
  }
}

fn do_walk(grid: Grid(String), steps: List(Step)) -> List(Step) {
  let assert Ok(last_step) = list.first(steps)
  let coords = last_step.coords
  let direction = last_step.next_direction
  let visited = last_step.visited

  case dict.get(grid, move(coords, direction)) {
    Ok(value) -> {
      let #(coords, next_direction) = case value {
        "#" -> #(move(coords, rotate(direction)), rotate(direction))
        _ -> #(move(coords, direction), direction)
      }
      let step =
        Step(
          number: last_step.number + 1,
          coords: coords,
          next_direction: next_direction,
          visited: set.insert(visited, coords),
        )
      do_walk(grid, [step, ..steps])
    }
    Error(Nil) -> steps
  }
}

fn rotate(direction: Direction) -> Direction {
  case direction {
    Up -> Right
    Right -> Down
    Down -> Left
    Left -> Up
  }
}

fn move(point: Coords, direction: Direction) -> Coords {
  let #(x, y) = point

  case direction {
    Up -> #(x, y - 1)
    Down -> #(x, y + 1)
    Left -> #(x - 1, y)
    Right -> #(x + 1, y)
  }
}

fn origin(grid: Grid(String)) -> Result(Coords, Nil) {
  grid
  |> dict.filter(fn(_key, value) { value == "^" })
  |> dict.keys()
  |> list.first
}
