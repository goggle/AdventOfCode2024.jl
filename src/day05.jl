module Day05

using AdventOfCode2024


function day05(input::String = readInput(joinpath(@__DIR__, "..", "data", "day05.txt")))
    rules, numbers = parse_input(input)
    solve(rules, numbers)
end

function parse_input(input)
    rstr, nstr = split(input, "\n\n")
    rs = [Tuple(parse.(Int, split(x, '|'))) for x in eachsplit(rstr)]
    rules = Dict{Int,Vector{Int}}()
    for (l, r) ∈ rs
        if !haskey(rules, l)
            rules[l] = [r]
        else
            push!(rules[l], r)
        end
    end
    numbers = [parse.(Int, split(x, ',')) for x in eachsplit(nstr)]
    return rules, numbers
end

function solve(rules::Dict{Int,Vector{Int}}, numbers::Vector{Vector{Int}})
    p1, p2 = 0, 0
    for nvec ∈ numbers
        if valid(rules, nvec)
            p1 += nvec[(1 + length(nvec) ÷ 2)]
        else
            p2 += correct(rules, nvec)
        end
    end
    return [p1, p2]
end

function valid(rules::Dict{Int,Vector{Int}}, numbers::Vector{Int})
    for i ∈ eachindex(numbers)
        for j ∈ 1:i-1
            haskey(rules, numbers[i]) && numbers[j] ∈ rules[numbers[i]] && return false
        end
    end
    return true
end

function correct(rules::Dict{Int,Vector{Int}}, numbers::Vector{Int})
    cont = true
    while cont
        cont = false
        for i ∈ eachindex(numbers)
            for j ∈ 1:i-1
                if haskey(rules, numbers[i]) && numbers[j] ∈ rules[numbers[i]]
                    numbers[i], numbers[j] = numbers[j], numbers[i]
                    cont = true
                end
            end
        end
    end
    return numbers[(1 + length(numbers)) ÷ 2]
end


end # module