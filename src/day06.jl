module Day06

using AdventOfCode2024


function day06(input::String = readInput(joinpath(@__DIR__, "..", "data", "day06.txt")))
    data = stack(split(rstrip(input), '\n'), dims=1)
    H, W = size(data)
    p1, positions = part1(data, H, W)
    p2 = part2(data, H, W, positions)
    return [p1, p2]
end

function part1(data::Matrix{Char}, H::Int, W::Int)
    pos = start = findall(x -> x == '^', data)[1]
    d = 1
    positions = falses(size(data))
    positions[start] = true
    while true
        npos = CartesianIndex((pos.I .+ DIRS[d])...)
        (npos[1] < 1 || npos[1] > H || npos[2] < 1 || npos[2] > W) && break
        if data[npos] == '#'
            d = turn_right(d)
            continue
        end
        pos = npos
        positions[pos] = true
    end
    positions[start] = false
    return sum(positions), positions
end

function part2(data::Matrix{Char}, H::Int, W::Int, positions::BitMatrix)
    start = findall(x -> x == '^', data)[1]
    graph = build_graph(data, H, W)
    _, firstpos = walk(data, H, W, start, 1)
    graph[(start[1], start[2], 1)] = (firstpos[1], firstpos[2], 1, true)
    ncircles = 0

    for obstacle ∈ findall(x -> x == true, positions)
        pgraph = build_priority_graph(graph, data, H, W, CartesianIndex(obstacle[1], obstacle[2]))
        data[obstacle[1], obstacle[2]] = '#'

        seen = falses(H, W, 4)
        x = start[1]
        y = start[2]
        d = 1
        iscircle = false
        pgraphused = false
        while true
            x, y, d, cont, frompgraph = next(graph, pgraph, x, y, d)
            if !pgraphused && frompgraph
                pgraphused = true
            end
            if pgraphused && seen[x, y, d]
                iscircle = true
                break
            end
            !cont && break
            seen[x, y, d] = true
        end

        data[obstacle[1], obstacle[2]] = '.'
        if iscircle
            ncircles += 1
        end
    end
    return ncircles
end

function next(graph::Dict{Tuple{Int,Int,Int},Tuple{Int,Int,Int,Bool}}, pgraph::Dict{Tuple{Int,Int,Int},Tuple{Int,Int,Int,Bool}}, x::Int, y::Int, d::Int)
    if haskey(pgraph, (x, y, d))
        return (pgraph[(x, y, d)]..., true)
    elseif haskey(graph, (x, y, d))
        return (graph[(x, y, d)]..., false)
    end
end

function walk(data::Matrix{Char}, H::Int, W::Int, pos::CartesianIndex{2}, dir::Int)
    while true
        npos = CartesianIndex((pos.I .+ DIRS[dir])...)
        (npos[1] < 1 || npos[1] > H || npos[2] < 1 || npos[2] > W) && return true, pos
        if data[npos] == '#'
            return false, pos
        end
        pos = npos
    end
end

function build_graph(data::Matrix{Char}, H::Int, W::Int)
    graph = Dict{Tuple{Int,Int,Int},Tuple{Int,Int,Int,Bool}}()
    obstacles = findall(x -> x == '#', data)
    for obs ∈ obstacles
        _add_obstacle_to_graph!(graph, data, H, W, obs)
    end
    return graph
end

function _add_obstacle_to_graph!(graph::Dict{Tuple{Int,Int,Int},Tuple{Int,Int,Int,Bool}}, data::Matrix{Char}, H::Int, W::Int, obs::CartesianIndex{2})
    for d ∈ 1:4
        pos = CartesianIndex((obs.I .+ DIRS[d])...)
        if 1 <= pos[1] <= H && 1 <= pos[2] <= W
            confrontdir = opposite(d)
            walkingdir = turn_right(confrontdir)
            out, nextpos = walk(data, H, W, pos, walkingdir)
            graph[(pos[1], pos[2], confrontdir)] = (nextpos[1], nextpos[2], walkingdir, !out)
        end
    end
end

function build_priority_graph(graph::Dict{Tuple{Int,Int,Int},Tuple{Int,Int,Int,Bool}}, data::Matrix{Char}, H::Int, W::Int, obs::CartesianIndex{2})
    pgraph = Dict{Tuple{Int,Int,Int},Tuple{Int,Int,Int,Bool}}()
    _add_obstacle_to_graph!(pgraph, data, H, W, obs)

    positions = [CartesianIndex((obs.I .+ DIRS[d])...) for d ∈ 1:4]
    for (key, value) ∈ graph
        minmaxx = minmax(key[1], value[1])
        minmaxy = minmax(key[2], value[2])
        for d ∈ 1:4
            if key[3] == turn_right(d) && positions[d][1] ∈ minmaxx[1]:minmaxx[2] && positions[d][2] ∈ minmaxy[1]:minmaxy[2] && 1 <= positions[d][1] <= H && 1 <= positions[d][2] <= W
                pgraph[key] = (positions[d][1], positions[d][2], opposite(d), true)
            end
        end
    end
    
    return pgraph
end

const DIRS = [(-1,0), (0,1), (1,0), (0,-1)]  # N, E, S, W
turn_right(d::Int) = mod1(d+1, 4)
turn_left(d::Int) = mod1(d-1, 4)
opposite(d::Int) = mod1(d+2, 4)

end # module