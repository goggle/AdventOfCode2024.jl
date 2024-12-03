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
