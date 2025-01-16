module Day07

using AdventOfCode2024


function day07(input::String = readInput(joinpath(@__DIR__, "..", "data", "day07.txt")))
    test_values, numbers = parse_input(input)
    solve(test_values, numbers)
end

function parse_input(input)
    data = [(x, y) for (x, y) ∈ eachsplit.(eachsplit(rstrip(input), '\n'), ':')]
    test_values = [parse(Int, x[1]) for x ∈ data]
    numbers = [parse.(Int, split(lstrip(x[2]))) for x ∈ data]
    return test_values, numbers
end

function solve(test_values::Vector{Int}, numbers::Vector{Vector{Int}})
    p1 = p2 = 0
    for (test_value, nl) ∈ zip(test_values, numbers)
        if valid_p1(test_value, nl[1], @view nl[2:end])
            p1 += test_value
            p2 += test_value
        elseif valid_p2(test_value, nl[1], @view nl[2:end])
            p2 += test_value
        end
    end
    return [p1, p2]
end

function valid_p1(goal::Int, curr::Int, remaining::AbstractArray{Int})
    isempty(remaining) && curr != goal && return false
    curr > goal && return false
    curr == goal && isempty(remaining) && return true
    return valid_p1(goal, curr + remaining[1], @view remaining[2:end]) || valid_p1(goal, curr * remaining[1], @view remaining[2:end])
end

function valid_p2(goal::Int, curr::Int, remaining::AbstractArray{Int})
    isempty(remaining) && curr != goal && return false
    curr > goal && return false
    curr == goal && isempty(remaining) && return true
    return valid_p2(goal, curr + remaining[1], @view remaining[2:end]) || valid_p2(goal, curr * remaining[1], @view remaining[2:end]) || valid_p2(goal, concat(curr, remaining[1]), @view remaining[2:end])
end

concat(x::Int, y::Int) = x * 10^(length(digits(y))) + y

end # module