import gleam/int
import gleam/list
import gleam/result
import gleam/string
import simplifile

type Operator {
  Add
  Mult
  Concat
}

type Equation {
  Equation(total: Int, operands: List(Int))
}

pub fn part_one(file: String) -> Result(Int, Nil) {
  solve(file, [Add, Mult])
}

pub fn part_two(file: String) -> Result(Int, Nil) {
  solve(file, [Add, Mult, Concat])
}

fn solve(file: String, operators: List(Operator)) -> Result(Int, Nil) {
  let assert Ok(contents) = simplifile.read(file)

  contents
  |> string.split("\n")
  |> list.map(fn(line) { parse(line) })
  |> list.map(fn(equation) { solve_equation(equation, operators) })
  |> result.values
  |> list.reduce(int.add)
}

fn apply(operator: Operator, a: Int, b: Int) -> Int {
  case operator {
    Add -> a + b
    Mult -> a * b
    Concat -> {
      let assert Ok(a_digits) = int.digits(a, 10)
      let assert Ok(b_digits) = int.digits(b, 10)
      let concat = list.flatten([a_digits, b_digits])
      let assert Ok(digits) = int.undigits(concat, 10)

      digits
    }
  }
}

fn parse(line: String) -> Equation {
  let assert Ok(#(total, operands)) = string.split_once(line, on: ": ")
  let assert Ok(total) = int.parse(total)
  let operands =
    operands
    |> string.split(" ")
    |> list.map(fn(operand) {
      let assert Ok(operand) = int.parse(operand)
      operand
    })

  Equation(total:, operands:)
}

fn solve_equation(
  equation: Equation,
  operators: List(Operator),
) -> Result(Int, Nil) {
  case equation {
    Equation(total, [last]) if last == total -> Ok(total)
    Equation(_, [a, b, ..rest]) -> {
      operators
      |> list.find_map(fn(operator) {
        let operands = [apply(operator, a, b), ..rest]
        solve_equation(Equation(..equation, operands:), operators)
      })
    }
    _ -> Error(Nil)
  }
}
