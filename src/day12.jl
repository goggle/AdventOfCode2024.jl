module Day12

using AdventOfCode2024

const NEIGHBORS = (
    CartesianIndex(1, 0),
    CartesianIndex(-1, 0),
    CartesianIndex(0, 1),
    CartesianIndex(0, -1)
)

function day12(input::String = readInput(joinpath(@__DIR__, "..", "data", "day12.txt")))
    data = map(x -> x[1], reduce(vcat, permutedims.(map(x -> split(x, ""), split(input)))))
    solve(data)
end

function solve(data)
    p1, p2 = 0, 0
    visited = falses(size(data))
    
    for i in CartesianIndices(data)
        visited[i] && continue
        label = data[i]
        area = 0
        ntouches = 0
        stack = [i]
        sideinds = Set{Tuple{Int,Int,Int}}()
        while !isempty(stack)
            ind = pop!(stack)
            visited[ind] && continue
            visited[ind] = true
            area += 1
            for (offset, d) in zip(NEIGHBORS, 1:4)
                nind = ind + offset
                if !checkbounds(Bool, data, nind)
                    push!(sideinds, (nind.I..., d))
                    continue
                end
                if data[nind] == label
                    ntouches += 1
                    if !visited[nind]
                        push!(stack, nind)
                    end
                else
                    push!(sideinds, (nind.I..., d))
                end
            end
        end
        perimeter = 4 * area - ntouches
        p1 += area * perimeter
        p2 += area * calculate_sides(sideinds)
    end
    return [p1, p2]
end

function calculate_sides(sideinds::Set{Tuple{Int,Int,Int}})
    count = 0
    while !isempty(sideinds)
        count += 1
        start = pop!(sideinds)
        stack = [start]
        while !isempty(stack)
            a = pop!(stack)
            adjacents = (
                (a[1] + 1, a[2], a[3]),
                (a[1] - 1, a[2], a[3]),
                (a[1], a[2] + 1, a[3]),
                (a[1], a[2] - 1, a[3]),
            )
            for adj in adjacents
                if adj in sideinds
                    push!(stack, adj)
                    delete!(sideinds, adj)
                end
            end
        end
    end
    return count
end

end # module