module Day06

using AdventOfCode2024


function day06(input::String = readInput(joinpath(@__DIR__, "..", "data", "day06.txt")))
    data = map(x -> x[1], reduce(vcat, permutedims.(map(x -> split(x, ""), split(input)))))
    p1, positions = part1(data)
    p2 = part2(data, positions)
    return [p1, p2]
end

function part1(data::Matrix{Char})
    pos = start = findall(x -> x == '^', data)[1]
    dir = (-1, 0)
    positions = Set{CartesianIndex{2}}([pos])
    while true
        npos = CartesianIndex((pos.I .+ dir)...)
        !checkbounds(Bool, data, npos) && break
        if data[npos] == '#'
            dir = turn_right(dir)
            continue
        end
        pos = npos
        push!(positions, pos)
    end
    return length(positions), delete!(positions, start)
end

function part2(data::Matrix{Char}, positions::Set{CartesianIndex{2}})
    start = findall(x -> x == '^', data)[1]
    graph = build_graph(data)
    ncircles = 0

    for obstacle ∈ positions
        obsx = obstacle[1]
        obsy = obstacle[2]
        pgraph = build_priority_graph(graph, data, CartesianIndex(obsx, obsy))
        data[obsx, obsy] = '#'

        seen = Set{Tuple{Int,Int,Int}}()
        x = start[1]
        y = start[2]
        d = 1
        iscircle = false
        pgraphused = false
        while true
            x, y, d, cont, frompgraph = next(data, graph, pgraph, x, y, d)
            if !pgraphused && frompgraph
                pgraphused = true
            end
            if pgraphused && (x, y, d) ∈ seen
                iscircle = true
                break
            end
            !cont && break
            push!(seen, (x, y, d))
        end

        data[obsx, obsy] = '.'
        if iscircle
            ncircles += 1
        end
    end
    return ncircles
end

function next(data::Matrix{Char}, graph::Dict{Tuple{Int,Int,Int},Tuple{Int,Int,Int,Bool}}, pgraph::Dict{Tuple{Int,Int,Int},Tuple{Int,Int,Int,Bool}}, x::Int, y::Int, d::Int)
    if haskey(pgraph, (x, y, d))
        return (pgraph[(x, y, d)]..., true)
    elseif haskey(graph, (x, y, d))
        return (graph[(x, y, d)]..., false)
    else
        out, pos = walk(data, CartesianIndex(x, y), number_to_dir(d))
        return pos[1], pos[2], d, !out, false
    end
end

function walk(data::Matrix{Char}, pos::CartesianIndex{2}, dir::Tuple{Int,Int})
    while true
        npos = CartesianIndex((pos.I .+ dir)...)
        !checkbounds(Bool, data, npos) && return true, pos
        if data[npos] == '#'
            return false, pos
        end
        pos = npos
    end
end

function build_graph(data::Matrix{Char})
    graph = Dict{Tuple{Int,Int,Int},Tuple{Int,Int,Int,Bool}}()
    obstacles = findall(x -> x == '#', data)
    for obs ∈ obstacles
        _add_obstacle_to_graph!(graph, data, obs)
    end
    return graph
end

function _add_obstacle_to_graph!(graph::Dict{Tuple{Int,Int,Int},Tuple{Int,Int,Int,Bool}}, data::Matrix{Char}, obs::CartesianIndex{2})
    for d ∈ 1:4
        pos = CartesianIndex((obs.I .+ number_to_dir(d))...)
        if checkbounds(Bool, data, pos)
            confrontdir = opposite(d)
            walkingdir = turn_right(confrontdir)
            out, nextpos = walk(data, pos, number_to_dir(walkingdir))
            graph[(pos[1], pos[2], confrontdir)] = (nextpos[1], nextpos[2], walkingdir, !out)
        end
    end
end

function build_priority_graph(graph::Dict{Tuple{Int,Int,Int},Tuple{Int,Int,Int,Bool}}, data::Matrix{Char}, obs::CartesianIndex{2})
    pgraph = Dict{Tuple{Int,Int,Int},Tuple{Int,Int,Int,Bool}}()
    _add_obstacle_to_graph!(pgraph, data, obs)

    positions = [CartesianIndex((obs.I .+ number_to_dir(d))...) for d ∈ 1:4]
    for (key, value) ∈ graph
        minmaxx = minmax(key[1], value[1])
        minmaxy = minmax(key[2], value[2])
        for d ∈ 1:4
            if key[3] == turn_right(d) && positions[d][1] ∈ minmaxx[1]:minmaxx[2] && positions[d][2] ∈ minmaxy[1]:minmaxy[2] && checkbounds(Bool, data, positions[d])
                pgraph[key] = (positions[d][1], positions[d][2], opposite(d), true)
            end
        end
    end
    
    return pgraph
end

turn_right(dir::Tuple{Int,Int}) = [0 1 ; -1 0] * collect(dir) |> Tuple
turn_right(n::Int) = mod1(n + 1, 4)

function dir_to_number(dir::Tuple{Int,Int})
    dir[1] == -1 && dir[2] == 0 && return 1
    dir[1] == 0 && dir[2] == 1 && return 2
    dir[1] == 1 && dir[2] == 0 && return 3
    dir[1] == 0 && dir[2] == -1 && return 4
end

function number_to_dir(n::Int)
    n == 1 && return (-1, 0)
    n == 2 && return (0, 1)
    n == 3 && return (1, 0)
    n == 4 && return (0, -1)
end

function opposite(n::Int)
    n == 1 && return 3
    n == 2 && return 4
    n == 3 && return 1
    n == 4 && return 2
end

end # module