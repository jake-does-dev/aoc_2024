import day04
import gleeunit/should

pub fn part_one_example_test() {
  day04.part_one("./test/resources/day04_example.txt")
  |> should.equal(18)
}

// pub fn part_one_puzzle_test() {
//   day04.part_one("./test/resources/day04_puzzle.txt")
//   |> should.equal(2514)
// }

pub fn part_two_example_test() {
  day04.part_two("./test/resources/day04_example.txt")
  |> should.equal(9)
}
// pub fn part_two_puzzle_test() {
//   day04.part_two("./test/resources/day04_puzzle.txt")
//   |> should.equal(1888)
// }
