using AdventOfCode2024
using Test

@testset "Day 1" begin
    sample = "3   4\n" *
             "4   3\n" *
             "2   5\n" *
             "1   3\n" *
             "3   9\n" *
             "3   3\n"
    @test AdventOfCode2024.Day01.day01(sample) == [11, 31]
    @test AdventOfCode2024.Day01.day01() == [1590491, 22588371]
end

@testset "Day 2" begin
    sample = "7 6 4 2 1\n" *
             "1 2 7 8 9\n" *
             "9 7 6 2 1\n" *
             "1 3 2 4 5\n" *
             "8 6 4 4 1\n" *
             "1 3 6 7 9\n"
    @test AdventOfCode2024.Day02.day02(sample) == [2, 4]
    @test AdventOfCode2024.Day02.day02() == [411, 465]
end

@testset "Day 3" begin
    @test AdventOfCode2024.Day03.day03() == [168539636, 97529391]
end

@testset "Day 4" begin
    sample = "MMMSXXMASM\n" *
             "MSAMXMSMSA\n" *
             "AMXSXMAAMM\n" *
             "MSAMASMSMX\n" *
             "XMASAMXAMM\n" *
             "XXAMMXXAMA\n" *
             "SMSMSASXSS\n" *
             "SAXAMASAAA\n" *
             "MAMMMXMMMM\n" *
             "MXMXAXMASX\n"
    @test AdventOfCode2024.Day04.day04(sample) == [18, 9]
    @test AdventOfCode2024.Day04.day04() == [2344, 1815]
end

@testset "Day 5" begin
    sample = "47|53\n" *
             "97|13\n" *
             "97|61\n" *
             "97|47\n" *
             "75|29\n" *
             "61|13\n" *
             "75|53\n" *
             "29|13\n" *
             "97|29\n" *
             "53|29\n" *
             "61|53\n" *
             "97|53\n" *
             "61|29\n" *
             "47|13\n" *
             "75|47\n" *
             "97|75\n" *
             "47|61\n" *
             "75|61\n" *
             "47|29\n" *
             "75|13\n" *
             "53|13\n" *
             "\n" *
             "75,47,61,53,29\n" *
             "97,61,53,29,13\n" *
             "75,29,13\n" *
             "75,97,47,61,53\n" *
             "61,13,29\n" *
             "97,13,75,29,47\n"
    @test AdventOfCode2024.Day05.day05(sample) == [143, 123]
    @test AdventOfCode2024.Day05.day05() == [6041, 4884]
end

@testset "Day 6" begin
    sample = "....#.....\n" *
             ".........#\n" *
             "..........\n" *
             "..#.......\n" *
             ".......#..\n" *
             "..........\n" *
             ".#..^.....\n" *
             "........#.\n" *
             "#.........\n" *
             "......#...\n"
    @test AdventOfCode2024.Day06.day06(sample) == [41, 6]
    @test AdventOfCode2024.Day06.day06() == [4602, 1703]
end

@testset "Day 7" begin
    sample = "190: 10 19\n" *
             "3267: 81 40 27\n" *
             "83: 17 5\n" *
             "156: 15 6\n" *
             "7290: 6 8 6 15\n" *
             "161011: 16 10 13\n" *
             "192: 17 8 14\n" *
             "21037: 9 7 18 13\n" *
             "292: 11 6 16 20\n"
    @test AdventOfCode2024.Day07.day07(sample) == [3749, 11387]
    @test AdventOfCode2024.Day07.day07() == [2437272016585, 162987117690649]
end

@testset "Day 8" begin
    sample = "............\n" *
             "........0...\n" *
             ".....0......\n" *
             ".......0....\n" *
             "....0.......\n" *
             "......A.....\n" *
             "............\n" *
             "............\n" *
             "........A...\n" *
             ".........A..\n" *
             "............\n" *
             "............\n"
    @test AdventOfCode2024.Day08.day08(sample) == [14, 34]
    @test AdventOfCode2024.Day08.day08() == [252, 839]
end

