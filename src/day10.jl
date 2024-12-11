module Day10

using AdventOfCode2024


function day10(input::String = readInput(joinpath(@__DIR__, "..", "data", "day10.txt")))
    data = map(x -> parse(Int, x[1]), reduce(vcat, permutedims.(map(x -> split(x, ""), split(input)))))
    return solve(data)
end

function solve(data::Matrix{Int})
    p1, p2 = 0, 0
    zeropos = findall(x -> x == 0, data)
    for zpos ∈ zeropos
        p1 += score(data, zpos, Set{CartesianIndex{2}}())
        p2 += score(data, zpos, Vector{CartesianIndex{2}}())
    end
    return [p1, p2]
end

function score(data::Matrix{Int}, pos::CartesianIndex{2}, goals::Union{Set{CartesianIndex{2}},Vector{CartesianIndex{2}}})
    if data[pos] == 9
        push!(goals, pos)
        return
    end
    for npos ∈ (CartesianIndex(pos.I .+ x) for x ∈ ((1,0), (-1,0), (0,1), (0,-1)))
        !checkbounds(Bool, data, npos) && continue
        if data[pos] + 1 == data[npos]
            score(data, npos, goals)
        end
    end
    data[pos] == 0 && return length(goals)
end

end # module