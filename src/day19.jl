module Day19

using AdventOfCode2024


function day19(input::String = readInput(joinpath(@__DIR__, "..", "data", "day19.txt")))
    towelpatterns, designs = parse_input(input)

    p1, p2 = 0, 0
    lookup = Dict{String,Int}()
    for design ∈ designs
        count = [0]
        checkcount!(count, lookup, towelpatterns, design)
        p2 += count[1]
        if count[1] > 0
            p1 += 1
        end
    end
    return [p1, p2]
end

function parse_input(input)
    top, bottom = split(input, "\n\n")
    towelpatterns = string.(split(top, ", "))
    designs = string.(split(rstrip(bottom), "\n"))
    return towelpatterns, designs
end

function checkcount!(count::Vector{Int}, lookup::Dict{String,Int}, towelpatterns::Vector{String}, design::String)
    if isempty(design)
        count[1] += 1
        return
    end
    for x ∈ towelpatterns
        if startswith(design, x)
            leftoverdesign = design[length(x)+1:end]
            if haskey(lookup, leftoverdesign)
                count[1] += lookup[leftoverdesign]
            else
                count_before = count[1]
                checkcount!(count, lookup, towelpatterns, leftoverdesign)
                lookup[leftoverdesign] = count[1] - count_before
            end
        end
    end
end

end # module