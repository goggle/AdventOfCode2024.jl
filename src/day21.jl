module Day21

using AdventOfCode2024
using Memoize

function day21(input::String = readInput(joinpath(@__DIR__, "..", "data", "day21.txt")))
    data = split(rstrip(input), "\n")
    numpad = Dict{Char,Tuple{Int,Int}}(
        'A' => (4, 3),
        '0' => (4, 2),
        '1' => (3, 1),
        '2' => (3, 2),
        '3' => (3, 3),
        '4' => (2, 1),
        '5' => (2, 2),
        '6' => (2, 3),
        '7' => (1, 1),
        '8' => (1, 2),
        '9' => (1, 3)
    )
    dirpad = Dict{Char,Tuple{Int,Int}}(
        'A' => (1, 3),
        '^' => (1, 2),
        '<' => (2, 1),
        'v' => (2, 2),
        '>' => (2, 3)
    )
    numpad_graph = create_graph(numpad, (4, 1))
    dirpad_graph = create_graph(dirpad, (1, 1))

    p1, p2 = 0, 0
    for d ∈ data
        p1 += solve(d, 3, numpad_graph, dirpad_graph, true) * parse(Int, d[1:end-1])
        p2 += solve(d, 26, numpad_graph, dirpad_graph, true) * parse(Int, d[1:end-1])
    end
    return [p1, p2]
end

function create_graph(keypad, forbidden_coord)
    graph = Dict{Char,Dict{Char,String}}()
    for key ∈ keys(keypad)
        graph[key] = Dict{Char,String}()
    end
    for (k1, (x1, y1)) ∈ keypad
        for (k2, (x2, y2)) ∈ keypad
            path = repeat("<", max(0, y1-y2)) * repeat("v", max(0, x2-x1)) * repeat("^", max(0, x1-x2)) * repeat(">", max(0, y2-y1))
            if forbidden_coord == (x1, y2) || forbidden_coord == (x2, y1)
                path = reverse(path)
            end
            graph[k1][k2] = path * 'A'
        end
    end
    return graph
end

@memoize function solve(sequence, iterations, numpad_graph, dirpad_graph, first)
    iterations == 0 && return length(sequence)
    prev = 'A'
    total = 0
    graph = first ? numpad_graph : dirpad_graph
    for c ∈ sequence
        total += solve(graph[prev][c], iterations - 1, numpad_graph, dirpad_graph, false)
        prev = c
    end
    return total
end

end # module