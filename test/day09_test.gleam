import day09
import gleeunit/should

pub fn part_one_12345_test() {
  day09.do_part_one("12345")
  |> should.equal(Ok(60))
}

pub fn part_one_90909_test() {
  day09.do_part_one("90909")
  |> should.equal(Ok(513))
}

pub fn part_one_example_test() {
  day09.part_one("./test/resources/day09_example.txt")
  |> should.equal(Ok(1928))
}
// pub fn part_one_puzzle_test() {
//   day09.part_one("./test/resources/day09_puzzle.txt")
//   |> should.equal(Ok(6_421_128_769_094))
// }
// pub fn part_two_example_test() {
//   day09.part_two("./test/resources/day09_example.txt")
//   |> should.equal(Ok(2858))
// }
// pub fn part_two_puzzle_test() {
//   day09.part_two("./test/resources/day09_puzzle.txt")
//   |> should.equal(1005)
// }
