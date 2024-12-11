import day07
import gleeunit/should

pub fn part_one_example_test() {
  day07.part_one("./test/resources/day07_example.txt")
  |> should.equal(Ok(3749))
}

// pub fn part_one_puzzle_test() {
//   day07.part_one("./test/resources/day07_puzzle.txt")
//   |> should.equal(Ok(20_665_830_408_335))
// }

pub fn part_two_example_test() {
  day07.part_two("./test/resources/day07_example.txt")
  |> should.equal(Ok(11_387))
}
// pub fn part_two_puzzle_test() {
//   day07.part_two("./test/resources/day07_puzzle.txt")
//   |> should.equal(Ok(354_060_705_047_464))
// }
