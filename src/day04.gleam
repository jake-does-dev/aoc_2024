import gleam/dict
import gleam/list
import grid
import simplifile

pub fn part_one(file: String) -> Int {
  let assert Ok(input) = simplifile.read(file)
  let grid = grid.parse(input)

  // going clockwise around, starting from north
  let cardinal_directions = [
    #(0, 1),
    #(1, 1),
    #(1, 0),
    #(1, -1),
    #(0, -1),
    #(-1, -1),
    #(-1, 0),
    #(-1, 1),
  ]

  dict.fold(grid, 0, fn(sum, origin, char) {
    case char {
      "X" -> {
        sum
        + list.fold(cardinal_directions, 0, fn(sum, direction) {
          let #(x, y) = origin
          let #(dx, dy) = direction

          let one_step = #(x + dx, y + dy)
          let two_steps = #(x + 2 * dx, y + 2 * dy)
          let three_steps = #(x + 3 * dx, y + 3 * dy)

          case
            dict.get(grid, one_step),
            dict.get(grid, two_steps),
            dict.get(grid, three_steps)
          {
            Ok("M"), Ok("A"), Ok("S") -> sum + 1
            _, _, _ -> sum
          }
        })
      }
      _ -> sum
    }
  })
}

pub fn part_two(file: String) -> Int {
  let assert Ok(input) = simplifile.read(file)
  let grid = grid.parse(input)

  dict.fold(grid, 0, fn(sum, origin, char) {
    case char {
      "A" -> {
        let #(x, y) = origin

        let nw = dict.get(grid, #(x - 1, y - 1))
        let ne = dict.get(grid, #(x + 1, y - 1))
        let sw = dict.get(grid, #(x - 1, y + 1))
        let se = dict.get(grid, #(x + 1, y + 1))

        case nw, ne, sw, se {
          Ok("M"), Ok("S"), Ok("M"), Ok("S")
          | Ok("M"), Ok("M"), Ok("S"), Ok("S")
          | Ok("S"), Ok("S"), Ok("M"), Ok("M")
          | Ok("S"), Ok("M"), Ok("S"), Ok("M")
          -> {
            sum + 1
          }
          _, _, _, _ -> sum
        }
      }
      _ -> sum
    }
  })
}
