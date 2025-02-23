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
    d = 1  # North
    positions = falses(size(data))
    positions[start] = true
    while true
        npos = CartesianIndex((pos.I .+ DIRS[d])...)
        if npos[1] < 1 || npos[1] > H || npos[2] < 1 || npos[2] > W
            break
        end
        if data[npos] == '#'
            d = turn_right(d)
            continue
        end
        pos = npos
        positions[pos] = true
    end
    positions[start] = false
    return sum(positions) + 1, positions
end

function part2(data::Matrix{Char}, H::Int, W::Int, positions::BitMatrix)
    start = findall(x -> x == '^', data)[1]
    ncircles = 0
    for p in findall(positions)
        if simulate_with_obstacle(data, H, W, start, 1, p)
            ncircles += 1
        end
    end
    return ncircles
end

function simulate_with_obstacle(data, H, W, start, d, p)
    pos = start
    seen = falses(H, W, 4)
    while true
        state = (pos[1], pos[2], d)
        if seen[state...]
            return true
        end
        seen[state...] = true
        npos = CartesianIndex((pos.I .+ DIRS[d])...)
        if npos[1] < 1 || npos[1] > H || npos[2] < 1 || npos[2] > W
            return false
        end
        if data[npos] == '#' || npos == p
            d = turn_right(d)
        else
            pos = npos
        end
    end
end

const DIRS = [(-1,0), (0,1), (1,0), (0,-1)]  # N, E, S, W

function turn_right(d::Int)
    return mod1(d + 1, 4)
end

end # module