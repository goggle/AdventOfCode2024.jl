module Day07

using AdventOfCode2024

function day07(input::String = readInput(joinpath(@__DIR__, "..", "data", "day07.txt")))
    test_values, numbers, concat_factors = parse_input(input)
    return solve(test_values, numbers, concat_factors)
end

function parse_input(input)
    lines = split(rstrip(input), '\n')
    test_values = Int[]
    numbers = Vector{Int}[]
    concat_factors = Vector{Int}[]
    
    for line ∈ lines
        left, right = split(line, ':')
        nums = parse.(Int, split(right))
        factors = [10^ndigits(n) for n in nums]
        push!(test_values, parse(Int, left))
        push!(numbers, nums)
        push!(concat_factors, factors)
    end
    
    return test_values, numbers, concat_factors
end

function solve(test_values::Vector{Int}, numbers::Vector{Vector{Int}}, concat_factors::Vector{Vector{Int}})
    p1 = p2 = 0
    for i ∈ eachindex(test_values)
        nums = numbers[i]
        valid1 = _valid_p1(test_values[i], nums[1], 2, nums)
        valid2 = valid1 ? true : _valid_p2(test_values[i], nums[1], 2, nums, concat_factors[i])
        p1 += valid1 * test_values[i]
        p2 += (valid1 || valid2) * test_values[i]
    end
    return [p1, p2]
end

@inline function _valid_p1(goal::Int, curr::Int, idx::Int, numbers::Vector{Int})
    idx > length(numbers) && return curr == goal
    curr > goal && return false
    @inbounds next_num = numbers[idx]
    return _valid_p1(goal, curr + next_num, idx + 1, numbers) || 
           _valid_p1(goal, curr * next_num, idx + 1, numbers)
end

@inline function _valid_p2(goal::Int, curr::Int, idx::Int, numbers::Vector{Int}, concat_factors::Vector{Int})
    idx > length(numbers) && return curr == goal
    curr > goal && return false
    @inbounds next_num = numbers[idx]
    @inbounds cf = concat_factors[idx]
    return _valid_p2(goal, curr + next_num, idx + 1, numbers, concat_factors) ||
           _valid_p2(goal, curr * next_num, idx + 1, numbers, concat_factors) ||
           _valid_p2(goal, curr * cf + next_num, idx + 1, numbers, concat_factors)
end

end # module