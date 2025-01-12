module Day25

using AdventOfCode2024


function day25(input::String = readInput(joinpath(@__DIR__, "..", "data", "day25.txt")))
    locks, keys = parse_input(input)
    total = 0
    for lock ∈ locks
        for key ∈ keys
            if all(lock .+ key .<= 5)
                total += 1
            end
        end
    end
    return total
end

function parse_input(input)
    locks = NTuple{5,Int}[]
    keys = NTuple{5,Int}[]
    for elem ∈ eachsplit(input, "\n\n")
        data = map(x -> x[1], reduce(vcat, permutedims.(map(x -> split(x, ""), split(elem)))))
        if all(data[1, :] .== '#')
            v = Int[]
            for j ∈ axes(data, 2)
                i = 1
                while data[i,j] == '#'
                    i += 1
                end
                push!(v, i - 2)
            end
            push!(locks, Tuple(v))
        elseif all(data[end, :] .== '#')
            v = Int[]
            for j ∈ axes(data, 2)
                i = size(data, 1)
                while data[i,j] == '#'
                    i -= 1
                end
                push!(v, size(data, 1) - i - 1)
            end
            push!(keys, Tuple(v))
        end
    end
    return locks, keys
end

end # module