@testset "Day 9" begin
    sample = "2333133121414131402"
    @test AdventOfCode2024.Day09.day09(sample) == [1928, 2858]
    @test AdventOfCode2024.Day09.day09() == [6242766523059, 6272188244509]
end

@testset "Day 10" begin
    sample = "89010123\n" *
             "78121874\n" *
             "87430965\n" *
             "96549874\n" *
             "45678903\n" *
             "32019012\n" *
             "01329801\n" *
             "10456732\n"
    @test AdventOfCode2024.Day10.day10(sample) == [36, 81]
    @test AdventOfCode2024.Day10.day10() == [617, 1477]
end

@testset "Day 11" begin
    sample = "125 17"
    @test AdventOfCode2024.Day11.day11(sample) == [55312, 65601038650482]
    @test AdventOfCode2024.Day11.day11() == [198089, 236302670835517]
end

@testset "Day 12" begin
    sample = "RRRRIICCFF\n" *
             "RRRRIICCCF\n" *
             "VVRRRCCFFF\n" *
             "VVRCCCJFFF\n" *
             "VVVVCJJCFE\n" *
             "VVIVCCJJEE\n" *
             "VVIIICJJEE\n" *
             "MIIIIIJJEE\n" *
             "MIIISIJEEE\n" *
             "MMMISSJEEE\n"
    @test AdventOfCode2024.Day12.day12(sample) == [1930, 1206]
    @test AdventOfCode2024.Day12.day12() == [1304764, 811148]
end

@testset "Day 13" begin
    sample = "Button A: X+94, Y+34\n" *
             "Button B: X+22, Y+67\n" *
             "Prize: X=8400, Y=5400\n" *
             "\n" *
             "Button A: X+26, Y+66\n" *
             "Button B: X+67, Y+21\n" *
             "Prize: X=12748, Y=12176\n" *
             "\n" *
             "Button A: X+17, Y+86\n" *
             "Button B: X+84, Y+37\n" *
             "Prize: X=7870, Y=6450\n" *
             "\n" *
             "Button A: X+69, Y+23\n" *
             "Button B: X+27, Y+71\n" *
             "Prize: X=18641, Y=10279\n"
    @test AdventOfCode2024.Day13.day13(sample) == [480, 875318608908]
    @test AdventOfCode2024.Day13.day13() == [28138, 108394825772874]
end

@testset "Day 14" begin
    @test AdventOfCode2024.Day14.day14() == [221142636, 7916]
end

@testset "Day 15" begin
    sample = "##########\n" *
             "#..O..O.O#\n" *
             "#......O.#\n" *
             "#.OO..O.O#\n" *
             "#..O@..O.#\n" *
             "#O#..O...#\n" *
             "#O..O..O.#\n" *
             "#.OO.O.OO#\n" *
             "#....O...#\n" *
             "##########\n" *
             "\n" *
             "<vv>^<v^>v>^vv^v>v<>v^v<v<^vv<<<^><<><>>v<vvv<>^v^>^<<<><<v<<<v^vv^v>^" *
             "vvv<<^>^v^^><<>>><>^<<><^vv^^<>vvv<>><^^v>^>vv<>v<<<<v<^v>^<^^>>>^<v<v" *
             "><>vv>v^v^<>><>>>><^^>vv>v<^^^>>v^v^<^^>v^^>v^<^v>v<>>v^v^<v>v^^<^^vv<" *
             "<<v<^>>^^^^>>>v^<>vvv^><v<<<>^^^vv^<vvv>^>v<^^^^v<>^>vvvv><>>v^<<^^^^^" *
             "^><^><>>><>^^<<^^v>>><^<v>^<vv>>v>>>^v><>^v><<<<v>>v<v<v>vvv>^<><<>^><" *
             "^>><>^v<><^vvv<^^<><v<<<<<><^v<<<><<<^^<v<^^^><^>>^<v^><<<^>>^v<v^v<v^" *
             ">^>>^v>vv>^<<^v<>><<><<v<<v><>v<^vv<<<>^^v^>^^>>><<^v>>v^v><^^>>^<>vv^" *
             "<><^^>^^^<><vvvvv^v<v<<>^v<v>v<<^><<><<><<<^^<<<^<<>><<><^^^>^^<>^>v<>" *
             "^^>vv<^v^v<vv>^<><v<^v>^^^>>>^^vvv^>vvv<>>>^<^>>>>>^<<^v>^vvv<>^<><<v>" *
             "v^^>>><<^^<>>^v^<v^vv<>v^<<>^<^v^v><^<<<><<^<v><v<>vv>>v><v^<vv<>v^<<^\n"
