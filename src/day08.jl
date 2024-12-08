module Day08

using AdventOfCode2024
using IterTools


function day08(input::String = readInput(joinpath(@__DIR__, "..", "data", "day08.txt")))
    data = map(x -> x[1], reduce(vcat, permutedims.(map(x -> split(x, ""), split(input)))))
    solve(data)
end

function solve(data)
    antinodes_p1 = Set{CartesianIndex{2}}()
    antinodes_p2 = Set{CartesianIndex{2}}()
    frequencies = filter(x -> x != '.', unique(data))
    for freq ∈ frequencies
        positions = findall(x -> x == freq, data)
        for (x, y) ∈ subsets(positions, 2)
            # part 1:
            antis = (2 * x - y, 2 * y - x)
            for anti ∈ antis
                if checkbounds(Bool, data, anti)
                    push!(antinodes_p1, anti)
                end
            end

            # part 2:
            push!(antinodes_p2, x)
            dir = y - x
            next = x + dir
            while checkbounds(Bool, data, next)
                push!(antinodes_p2, next)
                next += dir
            end
            next = x - dir
            while checkbounds(Bool, data, next)
                push!(antinodes_p2, next)
                next -= dir
            end
        end
    end
    return [length(antinodes_p1), length(antinodes_p2)]
end

end # module