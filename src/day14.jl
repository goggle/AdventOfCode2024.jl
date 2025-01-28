module Day14

using AdventOfCode2024
using StaticArrays

const WIDTH = 101
const HEIGHT = 103

function day14(input::String = readInput(joinpath(@__DIR__, "..", "data", "day14.txt")))
    data = parse_input(input)
    return [part1(data), part2(data)]
end

function parse_input(input)
    reg = r"p=(-?\d+),(-?\d+)\s*v=(-?\d+),(-?\d+)"
    data = Vector{Int}[]
    for line ∈ eachsplit(rstrip(input), "\n")
        push!(data, parse.(Int, match(reg, line).captures))
    end
    return data
end

function part1(data)
    quadrants = MVector((0, 0, 0, 0))
    @inbounds for r ∈ data
        x, y = mod(r[1] + 100 * r[3], WIDTH), mod(r[2] + 100 * r[4], HEIGHT)
        if x > (WIDTH - 1) ÷ 2
            if y > (HEIGHT - 1) ÷ 2
                quadrants[4] += 1
            elseif y < (HEIGHT - 1) ÷ 2
                quadrants[1] += 1
            end
        elseif x < (WIDTH - 1) ÷ 2
            if y > (HEIGHT - 1) ÷ 2
                quadrants[3] += 1
            elseif y < (HEIGHT - 1) ÷ 2
                quadrants[2] += 1
            end
        end
    end
    return prod(quadrants)
end

function part2(data)
    csums = MVector{WIDTH}(zeros(Int, WIDTH))
    rsums = MVector{HEIGHT}(zeros(Int, HEIGHT))
    i = 1
    @inbounds while true
        for r ∈ data
            r[1] = mod(r[1] + r[3], WIDTH)
            r[2] = mod(r[2] + r[4], HEIGHT)
            csums[r[1] + 1] += 1
            rsums[r[2] + 1] += 1
        end
        if any(>(30), csums) && any(>(30), rsums)
            return i
        end
        csums .= 0
        rsums .= 0
        i += 1
    end
end

end # module