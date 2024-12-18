module Day16

using AdventOfCode2024
using DataStructures


function day16(input::String = readInput(joinpath(@__DIR__, "..", "data", "day16.txt")))
    data = map(x -> x[1], reduce(vcat, permutedims.(map(x -> split(x, ""), split(input)))))
    # part1(data)
    # p1(data)
    dist, prev = dijkstra(data)
    endpos = findall(x -> x == 'E', data)[1]
    p1 = minimum(dist[endpos.I..., i] for i ∈ 1:4)
    # return prev
    startpos = findall(x -> x == 'S', data)[1]
    endpositions = Tuple{Int,Int,Int}[]
    for i ∈ 1:4
        if dist[endpos.I..., i] == p1
            push!(endpositions, (endpos.I..., i))
        end
    end
    p2 = part2(startpos, endpositions, prev, size(data)...)
    return [p1, p2]
    return p1
end

function dijkstra(data)
    startpos = findall(x -> x == 'S', data)[1]
    # startdir = [0, 1]
    # endpos = findall(x -> x == 'E', data)[1]
    dist = Dict{Tuple{Int,Int,Int},Int}()
    dist[startpos.I..., 2] = 0
    pq = PriorityQueue{Tuple{Int,Int,Int},Int}()
    # pq[startpos.I..., 2] = 0
    prev = Dict{Tuple{Int,Int,Int},Vector{Tuple{Int,Int,Int}}}()
    for position ∈ findall(x -> x ∈ ('.', 'E', 'S'), data)
        for i ∈ 1:4
            v = (position.I..., i)
            # if v != (startpos.I..., 2)
            #     prev[v] = []
            #     dist[v] = typemax(Int)
            #     pq[v] = typemax(Int)
            # end
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
                # prev[v] = u
                # push!(prev[v], u)
                if u ∉ prev[v]
                    push!(prev[v], u)
                end
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
        # println(queue)
        elem = popfirst!(queue)
        visited[elem[1:2]...] = true
        # elem[1:2] == startpos.I && continue
        # !haskey(prev, elem) && continue
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