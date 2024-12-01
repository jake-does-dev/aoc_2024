import day01
import gleeunit/should

pub fn part_one_example_test() {
  day01.part_one("./test/resources/day01_example.txt")
  |> should.equal(Ok(11))
}

// pub fn part_one_puzzle_test() {
//   day01.part_one("./test/resources/day01_puzzle.txt")
//   |> should.equal(Ok(2_000_468))
// }

pub fn part_two_example_test() {
  day01.part_two("./test/resources/day01_example.txt")
  |> should.equal(Ok(31))
}
// pub fn part_two_puzzle_test() {
//   day01.part_two("./test/resources/day01_puzzle.txt")
//   |> should.equal(Ok(18_567_089))
// }
