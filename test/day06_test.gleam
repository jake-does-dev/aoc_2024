import day06
import gleeunit/should

import qcheck_gleeunit_utils/test_spec

pub fn part_one_example_test() {
  day06.part_one("./test/resources/day06_example.txt")
  |> should.equal(41)
}

// pub fn part_one_puzzle_test() {
//   day06.part_one("./test/resources/day06_puzzle.txt")
//   |> should.equal(4939)
// }

pub fn part_two_example_test() {
  day06.part_two("./test/resources/day06_example.txt")
  |> should.equal(6)
}
// pub fn part_two_puzzle_test_() {
//   test_spec.make(fn() {
//     day06.part_two("./test/resources/day06_puzzle.txt")
//     |> should.equal(1434)
//   })
// }
