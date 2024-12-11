import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import simplifile

pub fn part_one(file: String) -> Result(Int, Nil) {
  let assert Ok(input) = simplifile.read(file)
  let fragmented =
    string.split(input, on: "")
    |> list.map(int.parse)
    |> result.values
    |> fragmented

  fragmented
  |> do_defrag
  |> checksum
}

pub fn part_two(file: String) -> Int {
  todo
}

fn do_defrag(fragmented: List(Int)) -> List(Int) {
  case list.any(fragmented, fn(x) { x == -99 }) {
    False -> fragmented
    // we are done
    True -> {
      let assert Ok(last) = list.last(fragmented)
      let without_last = list.take(fragmented, list.length(fragmented) - 1)

      case last {
        -99 -> do_defrag(without_last)
        _ -> {
          let before_missing = list.take_while(without_last, fn(x) { x != -99 })
          let missing_index = list.length(before_missing)
          let after_missing = list.drop(without_last, missing_index + 1)

          do_defrag(
            list.flatten([before_missing, [last], after_missing]) |> io.debug,
          )
        }
      }
    }
  }
}

fn fragmented(disk_map: List(Int)) -> List(Int) {
  disk_map
  |> list.index_map(fn(x, i) { #(i, x) })
  |> list.fold(from: [], with: fn(frag, pair) {
    let #(index, value) = pair
    let id = index / 2

    let next = case index % 2 {
      0 -> {
        // this is a file block, where 'id' must be present a 'value' number of times
        list.range(0, value - 1)
        |> list.map(fn(_) { id })
      }
      _ -> {
        // this is a zero block; initialise '-1'  a 'value' number of times
        list.range(0, value - 1)
        |> list.map(fn(_) { -99 })
      }
    }

    case value {
      0 -> frag
      _ -> [next, ..frag]
    }
  })
  |> list.flatten
  |> list.reverse
}

fn checksum(defragmented: List(Int)) -> Result(Int, Nil) {
  defragmented
  |> list.index_map(fn(value, index) { value * index })
  |> list.reduce(int.add)
}
