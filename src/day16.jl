module Day16

using AdventOfCode2024
using DataStructures


function day16(input::String = readInput(joinpath(@__DIR__, "..", "data", "day16.txt")))
    data = map(x -> x[1], reduce(vcat, permutedims.(map(x -> split(x, ""), split(input)))))
    startpos = findall(x -> x == 'S', data)[1]

    dist, prev = dijkstra(data, startpos)
    endpos = findall(x -> x == 'E', data)[1]
    p1 = minimum(dist[endpos.I..., i] for i ∈ 1:4)

    startpos = findall(x -> x == 'S', data)[1]
    endpositions = Tuple{Int,Int,Int}[]
    for i ∈ 1:4
        if dist[endpos.I..., i] == p1
            push!(endpositions, (endpos.I..., i))
        end
    end
    p2 = part2(startpos, endpositions, prev, size(data)...)
    return [p1, p2]
end

function dijkstra(data, startpos)
    dist = Dict{Tuple{Int,Int,Int},Int}()
    dist[startpos.I..., 2] = 0
    pq = PriorityQueue{Tuple{Int,Int,Int},Int}()
    prev = Dict{Tuple{Int,Int,Int},Vector{Tuple{Int,Int,Int}}}()
    for position ∈ findall(x -> x ∈ ('.', 'E', 'S'), data)
        for i ∈ 1:4
            v = (position.I..., i)
            prev[v] = []
            dist[v] = typemax(Int)
            pq[v] = typemax(Int)
        end
    end
    dist[startpos.I..., 2] = 0
    pq[startpos.I..., 2] = 0

    while !isempty(pq)
        u = dequeue!(pq)
        ncandids = (((u[1:2] .+ _number_to_dir(u[3]))..., u[3]), (u[1], u[2], mod1(u[3] + 1, 4)), (u[1], u[2], mod1(u[3] - 1, 4)))
        nscores = (1, 1000, 1000)
        neighbours = [(x, cost) for (x, cost) ∈ zip(ncandids, nscores) if data[x[1:2]...] != '#']
        for (v, cost) ∈ neighbours
            alt = dist[u] + cost
            if alt <= dist[v]
                if alt < dist[v]
                    prev[v] = []
                end
                push!(prev[v], u)
                dist[v] = alt
                pq[v] = alt
            end
        end
    end
    return dist, prev
end

function part2(startpos::CartesianIndex{2}, queue::Vector{Tuple{Int,Int,Int}}, prev::Dict{Tuple{Int,Int,Int},Vector{Tuple{Int,Int,Int}}}, nrows::Int, ncols::Int)
    visited = zeros(Bool, nrows, ncols)
    while !isempty(queue)
        elem = popfirst!(queue)
        visited[elem[1:2]...] = true
        for p ∈ prev[elem]
            if p ∉ queue
                push!(queue, p)
            end
        end
    end
    return sum(visited)
end

function _number_to_dir(n)
    n == 1 && return [-1, 0]
    n == 2 && return [0, 1]
    n == 3 && return [1, 0]
    n == 4 && return [0, -1]
end

end # module