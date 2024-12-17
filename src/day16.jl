module Day16

using AdventOfCode2024
using DataStructures


function day16(input::String = readInput(joinpath(@__DIR__, "..", "data", "day16.txt")))
    data = map(x -> x[1], reduce(vcat, permutedims.(map(x -> split(x, ""), split(input)))))
    part1(data)
end

function p1(data)
    startpos = findall(x -> x == 'S', data)[1]
    startdir = [0, 1]
    endpos = findall(x -> x == 'E', data)[1]
    dist = Dict{Tuple{Int,Int,Int},Int}()
    dist[startpos.I..., 2] = 0
    pq = PriorityQueue{Tuple{Int,Int,Int},Int}()
    pq[startpos.I..., 2] = 0
    prev = Dict{Tuple{Int,Int,Int},Tuple{Int,Int,Int}}()
    for position ∈ findall(x -> x ∈ ('.', 'E', 'S'), data)
        for i ∈ 1:4
            v = (position.I..., i)
            if v != (startpos.I..., 2)
                prev[v] = (0, 0, 0)
                dist[v] = typemax(Int)
                pq[v] = typemax(Int)
            end
        end
    end

    while !isempty(pq)
        u = dequeue!(pq)
        ncandids = (((u[1:2] .+ _number_to_dir(u[3]))..., u[3]), (u[1], u[2], mod1(u[3] + 1, 4)), (u[1], u[2], mod1(u[3] - 1, 4)))
        neighbours = [x for x ∈ ncandids if data[x[1:2]...] != '#']
    end

end

function part1(data)
    startpos = findall(x -> x == 'S', data)[1]
    startdir = [0, 1]
    endpos = findall(x -> x == 'E', data)[1]
    println(endpos)
    minscore = Dict{Tuple{Int,Int,Int},Int}()
    # minscore[startpos.I..., _dir_to_number(startdir...)] = 0
    walk!(minscore, data, 0, startpos, startdir, endpos)
    candids = [minscore[endpos.I..., i] for i ∈ 1:4 if haskey(minscore, (endpos.I..., i))]
    return minimum(candids)
end

function walk!(minscore::Dict{Tuple{Int,Int,Int},Int}, data::Matrix{Char}, score::Int, pos::CartesianIndex{2}, dir::Vector{Int}, endpos::CartesianIndex{2})
    score > minimum([minscore[endpos.I..., i] for i ∈ 1:4 if haskey(minscore, (endpos.I..., i))]; init=Inf) && return
    data[pos] == '#' && return
    if !haskey(minscore, (pos.I..., _dir_to_number(dir...)))
        minscore[pos.I..., _dir_to_number(dir...)] = score
    elseif minscore[pos.I..., _dir_to_number(dir...)] > score
        minscore[pos.I..., _dir_to_number(dir...)] = score
    else
        return
    end
    pos == endpos && return
    walk!(minscore, data, score + 1, CartesianIndex((pos.I .+ dir)...), dir, endpos)
    if data[(pos.I .+ _turn_left(dir...))...] != '#'
        walk!(minscore, data, score + 1000, pos, _turn_left(dir...), endpos)
    end
    if data[(pos.I .+ _turn_right(dir...))...] != '#'
        walk!(minscore, data, score + 1000, pos, _turn_right(dir...), endpos)
    end
    # walk!(minscore, data, score + 1000, pos, _turn_left(dir...), endpos)
    # walk!(minscore, data, score + 1000, pos, _turn_right(dir...), endpos)
end

function _dir_to_number(x, y)
    x == -1 && return 1
    y == 1 && return 2
    x == 1 && return 3
    y == -1 && return 4
end

function _number_to_dir(n)
    n == 1 && return [-1, 0]
    n == 2 && return [0, 1]
    n == 3 && return [1, 0]
    n == 4 && return [0, -1]
end

_turn_left(x, y) = [0 -1; 1 0] * [x, y]
_turn_right(x, y) = [0 1; -1 0] * [x, y]

end # module