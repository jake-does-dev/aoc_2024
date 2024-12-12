import gleam/deque.{type Deque}
import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import simplifile

type Block {
  File(id: Int, occurrences: Int)
  Free(occurrences: Int)
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

  let fragmented = deque.from_list(blocks)

  case do_defrag_deque(fragmented, 0, 0) {
    val -> Ok(val)
  }
  // |> deque.to_list
  // |> list.filter(fn(block) {
  //   case block {
  //     File(_, _) -> True
  //     Free(_) -> False
  //   }
  // })
  // |> checksum
  // io.debug(#("parsed_blocks:", as_string(blocks)))

  // let defragged =
  //   do_defrag([], blocks, list.reverse(blocks), 0, list.length(blocks) - 1)

  // // io.debug(#("defragged:", as_string(defragged)))

  // checksum(defragged)
}

pub fn part_two(file: String) -> Int {
  todo
}

fn do_defrag_deque(
  // defragged: Deque(Block),
  fragmented: Deque(Block),
  index: Int,
  checksum: Int,
) -> Int {
  case deque.pop_front(fragmented) {
    Error(_) -> {
      // no more elements in the Deque to process!
      checksum
    }
    Ok(#(next_forward, remaining)) -> {
      case next_forward {
        File(id, _) -> {
          do_defrag_deque(fragmented, index + 1, checksum + index * id)
        }
        Free(_) -> {
          let assert #(File(id, _occ), remaining) =
            do_find_next_file_deque(remaining)
          do_defrag_deque(remaining, index + 1, checksum + index * id)
        }
      }
    }
  }
}

fn do_find_next_file_deque(fragmented: Deque(Block)) -> #(Block, Deque(Block)) {
  case deque.pop_back(fragmented) {
    Ok(#(Free(_), remaining)) -> do_find_next_file_deque(remaining)
    Ok(pair) -> pair
    Error(_) -> #(Free(-9), deque.from_list([]))
  }
  // case list.first(blocks) {
  //   Ok(Free(_)) -> do_find_next_file(list.drop(blocks, 1), num_free_dropped + 1)
  //   Ok(File(id, occurrences)) -> #(
  //     File(id, occurrences),
  //     list.drop(blocks, 1),
  //     num_free_dropped,
  //   )
  //   Error(_) ->
  //     panic as "Precondition expects there to be at least one File block"
  // }
}

fn do_defrag(
  defragmented: List(Block),
  forward_entries: List(Block),
  reverse_entries: List(Block),
  forward_idx: Int,
  reverse_idx: Int,
) -> List(Block) {
  io.debug(#("defragmented", list.reverse(defragmented) |> as_string))

  io.debug(#("forward_idx:", forward_idx, "reverse_idx", reverse_idx))
  case forward_idx == reverse_idx {
    True -> list.reverse(defragmented)
    False -> {
      case list.first(forward_entries) {
        Ok(File(id, occurrences)) -> {
          do_defrag(
            [File(id, occurrences), ..defragmented],
            list.drop(forward_entries, 1),
            reverse_entries,
            forward_idx + 1,
            reverse_idx,
          )
        }
        Ok(Free(_)) -> {
          let #(next_file, reversed_remaining, num_free_dropped) =
            do_find_next_file(reverse_entries, 0)

          // io.debug(#("num_free_dropped", num_free_dropped))

          do_defrag(
            [next_file, ..defragmented],
            list.drop(forward_entries, 1),
            reversed_remaining,
            forward_idx + 1,
            reverse_idx - num_free_dropped - 1,
          )
        }
        Error(_) -> panic as "shouldn't happen?"
      }
    }
  }
}

fn do_find_next_file(
  blocks: List(Block),
  num_free_dropped: Int,
) -> #(Block, List(Block), Int) {
  case list.first(blocks) {
    Ok(Free(_)) -> do_find_next_file(list.drop(blocks, 1), num_free_dropped + 1)
    Ok(File(id, occurrences)) -> #(
      File(id, occurrences),
      list.drop(blocks, 1),
      num_free_dropped,
    )
    Error(_) ->
      panic as "Precondition expects there to be at least one File block"
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
        |> list.map(fn(_) { File(id:, occurrences: value) })
      }
      _ -> {
        // this is a zero block; initialise '-1'  a 'value' number of times
        list.range(0, value - 1)
        |> list.map(fn(_) { Free(occurrences: value) })
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
      File(id, _) -> int.to_string(id)
      Free(_) -> "."
    }
  })
  |> string.concat
  // todo
  // |> list.reduce(with: string.join)
}

fn checksum(defragmented: List(Block)) -> Result(Int, Nil) {
  defragmented
  |> list.index_map(fn(block, index) {
    case block {
      File(id, _) -> id * index
      Free(_) -> 0
    }
  })
  |> list.reduce(int.add)
}
