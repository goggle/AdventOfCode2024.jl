module Day11

using AdventOfCode2024

function day11(input::String = readInput(joinpath(@__DIR__, "..", "data", "day11.txt")))
    data = parse.(Int, split(rstrip(input)))
    runtime1 = 25
    runtime2 = 75
    
    lookup = Dict{Int,Tuple{Int,Int}}()
    lookup[0] = (1, -1)
    
    stones = Vector{Dict{Int,Int}}(undef, runtime2 + 1)
    for i in 0:runtime2
        stones[i+1] = Dict{Int,Int}()
    end
    
    result1 = compute_stones!(stones, data, runtime1, lookup)
    result2 = continue_stones!(stones, runtime1, runtime2, lookup)
    
    return [result1, result2]
end

function compute_stones!(stones, data, runtime, lookup)
    for value in data
        stones[runtime+1][value] = get!(stones[runtime+1], value, 0) + 1
    end
    
    @inbounds for rt in runtime:-1:1
        current = stones[rt+1]
        next = stones[rt]
        for stone in keys(current)
            l, r = get_transformation(stone, lookup)
            amount = current[stone]
            next[l] = get!(next, l, 0) + amount
            r != -1 && (next[r] = get!(next, r, 0) + amount)
        end
    end
    
    return sum(values(stones[1]))
end

function continue_stones!(stones, start_runtime, target_runtime, lookup)
    remaining = target_runtime - start_runtime
    stones[remaining+1] = copy(stones[1])
    # Clear intermediate levels
    for i in 1:remaining
        empty!(stones[i])
    end
    
    @inbounds for rt in remaining:-1:1
        current = stones[rt+1]
        next = stones[rt]
        for stone in keys(current)
            l, r = get_transformation(stone, lookup)
            amount = current[stone]
            next[l] = get!(next, l, 0) + amount
            r != -1 && (next[r] = get!(next, r, 0) + amount)
        end
    end
    
    return sum(values(stones[1]))
end

@inline function get_transformation(stone, lookup)
    return get!(lookup, stone) do
        digs = digits(stone)
        n = length(digs)
        if iseven(n)
            l = sum(@view(digs[n÷2+1:end]) .* [10^x for x ∈ 0:n÷2-1])
            r = sum(@view(digs[1:n÷2]) .* [10^x for x ∈ 0:n÷2-1])
            (l, r)
        else
            (stone * 2024, -1)
        end
    end
end

end # module