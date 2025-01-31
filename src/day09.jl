module Day09

using AdventOfCode2024
using StaticArrays


function day09(input::String = readInput(joinpath(@__DIR__, "..", "data", "day09.txt")))
    blocks = parse_input(input)
    p1 = part1!(deepcopy(blocks))
    p2 = part2!(blocks)
    return [p1, p2]
end

function parse_input(input)
    digits = parse.(Int, split(rstrip(input), ""))
    if length(digits) % 2 == 1
        push!(digits, 0)
    end

    # start index of block, capacity, used space, original id
    disk = Vector{MVector{4,Int}}()
    current_id = 0
    current_index = 1
    i = 1
    @inbounds while i < length(digits)
        push!(disk, (current_index, digits[i] + digits[i+1], digits[i], current_id))
        current_index += digits[i] + digits[i+1]
        current_id += 1
        i += 2
    end
    return disk
end

function part1!(blocks::Vector{MVector{4,Int}})
    data = generate_disk(blocks)
    i, j = 1, length(blocks)
    @inbounds while i < j
        freeindex = blocks[i][1] + blocks[i][3]
        free = blocks[i][2] - blocks[i][3]
        maxtransfer = blocks[j][3]
        transfer = min(free, maxtransfer)
        @views data[freeindex:freeindex+transfer-1] .= blocks[j][4]
        @views data[blocks[j][1]+blocks[j][3]-transfer:blocks[j][1]+blocks[j][3]-1] .= -1
        blocks[i][3] += transfer
        blocks[j][3] -= transfer
        i += (blocks[i][2] == blocks[i][3])
        j -= (blocks[j][3] == 0)
    end
    return data |> checksum
end

function part2!(blocks::Vector{MVector{4,Int}})
    data = generate_disk(blocks)
    original_usage = [b[3] for b ∈ blocks]
    @inbounds for j ∈ reverse(axes(blocks, 1))
        transfer = original_usage[j]
        for i ∈ 1:j-1
            free = blocks[i][2] - blocks[i][3]
            if free >= transfer
                @views data[blocks[i][1]+blocks[i][3]:blocks[i][1]+blocks[i][3]+transfer-1] .= blocks[j][4]
                @views data[blocks[j][1]:blocks[j][1]+transfer-1] .= -1
                blocks[i][3] += transfer
                blocks[j][3] -= transfer
                break
            end
        end
    end
    return data |> checksum
end

function generate_disk(blocks::Vector{MVector{4,Int}})
    data = -1 * ones(Int, blocks[end][1] + blocks[end][2] - 1)
    for block ∈ blocks
        @views data[block[1]:block[1]+block[3]-1] .= block[4]
    end
    return data
end

function checksum(data::Vector{Int})
    s = 0
    @inbounds for i ∈ eachindex(data)
        if data[i] != -1
            s += data[i] * (i - 1)
        end
    end
    return s
end

end # module