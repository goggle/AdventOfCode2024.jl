module Day12

using AdventOfCode2024


function day12(input::String = readInput(joinpath(@__DIR__, "..", "data", "day12.txt")))
    data = map(x -> x[1], reduce(vcat, permutedims.(map(x -> split(x, ""), split(input)))))
    solve(data)
end

function solve(data)
    p1, p2 = 0, 0
    visited = zeros(Bool, size(data))
    
    for i ∈ eachindex(view(data, 1:size(data, 1), 1:size(data, 2)))
        visited[i] && continue
        label = data[i]
        area = 0
        ntouches = 0
        queue = [i]
        sideinds = Set{Tuple{Int,Int,Int}}()
        while !isempty(queue)
            ind = popfirst!(queue)
            visited[ind] && continue
            area += 1
            visited[ind] = true
            for (nind, d) ∈ zip(CartesianIndex.(ind.I .+ x for x ∈ ((1, 0), (-1, 0), (0, 1), (0, -1))), (1,2,3,4))
                if !checkbounds(Bool, data, nind)
                    push!(sideinds, (nind.I..., d))
                    continue
                end
                if data[nind] == label
                    ntouches += 1
                    if !visited[nind]
                        push!(queue, nind)
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
        queue = Tuple{Int,Int,Int}[first(sideinds)]
        while !isempty(queue)
            a = popfirst!(queue)
            delete!(sideinds, a)
            for b ∈ sideinds
                if a[3] == b[3] && sum(abs.(a[1:2] .- b[1:2])) == 1
                    push!(queue, b)
                end
            end
        end
    end
    return count
end

end # module