module Day11

using AdventOfCode2024

function day11(input::String = readInput(joinpath(@__DIR__, "..", "data", "day11.txt")))
    data = parse.(Int, split(rstrip(input)))
    runtime1 = 25
    runtime2 = 75
    
    lookup = Dict{Int,Tuple{Int,Int}}()
    lookup[0] = (1, -1)
    
    stones = Vector{Vector{Pair{Int,Int}}}(undef, runtime2 + 1)
    for i in 0:runtime2
        stones[i+1] = Pair{Int,Int}[]
    end
    
    result1 = compute_stones!(stones, data, runtime1, lookup)
    result2 = continue_stones!(stones, runtime1, runtime2, lookup)
    
    return [result1, result2]
end

function compute_stones!(stones, data, runtime, lookup)
    # Initialize with input data
    counts = Dict{Int,Int}()
    for value in data
        counts[value] = get!(counts, value, 0) + 1
    end
    stones[runtime+1] = [k => v for (k, v) in counts]
    
    @inbounds for rt in runtime:-1:1
        current = stones[rt+1]
        next = stones[rt]
        empty!(next)
        for (stone, amount) in current
            l, r = get_transformation(stone, lookup)
            push!(next, l => amount)
            r != -1 && push!(next, r => amount)
        end
        stones[rt] = merge_pairs!(next)
    end
    
    return sum(last, stones[1])
end

function continue_stones!(stones, start_runtime, target_runtime, lookup)
    remaining = target_runtime - start_runtime
    stones[remaining+1] = copy(stones[1])
    for i in 1:remaining
        empty!(stones[i])
    end
    
    @inbounds for rt in remaining:-1:1
        current = stones[rt+1]
        next = stones[rt]
        empty!(next)
        for (stone, amount) in current
            l, r = get_transformation(stone, lookup)
            push!(next, l => amount)
            r != -1 && push!(next, r => amount)
        end
        stones[rt] = merge_pairs!(next)
    end
    
    return sum(last, stones[1])
end

# Custom function to merge duplicate keys in a Vector{Pair}
function merge_pairs!(pairs::Vector{Pair{Int,Int}})
    isempty(pairs) && return pairs
    sort!(pairs, by=first)  # Sort by stone value
    result = Pair{Int,Int}[]
    current_stone, current_count = pairs[1].first, pairs[1].second
    for i in 2:length(pairs)
        stone, count = pairs[i].first, pairs[i].second
        if stone == current_stone
            current_count += count
        else
            push!(result, current_stone => current_count)
            current_stone, current_count = stone, count
        end
    end
    push!(result, current_stone => current_count)
    return result
end

@inline function get_transformation(stone, lookup)
    return get!(lookup, stone) do
        if stone == 0
            return (1, -1)
        end
        n = ndigits(stone)
        if iseven(n)
            half = n ÷ 2
            pows = (10^(i-1) for i in 1:half)
            r, l = 0, 0
            s = stone
            for p in pows
                d = s % 10
                r += d * p
                s ÷= 10
            end
            for p in pows
                d = s % 10
                l += d * p
                s ÷= 10
            end
            (l, r)
        else
            (stone * 2024, -1)
        end
    end
end

end # module