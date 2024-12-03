module Day03

using AdventOfCode2024
using IterTools


function day03(input::String = readInput(joinpath(@__DIR__, "..", "data", "day03.txt")))
    reg = r"mul\(([0-9]{1,3}),([0-9]{1,3})\)"
    occurences = findall(reg, input)
    p1 = 0
    for occ ∈ occurences
        m = match(reg, input[occ])
        p1 += parse(Int, m.captures[1]) * parse(Int, m.captures[2])
    end

    creg = r"do(?:n't)?\(\)"
    coccurences = findall(creg, input)
    enabled = ones(Bool, length(input))
    for (a, b) ∈ partition(coccurences, 2, 1)
        if length(a) != 4
            enabled[a[2]:b[1]] .= false
        end
    end
    if length(coccurences[end]) != 4
        enabled[coccurences[end][2]:end] .= false
    end
    p2 = 0
    for occ ∈ occurences
        if enabled[occ[2]]
            m = match(reg, input[occ])
            p2 += parse(Int, m.captures[1]) * parse(Int, m.captures[2])
        end
    end
    return [p1, p2]
end

end # module