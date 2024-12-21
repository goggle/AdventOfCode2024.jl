module Day20

using AdventOfCode2024


function day20(input::String = readInput(joinpath(@__DIR__, "..", "data", "day20.txt")))
    data = map(x -> x[1], reduce(vcat, permutedims.(map(x -> split(x, ""), split(input)))))
    tte = time_to_end(data)
    return [count_cheats(tte, 100), count_cheats(tte, 100; max_time=20)]
end

function time_to_end(data::Matrix{Char})
    tte = -1 * ones(Int, size(data)...)
    goal = findall(x -> x == 'E', data)[1]
    current = [goal]
    time = 0
    while !isempty(current)
        for elem ∈ current
            tte[elem] = time
        end
        next = Vector{CartesianIndex{2}}()
        while !isempty(current)
            elem = popfirst!(current)
            for neigh ∈ [elem + x for x ∈ CartesianIndex.((1,-1,0,0), (0,0,1,-1))]
                if data[neigh] != '#' && tte[neigh] == -1
                    push!(next, neigh)
                end
            end
        end
        current = next
        time += 1
    end
    return tte
end

function count_cheats(tte::Matrix{Int}, threshold::Int; max_time::Int=2)
    count = 0
    for c ∈ findall(x -> x >= 0, tte)
        for e ∈ reachable_within(tte, c, max_time)
            time_saved = tte[e] < tte[c] ? tte[c] - tte[e] - sum(abs.((c-e).I)) : -1
            if time_saved >= threshold
                count += 1
            end
        end
    end
    return count
end

function reachable_within(tte::Matrix{Int}, c::CartesianIndex{2}, picoseconds::Int)
    reachable = Set{CartesianIndex{2}}()
    for p ∈ 1:picoseconds
        for i ∈ 0:p
            j = p - i
            for (s1, s2) ∈ zip((1, 1, -1, -1), (1, -1, 1, -1))
                n = CartesianIndex(c[1] + s1*i, c[2] + s2*j)
                if checkbounds(Bool, tte, n) && tte[n] >= 0
                    push!(reachable, n)
                end
            end
        end
    end
    return reachable
end

end # module