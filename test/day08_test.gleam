import day08
import gleeunit/should

pub fn part_one_example_test() {
  day08.part_one("./test/resources/day08_example.txt")
  |> should.equal(14)
}

// pub fn part_one_puzzle_test() {
//   day08.part_one("./test/resources/day08_puzzle.txt")
//   |> should.equal(256)
// }

pub fn part_two_example_test() {
  day08.part_two("./test/resources/day08_example.txt")
  |> should.equal(34)
}
// pub fn part_two_puzzle_test() {
//   day08.part_two("./test/resources/day08_puzzle.txt")
//   |> should.equal(1005)
// }
