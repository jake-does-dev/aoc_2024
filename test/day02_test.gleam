import day02
import gleeunit/should

pub fn part_one_example_test() {
  day02.part_one("./test/resources/day02_example.txt")
  |> should.equal(2)
}

// pub fn part_one_puzzle_test() {
//   day02.part_one("./test/resources/day02_puzzle.txt")
//   |> should.equal(411)
// }

pub fn part_two_example_test() {
  day02.part_two("./test/resources/day02_example.txt")
  |> should.equal(4)
}
// pub fn part_two_puzzle_test() {
//   day02.part_two("./test/resources/day02_puzzle.txt")
//   |> should.equal(465)
// }
