module Day01

using AdventOfCode2024


function day01(input::String = readInput(joinpath(@__DIR__, "..", "data", "day01.txt")))
    data = [parse.(Int, x) for x ∈ eachsplit(rstrip(input))]
    left = data[1:2:end]
    right = data[2:2:end]
    p1 = abs.(sort(left) - sort(right)) |> sum
    p2 = sum(elem * sum(right .== elem) for elem ∈ left)
    return [p1, p2]
end

end # module