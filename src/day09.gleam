import gleam/int
import gleam/io
import gleam/list
import gleam/pair
import gleam/result
import gleam/string
import simplifile

type Block {
  File(id: Int)
  Free
}

type DenseBlock {
  DenseFile(id: Int, frequency: Int)
  DenseFree(frequency: Int)
}

pub fn part_one(file: String) -> Result(Int, Nil) {
  let assert Ok(input) = simplifile.read(file)
  do_part_one(input)
}

pub fn do_part_one(contents: String) -> Result(Int, Nil) {
  let blocks = extract_blocks(contents)
  let reverse_file_ids = reverse_file_ids(blocks)

  do_defrag(blocks, reverse_file_ids)
  |> list.take(list.length(reverse_file_ids))
  |> checksum
}

pub fn part_two(file: String) -> Result(Int, Nil) {
  let assert Ok(input) = simplifile.read(file)
  do_part_two(input)
}

pub fn do_part_two(contents: String) -> Result(Int, Nil) {
  let blocks = extract_blocks(contents)
  let dense_blocks =
    extract_dense_blocks(contents)
    |> io.debug
  let reverse_dense_files =
    reverse_dense_files(dense_blocks)
    |> io.debug

  do_dense_defrag(dense_blocks, reverse_dense_files)

  Ok(1)
}

fn reverse_file_ids(blocks: List(Block)) -> List(Int) {
  blocks
  |> list.reverse
  |> list.filter_map(fn(block) {
    case block {
      File(id) -> Ok(id)
      Free -> Error(Nil)
    }
  })
}

fn reverse_dense_files(blocks: List(DenseBlock)) -> List(DenseBlock) {
  blocks
  |> list.filter(fn(block) {
    case block {
      DenseFile(_, _) -> True
      DenseFree(_) -> False
    }
  })
  |> list.reverse
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

fn do_dense_defrag(
  forward: List(DenseBlock),
  reverse_dense_files: List(DenseBlock),
) -> List(DenseBlock) {
  io.debug(#("forward: ", forward |> dense_blocks_to_blocks |> as_string))
  case reverse_dense_files {
    [] -> {
      io.debug("done!")
      forward
    }
    [reverse_dense_file, ..rest] -> {
      // io.debug(#("forward: ", forward))
      let assert DenseFile(reverse_id, reverse_count) = reverse_dense_file

      // io.debug(#("reverse_dense_file", reverse_dense_file))
      let insertable_blocks =
        forward
        |> list.index_map(fn(x, idx) { #(x, idx) })
        |> list.filter(fn(p) {
          case pair.first(p) {
            DenseFree(c) if reverse_count <= c -> True
            _ -> False
          }
        })
        |> list.first()

      // io.debug(#("insertable_blocks", insertable_blocks))
      case insertable_blocks {
        Error(_) -> {
          // this block cannot be moved, so we continue
          do_dense_defrag(forward, rest)
        }
        Ok(#(DenseFree(count), idx)) -> {
          // io.debug(DenseFile(reverse_id, reverse_count))
          // io.debug(#(DenseFree(count), idx))

          let start = list.take(forward, idx)
          let end = list.drop(forward, idx + 1)
          let dense_file = DenseFile(reverse_id, reverse_count)

          let moved_dense_file =
            case count - reverse_count {
              rem if rem > 0 -> [
                start,
                [dense_file],
                [DenseFree(count - reverse_count)],
                end,
              ]
              _ -> [start, [dense_file], end]
            }
            |> list.flatten

          io.debug(#("moved", moved_dense_file))
          // io.debug(#("start:", start))
          // io.debug(#("end:", end))
          // io.debug(#("dense_file:", dense_file))
          // io.debug(#("moved_dense_file:", moved_dense_file))

          // io.debug(#("rest", rest))

          do_dense_defrag(moved_dense_file, rest)
        }
        _ -> panic as "impossible"
      }
    }
  }
}

fn disk_map(data: String) -> List(Int) {
  string.split(data, on: "")
  |> list.map(int.parse)
  |> result.values
}

fn extract_blocks(data: String) -> List(Block) {
  data
  |> disk_map
  |> as_blocks
}

fn extract_dense_blocks(data: String) -> List(DenseBlock) {
  data
  |> disk_map
  |> as_dense_blocks
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

fn dense_blocks_to_blocks(dense_blocks: List(DenseBlock)) -> List(Block) {
  dense_blocks
  |> list.map(fn(dense) {
    case dense {
      DenseFile(id, freq) -> list.repeat(File(id), freq)
      DenseFree(freq) -> list.repeat(Free, freq)
    }
  })
  |> list.flatten
}

fn as_dense_blocks(disk_map: List(Int)) -> List(DenseBlock) {
  disk_map
  |> list.index_map(fn(value, index) {
    case index % 2 {
      0 -> DenseFile(id: index / 2, frequency: value)
      _ -> DenseFree(frequency: value)
    }
  })
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
