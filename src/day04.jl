module Day04

using AdventOfCode2024


function day04(input::String = readInput(joinpath(@__DIR__, "..", "data", "day04.txt")))
    data = map(x -> x[1], reduce(vcat, permutedims.(map(x -> split(x, ""), split(input)))))
    return [part1(data), part2(data)]
end

function part1(data::Matrix{Char})
    p1 = 0
    xpos = findall(x -> x == 'X', data)
    for xp ∈ xpos
        for ind ∈ CartesianIndex(-1, -1):CartesianIndex(1, 1)
            if checkbounds(Bool, data, xp + 3*ind) && data[xp + ind] == 'M' && data[xp + 2*ind] == 'A' && data[xp + 3*ind] == 'S'
                p1 += 1
            end
        end
    end
    return p1
end

function part2(data::Matrix{Char})
    p2 = 0
    apos = findall(x -> x == 'A', data)
    for ap ∈ apos
        tl = ap + CartesianIndex(-1, -1)
        tr = ap + CartesianIndex(-1, 1)
        bl = ap + CartesianIndex(1, -1)
        br = ap + CartesianIndex(1, 1)
        checkbounds(Bool, data, [tl, tr, bl, br]) || continue
        if ((data[tl] == 'M' && data[br] == 'S') || data[tl] == 'S' && data[br] == 'M') && ((data[bl] == 'M' && data[tr] == 'S') || data[bl] == 'S' && data[tr] == 'M')
            p2 += 1
        end
    end
    return p2
end

end # module