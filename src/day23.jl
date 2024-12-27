module Day23

using AdventOfCode2024


function day23(input::String = readInput(joinpath(@__DIR__, "..", "data", "day23.txt")))
    connections = split.(split(rstrip(input), '\n'), '-')
    network = zeros(Bool, _computer_to_index("zz"), _computer_to_index("zz"))
    for (a, b) ∈ connections
        ind_a = _computer_to_index(a)
        ind_b = _computer_to_index(b)
        network[ind_a, ind_b] = true
        network[ind_b, ind_a] = true
    end
    triangles = find_triangles(network)
    p1 = count(any(t[1] == 't' for t ∈ tri) for tri ∈ triangles)
    return [p1, join(_index_to_computer.(find_largest_network(network)) |> sort, ',')]
end

function parse_input(input)
    split.(split(rstrip(input), '\n'), '-')
end

function find_triangles(network::Matrix{Bool})
    triangles = Tuple{String,String,String}[]
    for i ∈ axes(network, 1)
        for j ∈ i + 1:size(network,2)
            if network[i, j]
                for k ∈ j + 1:size(network,2)
                    if network[j, k] && network[k, i]
                        push!(triangles, (_index_to_computer(i), _index_to_computer(j), _index_to_computer(k)))
                    end
                end
            end
        end
    end
    return triangles
end

function find_largest_network(network::Matrix{Bool})
    visited = zeros(Bool, size(network,1))
    largest_component = Int[]

    for vertex ∈ 1:size(network, 1)
        if !visited[vertex]
            current_component = Int[]
            component = dfs!(current_component, visited, network, vertex)
            if length(component) > length(largest_component)
                largest_component = copy(component)
            end
        end
    end
    return largest_component
end

function dfs!(component::Vector{Int}, visited::Vector{Bool}, network::Matrix{Bool}, vertex::Int)
    visited[vertex] = true
    push!(component, vertex)
    for neighbour ∈ 1:size(network, 1)
        if !visited[neighbour] && network[vertex, neighbour] && all(network[neighbour, comp] for comp ∈ component)
            dfs!(component, visited, network, neighbour)
        end
    end
    return component
end

_computer_to_index(c::AbstractString) = (Int(c[1] - Int('a'))) * 26 + (Int(c[2]) - Int('a'))
_index_to_computer(index::Int) = Char(Int('a') + index ÷ 26) * Char(Int('a') + index % 26)

end # module