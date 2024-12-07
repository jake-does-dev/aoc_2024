import day05
import gleeunit/should

pub fn part_one_example_test() {
  day05.part_one("./test/resources/day05_example.txt")
  |> should.equal(Ok(143))
}

// pub fn part_one_puzzle_test() {
//   day05.part_one("./test/resources/day05_puzzle.txt")
//   |> should.equal(Ok(5651))
// }

pub fn part_two_example_test() {
  day05.part_two("./test/resources/day05_example.txt")
  |> should.equal(Ok(123))
}
// pub fn part_two_puzzle_test() {
//   day05.part_two("./test/resources/day05_puzzle.txt")
//   |> should.equal(Ok(4743))
// }
