module Day15

using AdventOfCode2024


function day15(input::String = readInput(joinpath(@__DIR__, "..", "data", "day15.txt")))
    world, instructions = parse_input(input)
    part1(world, instructions)
end

function parse_input(input)
    wo, ins = split(input, "\n\n")
    return map(x -> x[1], reduce(vcat, permutedims.(map(x -> split(x, ""), split(wo))))), rstrip(ins)
end

function part1(world, instructions)
    start = findall(x -> x == '@', world)[1]
    world[start] = '.'
end

end # module