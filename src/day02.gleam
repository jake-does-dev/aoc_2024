import gleam/list
import utils

pub fn part_one(file: String) -> Int {
  let reports = utils.list_of_lists(file, "\n", " ")

  list.count(reports, safe)
}

fn safe(report: List(Int)) -> Bool {
  report
  |> list.window_by_2
  |> list.map(fn(pair) { pair.1 - pair.0 })
  |> fn(diffs) {
    list.all(diffs, fn(diff) { 1 <= diff && diff <= 3 })
    || list.all(diffs, fn(diff) { -3 <= diff && diff <= -1 })
  }
}

pub fn part_two(file: String) -> Int {
  let reports = utils.list_of_lists(file, "\n", " ")

  reports
  |> list.count(fn(report) {
    // Remove one value from *every* report - if any of them are safe, then
    // that report will have at most one bad level
    report
    |> list.index_map(fn(_, idx) {
      let first_half = list.take(report, idx)
      let second_half_without_idx = list.drop(report, idx + 1)

      list.append(first_half, second_half_without_idx)
    })
    |> list.any(safe)
  })
}
