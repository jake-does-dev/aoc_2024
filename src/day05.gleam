import gleam/int
import gleam/list
import gleam/order
import gleam/pair
import gleam/result
import gleam/string
import simplifile

type Rule {
  Rule(before: Int, after: Int)
}

type Pair {
  Pair(first: Int, last: Int)
}

type Update =
  List(Int)

pub fn part_one(file: String) -> Result(Int, Nil) {
  let assert Ok(input) = simplifile.read(file)
  let #(rules, updates) = parse(input)

  let valid_updates =
    updates
    |> list.filter(fn(update) {
      let #(pairs, matching_rules) = find_matches(update, rules)
      list.length(matching_rules) == list.length(pairs)
    })

  sum_midpoints(valid_updates)
}

pub fn part_two(file: String) -> Result(Int, Nil) {
  let assert Ok(input) = simplifile.read(file)
  let #(rules, updates) = parse(input)

  let invalid_updates =
    updates
    |> list.filter(fn(update) {
      let #(pairs, matching_rules) = find_matches(update, rules)
      list.length(matching_rules) != list.length(pairs)
    })

  let fixed_updates =
    invalid_updates
    |> list.map(fn(update) {
      update
      |> list.sort(by: fn(a, b) {
        let a_first =
          rules
          |> list.filter(fn(rule) { rule.before == a && rule.after == b })

        let b_first =
          rules
          |> list.filter(fn(rule) { rule.before == b && rule.after == a })

        case a_first, b_first {
          [], [] -> order.Eq
          [_, ..], [] -> order.Lt
          [], [_, ..] -> order.Gt
          [_, ..], _ -> panic as "Should never happen"
        }
      })
    })

  sum_midpoints(fixed_updates)
}

fn parse(input: String) -> #(List(Rule), List(Update)) {
  let assert Ok(#(rules_block, updates_block)) =
    input
    |> string.split_once(on: "\n\n")

  let rules =
    rules_block
    |> string.split(on: "\n")
    |> list.map(fn(s) {
      let assert Ok(#(before, after)) = string.split_once(s, on: "|")
      let assert Ok(before) = int.parse(before)
      let assert Ok(after) = int.parse(after)
      Rule(before, after)
    })

  let updates: List(Update) =
    updates_block
    |> string.split(on: "\n")
    |> list.map(fn(update) {
      update
      |> string.split(on: ",")
      |> list.map(fn(num) {
        let assert Ok(num) = int.parse(num)
        num
      })
    })

  #(rules, updates)
}

fn find_matches(update: Update, rules: List(Rule)) -> #(List(Pair), List(Rule)) {
  let pairs =
    update
    |> list.window_by_2()
    |> list.map(fn(window) { Pair(window.0, window.1) })

  let matching_rules =
    pairs
    |> list.map(fn(pair) {
      rules
      |> list.filter(fn(rule) {
        rule.before == pair.first && rule.after == pair.last
      })
    })
    |> list.flatten

  #(pairs, matching_rules)
}

fn sum_midpoints(updates: List(Update)) -> Result(Int, Nil) {
  updates
  |> list.map(fn(update) {
    let length = list.length(update)
    let num_drop = { length - 1 } / 2

    update
    |> list.drop(num_drop)
    |> list.first
    |> result.unwrap(0)
  })
  |> list.reduce(int.add)
}
