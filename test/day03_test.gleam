import day03
import gleeunit/should

pub fn part_one_example_test() {
  day03.part_one("./test/resources/day03_part1_example.txt")
  |> should.equal(161)
}

// pub fn part_one_puzzle_test() {
//   day03.part_one("./test/resources/day03_puzzle.txt")
//   |> should.equal(166_905_464)
// }

pub fn part_two_example_test() {
  day03.part_two("./test/resources/day03_part2_example.txt")
  |> should.equal(48)
}
// pub fn part_two_puzzle_test() {
//   day03.part_two("./test/resources/day03_puzzle.txt")
//   |> should.equal(72_948_684)
// }
