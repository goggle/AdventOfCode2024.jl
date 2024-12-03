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
