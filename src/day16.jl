module Day16

using AdventOfCode2024
using DataStructures

const DIRS = [(-1, 0), (0, 1), (1, 0), (0, -1)]

function day16(input::String = readInput(joinpath(@__DIR__, "..", "data", "day16.txt")))
    data = stack(split(rstrip(input), '\n')) |> permutedims
    passable = data .!= '#'
    startpos = findfirst(==('S'), data)
    nrows, ncols = size(data)

    dist, prev = dijkstra(passable, startpos, nrows, ncols)
    endpos = findfirst(==('E'), data)
    p1 = minimum(dist[endpos[1], endpos[2], dir] for dir in 1:4)

    # Collect end positions with minimal distance
    endpositions = Tuple{Int,Int,Int}[]
    for dir in 1:4
        if dist[endpos[1], endpos[2], dir] == p1
            push!(endpositions, (endpos[1], endpos[2], dir))
        end
    end

    visited = bfs_trace(prev, endpositions, nrows, ncols)
    return [p1, sum(visited)]
end

function dijkstra(passable::BitMatrix, startpos::CartesianIndex{2}, nrows::Int, ncols::Int)
    dist = fill(typemax(Int), nrows, ncols, 4)
    prev = [Tuple{Int,Int,Int}[] for _ in 1:nrows, _ in 1:ncols, _ in 1:4]
    pq = PriorityQueue{Tuple{Int,Int,Int},Int}()

    start_dir = 2
    dist[startpos[1], startpos[2], start_dir] = 0
    pq[(startpos[1], startpos[2], start_dir)] = 0

    while !isempty(pq)
        (i, j, dir), cost = peek(pq)
        dequeue!(pq)
        cost > dist[i, j, dir] && continue

        di, dj = DIRS[dir]
        ni, nj = i + di, j + dj
        if checkbounds(Bool, passable, ni, nj) && passable[ni, nj]
            new_cost = cost + 1
            if new_cost < dist[ni, nj, dir]
                dist[ni, nj, dir] = new_cost
                prev[ni, nj, dir] = [(i, j, dir)]
                pq[(ni, nj, dir)] = new_cost
            elseif new_cost == dist[ni, nj, dir]
                push!(prev[ni, nj, dir], (i, j, dir))
            end
        end

        for new_dir in (mod1(dir + 1, 4), mod1(dir - 1, 4))
            new_cost = cost + 1000
            if new_cost < dist[i, j, new_dir]
                dist[i, j, new_dir] = new_cost
                prev[i, j, new_dir] = [(i, j, dir)]
                pq[(i, j, new_dir)] = new_cost
            elseif new_cost == dist[i, j, new_dir]
                push!(prev[i, j, new_dir], (i, j, dir))
            end
        end
    end

    return dist, prev
end

function bfs_trace(prev::Array{Vector{Tuple{Int,Int,Int}},3}, endpositions::Vector{Tuple{Int,Int,Int}}, nrows::Int, ncols::Int)
    visited = falses(nrows, ncols)
    queue = Deque{Tuple{Int,Int,Int}}()
    enqueued = falses(nrows, ncols, 4)

    # Initialize only with minimal distance end positions
    for pos in endpositions
        if !isempty(prev[pos...])
            push!(queue, pos)
            enqueued[pos...] = true
        end
    end

    while !isempty(queue)
        elem = popfirst!(queue)
        i, j, _ = elem
        visited[i, j] = true

        for p in prev[elem...]
            if !enqueued[p...]
                enqueued[p...] = true
                push!(queue, p)
            end
        end
    end

    return visited
end

end # module