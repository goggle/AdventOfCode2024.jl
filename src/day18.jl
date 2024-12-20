module Day18

using AdventOfCode2024


function day18(input::String = readInput(joinpath(@__DIR__, "..", "data", "day18.txt")))
    data = [parse.(Int, split(x, ",")) for x ∈ split(rstrip(input), "\n")]
    p1 = reachable(data, 1024)[2]
    p2 = part2(data)
    return [p1, p2]
end

function part2(data; rindex=1024, height=71, width=71)
    nrindex = length(data)
    while nrindex - rindex != 1
        mindex = (rindex + nrindex) ÷ 2
        if reachable(data, mindex; height=height, width=width)[1]
            rindex = mindex
        else
            nrindex = mindex
        end
    end
    return join(data[nrindex], ",")
end

function reachable(data, nbytes; height=71, width=71)
    board = Matrix{Char}(undef, height, width)
    for i ∈ eachindex(board)
        board[i] = '.'
    end
    for i ∈ 1:nbytes
        y, x = data[i]
        board[x+1, y+1] = '#'
    end

    nsteps = 0
    candids = Set{CartesianIndex{2}}([CartesianIndex(1,1)])
    goal = CartesianIndex(height, width)
    while true
        isempty(candids) && return false, -1
        for elem ∈ candids
            if elem == goal
                return true, nsteps
            end
            board[elem] = 'O'
        end
        new_candids = Set{CartesianIndex{2}}()
        while !isempty(candids)
            current = pop!(candids)
            neighbours = [CartesianIndex(current.I .+ x) for x ∈ ((1, 0), (-1, 0), (0, 1), (0, -1))]
            for neighb ∈ neighbours
                if checkbounds(Bool, board, neighb) && board[neighb] == '.'
                    push!(new_candids, neighb)
                end
            end
        end
        candids = new_candids
        nsteps += 1
    end
end

end # module