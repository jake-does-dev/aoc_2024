import gleam/int
import gleam/list
import gleam/result
import gleam/string
import simplifile

type Block {
  File(id: Int)
  Free
}

pub fn part_one(file: String) -> Result(Int, Nil) {
  let assert Ok(input) = simplifile.read(file)
  do_part_one(input)
}

pub fn do_part_one(contents: String) -> Result(Int, Nil) {
  let blocks =
    string.split(contents, on: "")
    |> list.map(int.parse)
    |> result.values
    |> as_blocks

  let reverse_file_ids =
    blocks
    |> list.reverse
    |> list.filter_map(fn(block) {
      case block {
        File(id) -> Ok(id)
        Free -> Error(Nil)
      }
    })

  do_defrag(blocks, reverse_file_ids)
  |> list.take(list.length(reverse_file_ids))
  |> checksum
}

pub fn part_two(file: String) -> Int {
  todo
}

fn do_defrag(forward: List(Block), reverse_file_ids: List(Int)) -> List(Int) {
  case forward {
    [] -> []
    [block, ..rest] ->
      case block {
        File(id) -> [id, ..do_defrag(rest, reverse_file_ids)]
        Free -> {
          let assert [rev_id, ..rest_reverse_file_ids] = reverse_file_ids
          [rev_id, ..do_defrag(rest, rest_reverse_file_ids)]
        }
      }
  }
}

fn as_blocks(disk_map: List(Int)) -> List(Block) {
  disk_map
  |> list.index_map(fn(x, i) { #(i, x) })
  |> list.fold(from: [], with: fn(frag, pair) {
    let #(index, value) = pair
    let id = index / 2

    let next = case index % 2 {
      0 -> {
        // this is a file block, where 'id' must be present a 'value' number of times
        list.range(0, value - 1)
        |> list.map(fn(_) { File(id) })
      }
      _ -> {
        // this is a zero block; initialise '-1'  a 'value' number of times
        list.range(0, value - 1)
        |> list.map(fn(_) { Free })
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

fn as_string(blocks: List(Block)) -> String {
  blocks
  |> list.map(fn(block) {
    case block {
      File(id) -> int.to_string(id)
      Free -> "."
    }
  })
  |> string.concat
}

fn checksum(defragmented: List(Int)) -> Result(Int, Nil) {
  defragmented
  |> list.index_map(fn(value, index) { value * index })
  |> list.reduce(int.add)
}
