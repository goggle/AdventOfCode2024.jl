module Day13

using AdventOfCode2024
using LinearAlgebra


function day13(input::String = readInput(joinpath(@__DIR__, "..", "data", "day13.txt")))
    data = parse_input(input)
    solve(data)
end

function parse_input(input)
    data = []
    r1 = r"Button\s*[A-B]:\s*X\+(\d+),\sY\+(\d+)"
    r2 = r"Prize:\s*X=(\d+),\s*Y=(\d+)"
    for block ∈ split(input, "\n\n")
        lines = split(block, "\n")
        ax, ay = parse.(Int, match(r1, lines[1]).captures)
        bx, by = parse.(Int, match(r1, lines[2]).captures)
        x, y = parse.(Int, match(r2, lines[3]).captures)
        push!(data, (ax, ay, bx, by, x, y))
    end
    return data
end

function solve(data)
    p = [0, 0]
    for elem ∈ data
        A = [elem[1] elem[3]; elem[2] elem[4]]
        bs = [[elem[5], elem[6]], [elem[5] + 10_000_000_000_000, elem[6] + 10_000_000_000_000]]
        for (i, b) ∈ enumerate(bs)
            x = round.(Int, A\b)
            if A * x == b
                p[i] += 3 * x[1] + x[2]
            end
        end
    end
    return p
end

end # module