module Day14

using AdventOfCode2024


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

function part1(data; width=101, height=103)
    quadrants = [0, 0, 0, 0]
    for r ∈ data
        x, y = mod(r[1] + 100 * r[3], width), mod(r[2] + 100 * r[4], height)
        if x > (width - 1) ÷ 2
            if y > (height - 1) ÷ 2
                quadrants[4] += 1
            elseif y < (height - 1) ÷ 2
                quadrants[1] += 1
            end
        elseif x < (width - 1) ÷ 2
            if y > (height - 1) ÷ 2
                quadrants[3] += 1
            elseif y < (height - 1) ÷ 2
                quadrants[2] += 1
            end
        end
    end
    return prod(quadrants)
end

function part2(data; width=101, height=103)
    csums = zeros(Int, width)
    rsums = zeros(Int, height)
    i = 1
    while true
        for r ∈ data
            r[1] = mod(r[1] + r[3], width)
            r[2] = mod(r[2] + r[4], height)
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