end

@testset "Day 16" begin
    sample1 = "###############\n" *
              "#.......#....E#\n" *
              "#.#.###.#.###.#\n" *
              "#.....#.#...#.#\n" *
              "#.###.#####.#.#\n" *
              "#.#.#.......#.#\n" *
              "#.#.#####.###.#\n" *
              "#...........#.#\n" *
              "###.#.#####.#.#\n" *
              "#...#.....#.#.#\n" *
              "#.#.#.###.#.#.#\n" *
              "#.....#...#.#.#\n" *
              "#.###.#.#.#.#.#\n" *
              "#S..#.....#...#\n" *
              "###############\n"
    @test AdventOfCode2024.Day16.day16(sample1) == [7036, 45]

    sample2 = "#################\n" *
              "#...#...#...#..E#\n" *
              "#.#.#.#.#.#.#.#.#\n" *
              "#.#.#.#...#...#.#\n" *
              "#.#.#.#.###.#.#.#\n" *
              "#...#.#.#.....#.#\n" *
              "#.#.#.#.#.#####.#\n" *
              "#.#...#.#.#.....#\n" *
              "#.#.#####.#.###.#\n" *
              "#.#.#.......#...#\n" *
              "#.#.###.#####.###\n" *
              "#.#.#...#.....#.#\n" *
              "#.#.#.#####.###.#\n" *
              "#.#.#.........#.#\n" *
              "#.#.#.#########.#\n" *
              "#S#.............#\n" *
              "#################\n"
    @test AdventOfCode2024.Day16.day16(sample2) == [11048, 64]

    sample3 = "################\n" *
              "####.........#E#\n" *
              "###..#######.#.#\n" *
              "###.##...###.#.#\n" *
              "###.##.#.###.#.#\n" *
              "#......#.#.....#\n" *
              "#.#.####.#.#.###\n" *
              "#.#.####...#.###\n" *
              "#.#..#######.###\n" *
              "#S##.........###\n" *
              "################\n"
    @test AdventOfCode2024.Day16.day16(sample3) == [9029, 62]

    sample4 = "#############\n" *
              "#############\n" *
              "##E....######\n" *
              "####.#.######\n" *
              "####...######\n" *
              "####.#.######\n" *
              "####.....S###\n" *
              "#############\n"
    @test AdventOfCode2024.Day16.day16(sample4) == [4011, 17]
    @test AdventOfCode2024.Day16.day16() == [105508, 548]
end

@testset "Day 17" begin
    @test AdventOfCode2024.Day17.day17() == ["5,0,3,5,7,6,1,5,4", 164516454365621]
end

@testset "Day 18" begin
    sample = "5,4\n" *
             "4,2\n" *
             "4,5\n" *
             "3,0\n" *
             "2,1\n" *
             "6,3\n" *
             "2,4\n" *
             "1,5\n" *
             "0,6\n" *
             "3,3\n" *
             "2,6\n" *
             "5,1\n" *
             "1,2\n" *
             "5,5\n" *
             "2,5\n" *
             "6,5\n" *
             "1,4\n" *
             "0,4\n" *
             "6,4\n" *
             "1,1\n" *
             "6,1\n" *
             "1,0\n" *
             "0,5\n" *
             "1,6\n" *
             "2,0\n"
    data = [parse.(Int, split(x, ",")) for x ∈ split(rstrip(sample), "\n")]
    @test AdventOfCode2024.Day18.reachable(data, 12; height=7, width=7)[2] == 22
    @test AdventOfCode2024.Day18.part2(data; rindex=12, height=7, width=7) == "6,1"
    @test AdventOfCode2024.Day18.day18() == [356, "22,33"]
end