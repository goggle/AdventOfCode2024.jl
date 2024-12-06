module Day06

using AdventOfCode2024


function day06(input::String = readInput(joinpath(@__DIR__, "..", "data", "day06.txt")))
    data = map(x -> x[1], reduce(vcat, permutedims.(map(x -> split(x, ""), split(input)))))
    p1, positions = part1(data)
    p2 = part2(data, positions)
    # build_graph(data)
    # part2(data, positions)
    return [p1, p2]
end

function part1(data)
    pos = start = findall(x -> x == '^', data)[1]
    dir = [-1, 0]
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

turn_right(dir::Vector{Int}) = [0 1 ; -1 0] * dir

function part2(data, positions)
    p2 = 0
    for pos ∈ positions
        if check_loop(data, pos)
            p2 += 1
        end
    end
    return p2
end

function check_loop(data, obspos)
    # println("check_loop: $obspos")
    pos = findall(x -> x == '^', data)[1]
    dir = [-1, 0]
    posdirs = Set([NTuple{4,Int}((pos.I..., dir...))])
    while true
        npos = CartesianIndex((pos.I .+ dir)...)
        !checkbounds(Bool, data, npos) && return false
        if data[npos] == '#' || npos == obspos
            dir = turn_right(dir)
            continue
        end
        pos = npos
        pd = NTuple{4,Int}([pos.I..., dir...])
        pd ∈ posdirs && return true
        push!(posdirs, pd)
    end
end

# function part2(data, positions)
#     p2 = 0
#     spos = findall(x -> x == '^', data)[1]
#     # graph = Dict{CartesianIndex{2},Union{CartesianIndex{2},Nothing}}()
#     # update_graph!(graph, data, findall(x -> x == '#', data))
#     graph = build_graph(data)
#     # return data, graph
#     # return graph
#     # return graph
#     # println(length(positions))
#     for pos ∈ positions
#         # update_graph!(graph, data, [pos])
#         data[pos] = '#'
#         graph = build_graph(data)
#         if check_loop(data, spos, graph)
#             p2 += 1
#             println(p2)
#         end
#         data[pos] = '.'
#         # break
#         # remove_obstacle!(graph, pos)
#     end
#     return p2
# end

# function check_loop(data, spos, graph)
#     pos = spos
#     while true
#         haskey(graph, pos) && break
#         pos = CartesianIndex(pos.I .+ (-1, 0))
#         # !checkbounds(Bool, data, pos) && return false
#     end
#     loop = Set{CartesianIndex{2}}([pos])
#     while true
#         pos = graph[pos]
#         isnothing(pos) && return false
#         pos ∈ loop && return true
#         push!(loop, pos)
#     end
# end

# function build_graph(data)
#     graph = Dict{CartesianIndex{2},Union{CartesianIndex{2},Nothing}}()
#     obstacles = findall(x -> x == '#', data)
#     instructions = [((1, 0), (0, 1)), ((-1, 0), (0, -1)), ((0, 1), (-1, 0)), ((0, -1), (1, 0))]
#     for obs ∈ obstacles
#         for (off, dir) ∈ instructions
#             start = pos = CartesianIndex(obs.I .+ off)
#             !checkbounds(Bool, data, pos) && continue
#             while true
#                 pos = CartesianIndex(pos.I .+ dir)
#                 if !checkbounds(Bool, data, pos)
#                     graph[start] = nothing
#                     break
#                 elseif data[pos] == '#'
#                     # special case:
#                     if start == CartesianIndex(pos.I .- dir)
#                         pos = CartesianIndex(pos.I .- dir)
#                         dir = Tuple(turn_right([dir...]))
#                         continue
#                     end
#                     graph[start] = CartesianIndex(pos.I .- dir)
#                     break
#                 end
#             end
#         end
#     end
#     return graph
# end

# function remove_obstacle!(graph, pos)
#     for off ∈ ((1, 0), (-1, 0), (0, 1), (0, -1))
#         pos = CartesianIndex(pos.I .+ off)
#         if haskey(graph, pos)
#             delete!(graph, pos)
#         end
#     end
# end

end # module