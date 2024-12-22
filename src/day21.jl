module Day21

using AdventOfCode2024


function day21(input::String = readInput(joinpath(@__DIR__, "..", "data", "day21.txt")))
    numerical_keypad = ['#' '#' '#' '#' '#';
                        '#' '7' '8' '9' '#';
                        '#' '4' '5' '6' '#';
                        '#' '1' '2' '3' '#';
                        '#' '.' '0' 'A' '#';
                        '#' '#' '#' '#' '#']
    directional_keypad = ['#' '#' '#' '#' '#';
                          '#' '.' '^' 'A' '#';
                          '#' '<' 'v' '>' '#';
                          '#' '#' '#' '#' '#']
    layer1 = generate_instructions("029A", numerical_keypad)
    layer2 = reduce(vcat, [generate_instructions(x, directional_keypad) for x ∈ layer1])
end

# function calculate_instructions(keypad::Matrix{Char}, from::Char, to::Char)
#     start = findall(x -> x == from, keypad)[1]
#     goal = findall(x -> x == to, keypad)[1]
#     dirs = (('v', [1, 0]), ('^', [-1, 0]), ('>', [0, 1]), ('<', [0, -1]))
#     visited = zeros(Bool, size(keypad)...)
#     current = [(start, "")]
#     while !isempty(current)
#         for (elem, st) ∈ current
#             if elem == goal
#                 return st
#             end
#             visited[elem] = true
#         end
#         new_current = []
#         while !isempty(current)
#             elem, st = pop!(current)
#             for (c, dir) ∈ dirs
#                 neighcoord = CartesianIndex((elem.I .+ dir)...)
#                 if keypad[neighcoord] != '#' && !visited[neighcoord]
#                     push!(new_current, (neighcoord, st * c))
#                 end
#             end
#         end
#         current = new_current
#     end
# end

function from_to(keypad::Matrix{Char}, from::Char, to::Char)
    start = findall(x -> x == from, keypad)[1]
    goal = findall(x -> x == to, keypad)[1]
    # dirs = (('v', [1, 0]), ('^', [-1, 0]), ('>', [0, 1]), ('<', [0, -1]))

    diff = goal - start
    if diff[1] >= 0
        x = 'v'
    else
        x = '^'
    end
    if diff[2] > 0
        y = '>'
    else
        y = '<'
    end
    return unique([repeat(x, abs(diff[1])) * repeat(y, abs(diff[2])), repeat(y, abs(diff[2])) * repeat(x, abs(diff[1]))])
end

# function code_numerical(code::String, keypad::Matrix{Char})
#     instructions = ""
#     from = 'A'
#     for to ∈ code
#         instructions *= calculate_instructions(keypad, from, to) * 'A'
#         from = to
#     end
#     return instructions
# end

# function code_directional(code::String, keypad::Matrix{Char})

# end

# function generate_instructions(code::String, keypad::Matrix{Char})
#     instructions = ""
#     from = 'A'
#     for to ∈ code
#         instructions *= calculate_instructions(keypad, from, to) * 'A'
#         from = to
#     end
#     return instructions
# end

function generate_instructions(code::String, keypad::Matrix{Char})
    instructions = Vector{String}()
    from = 'A'
    for to ∈ code
        parts = from_to(keypad, from, to)
        if isempty(instructions)
            for instr ∈ parts
                push!(instructions, instr * 'A')
            end
        end
        if length(parts) > 1
            cp = copy(instructions)
        end
        for (i, _) ∈ enumerate(instructions)
            instructions[i] *= parts[1] * 'A'
        end
        if length(parts) > 1
            for (i, _) ∈ enumerate(cp)
                push!(instructions, cp[i] * parts[2] * 'A')
            end
        end
    end
    return instructions
end


end # module