import gleam/int
import gleam/list
import gleam/option.{Some}
import gleam/regexp
import simplifile

type Operation {
  Do
  DoNot
  Mult(Int, Int)
}

pub fn part_one(file: String) -> Int {
  find_matches(file, "mul\\((\\d+),(\\d+)\\)")
  |> parse_matches
  |> list.fold(0, fn(sum, operation) {
    case operation {
      Do -> sum
      DoNot -> sum
      Mult(first, second) -> sum + first * second
    }
  })
}

pub fn part_two(file: String) -> Int {
  find_matches(file, "mul\\((\\d+),(\\d+)\\)|do\\(\\)|don't\\(\\)")
  |> parse_matches
  |> do_conditional_sum(Do, 0)
}

fn find_matches(file: String, pattern: String) -> List(regexp.Match) {
  let assert Ok(memory) = simplifile.read(file)
  let assert Ok(re) = regexp.from_string(pattern)
  regexp.scan(with: re, content: memory)
}

fn parse_matches(matches: List(regexp.Match)) -> List(Operation) {
  matches
  |> list.map(fn(match) {
    case match.content {
      "do()" -> Do
      "don't()" -> DoNot
      _ ->
        case match.submatches {
          [Some(first), Some(second)] -> {
            let assert Ok(first) = int.parse(first)
            let assert Ok(second) = int.parse(second)
            Mult(first, second)
          }
          _ -> Mult(0, 0)
        }
    }
  })
}

fn do_conditional_sum(
  parsed: List(Operation),
  condition: Operation,
  sum: Int,
) -> Int {
  case parsed {
    [] -> sum
    [next, ..rest] -> {
      case next {
        Do | DoNot -> do_conditional_sum(rest, next, sum)
        Mult(first, second) -> {
          case condition {
            Do -> {
              let new_sum = sum + first * second
              do_conditional_sum(rest, condition, new_sum)
            }
            DoNot -> do_conditional_sum(rest, condition, sum)
            Mult(_, _) -> panic as "this should never happen"
          }
        }
      }
    }
  }
}
