module Day11

using AdventOfCode2024

function day11(input::String = readInput(joinpath(@__DIR__, "..", "data", "day11.txt")))
    data = parse.(Int, split(rstrip(input)))
    return [solve(data, 25), solve(data, 75)]
end

function solve(data, runtime)
    lookup = Dict{Int,Tuple{Int,Int}}()
    lookup[0] = (1, -1)
    stones = Dict{Int,Dict{Int,Int}}()
    for i ∈ 0:runtime
        stones[i] = Dict{Int,Int}()
    end
    for value ∈ data
        stones[runtime][value] = 1
    end
    @inbounds for rt ∈ runtime:-1:1
        for stone ∈ keys(stones[rt])
            if haskey(lookup, stone)
                l, r = lookup[stone]
            else
                if iseven(length(digits(stone)))
                    l, r = split_number(stone)
                else
                    l, r = stone * 2024, -1
                end
                lookup[stone] = (l, r)
            end
            amount = stones[rt][stone]
            if haskey(stones[rt-1], l)
                stones[rt-1][l] += amount
            else
                stones[rt-1][l] = amount
            end
            r == -1 && continue
            if haskey(stones[rt-1], r)
                stones[rt-1][r] += amount
            else
                stones[rt-1][r] = amount
            end
        end
    end
    return stones[0] |> values |> sum

end

function split_number(number::Int)
    digs = digits(number)
    n = length(digs)
    l = @view(digs[n÷2+1:end]) .* [10^x for x ∈ 0:n÷2-1] |> sum
    r = @view(digs[1:n÷2]) .* [10^x for x ∈ 0:n÷2-1] |> sum
    return l, r
end

end # module
