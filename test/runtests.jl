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
