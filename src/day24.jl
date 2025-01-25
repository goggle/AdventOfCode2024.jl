module Day24

using AdventOfCode2024

function day24(input::String = readInput(joinpath(@__DIR__, "..", "data", "day24.txt")))
    x, y, rules = parse_input(input)
    p1, ruleorder = run(x, y, rules, nothing)

    swapped_outputs = String[]
    swapped_inds = Int[]
    wrong_adders = [i for i ∈ 0:44 if !check_adders_at_indices(rules, [i]; ruleorder)[1]]

    # rules of the form "xyz OR/ADD abc -> zdf" are probably wrong and need to be swapped
    suspicious_rules = findall(x -> startswith(x[4], "z") && x[4] != "z45" && x[1] != "XOR", rules)

    sequences = find_sequences(wrong_adders)
    for sequence ∈ sequences

        # put the suspicious rules to the beginning of the needed rules§
        nrules = needed_rules(rules, sequence) |> collect
        for susrule ∈ suspicious_rules
            if susrule ∈ nrules && susrule ∉ swapped_inds
                filter!(x -> x != susrule, nrules)
                pushfirst!(nrules, susrule)
            end
        end

        for collection ∈ (nrules, setdiff(1:length(rules), nrules))
            stop = false
            for ri ∈ collection
                for rj ∈ nrules
                    ri == rj && continue
                    first, second = swap_outputs!(rules, ri , rj)
                    corrects_critical_gates, ruleorder = check_adders_at_indices(rules, sequence)
                    if corrects_critical_gates
                        success, _ = check_adders_at_indices(rules, setdiff(0:44, wrong_adders); ruleorder)
                        if success
                            push!(swapped_outputs, (first, second)...)
                            push!(swapped_inds, (ri, rj)...)
                            stop = true
                            wrong_adders = setdiff(wrong_adders, sequence)
                            break
                        end
                    end
                    swap_outputs!(rules, ri, rj)
                end
                stop && break
            end
            stop && break
        end
    end

    return [p1, join(sort(swapped_outputs), ",")]
end

_to_id(number::Int, pre::String) = pre * lpad(number, 2, '0')
_to_number(id::String) = isdigit(id[end]) ? parse(Int, id[2:end]) : -1

function find_sequences(arr::Vector{Int})
    sequences = Vector{Int}[]
    if isempty(arr)
        return sequences
    end
    current_seq = [arr[1]]
    for i ∈ 2:length(arr)
        if arr[i] == arr[i-1] + 1
            push!(current_seq, arr[i])
        else
            push!(sequences, copy(current_seq))
            current_seq = [arr[i]]
        end
    end
    push!(sequences, current_seq)
    return sequences
end

function swap_outputs!(rules::Vector{NTuple{4, String}}, i::Int, j::Int)
    first = rules[i][end]
    second = rules[j][end]
    rules[i] = (rules[i][1], rules[i][2], rules[i][3], second)
    rules[j] = (rules[j][1], rules[j][2], rules[j][3], first)
    return first, second
end

function parse_input(input::AbstractString)
    inits, rules = split(input, "\n\n")
    reg1 = r"([xy])(\d{2}):\s(\d)"
    x, y = 0, 0
    for line ∈ split(rstrip(inits), "\n")
        m = match(reg1, line)
        index = parse(Int, m.captures[2])
        bit = parse(Int, m.captures[3])
        if m.captures[1] == "x"
            x += bit << index
        else
            y += bit << index
        end
    end
    reg2 = r"([a-z0-9]+)\s+(AND|OR|XOR)\s+([a-z0-9]+)\s+->\s+([a-z0-9]+)"
    rule = Tuple{String,String,String,String}[]
    for line ∈ split(rstrip(rules), "\n")
        m = match(reg2, line)
        push!(rule, (string(m.captures[2]), string(m.captures[1]), string(m.captures[3]), string(m.captures[4])))
    end
    return x, y, rule
end

function run(x::Int, y::Int, rules::Vector{NTuple{4, String}}, _::Nothing)
    state = Dict{String,Bool}()
    unused_rules = Set(1:length(rules))
    prev_length = length(unused_rules) + 1
    reg = r"([xy])(\d{2})"

    ruleorder = zeros(Int, length(rules))
    i = 1
    while !isempty(unused_rules) && length(unused_rules) < prev_length
        prev_length = length(unused_rules)
        for ri ∈ copy(unused_rules)
            rule = rules[ri]
            values = [false, false]
            found = false
            for j ∈ 2:3
                if haskey(state, rule[j])
                    found = true
                    values[j-1] = state[rule[j]]
                else
                    m = match(reg, rule[j])
                    if m !== nothing
                        found = true
                        index = parse(Int, m.captures[2])
                        if m.captures[1] == "x"
                            values[j-1] = (x >> index) % 2
                        else
                            values[j-1] = (y >> index) % 2
                        end
                    else
                        found = false
                        break
                    end
                end
            end
            if found
                delete!(unused_rules, ri)
                ruleorder[i] = ri
                i += 1
                if rule[1] == "AND"
                    state[rule[4]] = values[1] & values[2]
                elseif rule[1] == "OR"
                    state[rule[4]] = values[1] | values[2]
                elseif rule[1] == "XOR"
                    state[rule[4]] = values[1] ⊻ values[2]
                end
            end
        end
    end

    !isempty(unused_rules) && return -1, ruleorder

    result = 0
    i = 0
    while true
        id = _to_id(i, "z")
        !haskey(state, id) && break
        result += state[id] << i
        i += 1
    end
    return result, ruleorder
end


function run(x::Int, y::Int, rules::Vector{NTuple{4, String}}, ruleorder::Vector{Int})
    state = Dict{String,Bool}()
    reg = r"([xy])(\d{2})"

    any(ruleorder .== 0) && return -1, ruleorder

    for ri ∈ ruleorder
        rule = rules[ri]
        values = [false, false]
        for j ∈ 2:3
            m = match(reg, rule[j])
            if m !== nothing
                index = parse(Int, m.captures[2])
                if m.captures[1] == "x"
                    values[j-1] = (x >> index) % 2
                else
                    values[j-1] = (y >> index) % 2
                end
            else
                values[j-1] = state[rule[j]]
            end
        end
        if rule[1] == "AND"
            state[rule[4]] = values[1] & values[2]
        elseif rule[1] == "OR"
            state[rule[4]] = values[1] | values[2]
        elseif rule[1] == "XOR"
            state[rule[4]] = values[1] ⊻ values[2]
        end
    end

    result = 0
    i = 0
    while true
        id = _to_id(i, "z")
        !haskey(state, id) && break
        result += state[id] << i
        i += 1
    end
    return result, ruleorder
end

function needed_rules(rules::Vector{NTuple{4, String}}, outinds::Vector{Int})
    ruleinds = Set{Int}()
    reg = r"[xy]\d{2}"
    queue = [_to_id(ind, "z") for ind ∈ outinds]
    while !isempty(queue)
        out = popfirst!(queue)
        ruleind = findall(x -> x[4] == out, rules)[1]
        push!(ruleinds, ruleind)
        for i ∈ 2:3
            m = match(reg, rules[ruleind][i])
            if m === nothing
                push!(queue, rules[ruleind][i])
            end
        end
    end
    return ruleinds
end

function check_adders_at_indices(rules::Vector{NTuple{4, String}}, indices::Vector{Int}; ruleorder::Union{Vector{Int},Nothing} = nothing)
    xi    = (1, 1, 0, 1, 1)
    yi    = (0, 1, 0, 0, 1)
    cprev = (0, 0, 1, 1, 1)
    for index ∈ indices
        iter = index == 0 ? (1:2) : (1:5)
        for i ∈ iter
            x = (xi[i] << index) + (cprev[i] << (index - 1))
            y = (yi[i] << index) + (cprev[i] << (index - 1))
            result, ruleorder = run(x, y, rules, ruleorder)
            result == -1 && return false, ruleorder
            if result != x + y
                return false, ruleorder
            end
        end
    end
    return true, ruleorder
end

end # module


# module Day24

# using AdventOfCode2024

# struct Gate
#     op::Symbol       # :AND, :OR, :XOR
#     in1::Int         # Input index
#     in2::Int         # Input index
#     out::Int         # Output index
# end

# function parse_input(input::String)
#     sections = split(input, "\n\n")
#     init_section, rules_section = sections[1], sections[2]

#     # Parse initial x/y values using bitwise operations
#     x = y = 0
#     for line in split(init_section, '\n')
#         parts = split(line, r"[: ]+", keepempty=false)
#         bit = parse(Int, parts[3])
#         idx = parse(Int, parts[1][2:end])
#         if parts[1][1] == 'x'
#             x |= bit << idx
#         else
#             y |= bit << idx
#         end
#     end

#     # Create node index mapping
#     node_map = Dict{String,Int}()
#     node_count = 0
    
#     function get_index!(id::String)
#         if !haskey(node_map, id)
#             node_count += 1
#             node_map[id] = node_count
#         end
#         node_map[id]
#     end

#     # Pre-map x/y inputs (0-44 for x00-x44 and y00-y44)
#     for i in 0:44
#         get_index!("x$(lpad(i, 2, '0'))")
#         get_index!("y$(lpad(i, 2, '0'))")
#     end

#     # Parse gates and build dependency graph
#     gates = Gate[]
#     in_degree = Dict{Int,Int}()
#     adjacency = Dict{Int,Vector{Int}}()
    
#     for line in split(rules_section, '\n')
#         parts = split(line, " -> ")
#         op_inputs = split(parts[1])
#         out = get_index!(parts[2])
        
#         op = Symbol(op_inputs[1])
#         in1 = get_index!(op_inputs[2])
#         in2 = get_index!(op_inputs[3])

#         push!(gates, Gate(op, in1, in2, out))
        
#         # Build dependency graph for topological sort
#         for input in [in1, in2]
#             push!(get!(adjacency, input, Int[]), out)
#             in_degree[out] = get(in_degree, out, 0) + 1
#         end
#     end

#     # Topological sort using Kahn's algorithm
#     queue = [i for i in 1:node_count if get(in_degree, i, 0) == 0]
#     order = Int[]
    
#     while !isempty(queue)
#         node = popfirst!(queue)
#         push!(order, node)
#         for neighbor in get(adjacency, node, [])
#             in_degree[neighbor] -= 1
#             in_degree[neighbor] == 0 && push!(queue, neighbor)
#         end
#     end

#     # Filter and order gates based on topological sort
#     ordered_gates = [gate for gate in gates if gate.out in order]
    
#     return x, y, ordered_gates, node_map
# end

# function compute_output(x::Int, y::Int, gates::Vector{Gate}, node_map::Dict{String,Int})
#     max_node = maximum(values(node_map))
#     state = zeros(Bool, max_node)
    
#     # Initialize x/y inputs
#     for i in 0:44
#         state[node_map["x$(lpad(i, 2, '0'))"]] = (x >> i) & 1
#         state[node_map["y$(lpad(i, 2, '0'))"]] = (y >> i) & 1
#     end

#     # Process gates in topological order
#     for gate in gates
#         a = state[gate.in1]
#         b = state[gate.in2]
#         state[gate.out] = if gate.op == :AND
#             a & b
#         elseif gate.op == :OR
#             a | b
#         else # XOR
#             a ⊻ b
#         end
#     end

#     # Collect z outputs
#     result = 0
#     for i in 0:44
#         z_idx = node_map["z$(lpad(i, 2, '0'))"]
#         result |= state[z_idx] << i
#     end
#     result
# end

# function find_sequences(arr::Vector{Int})
#     isempty(arr) && return Vector{Int}[]
#     sort!(arr)
#     sequences = Vector{Int}[]
#     current = [arr[1]]
    
#     for val in arr[2:end]
#         val == current[end] + 1 ? push!(current, val) : begin
#             push!(sequences, current)
#             current = [val]
#         end
#     end
#     push!(sequences, current)
#     return sequences
# end

# function check_adders(x::Int, y::Int, gates::Vector{Gate}, node_map::Dict{String,Int}, indices::Vector{Int})
#     expected = x + y
#     result = compute_output(x, y, gates, node_map)
#     (result & ((1 << (maximum(indices)+1)) - 1)) == (expected & ((1 << (maximum(indices)+1)) - 1))
# end

# function needed_gates(gates::Vector{Gate}, node_map::Dict{String,Int}, out_indices::Vector{Int})
#     z_ids = [node_map["z$(lpad(i, 2, '0'))"] for i in out_indices]
#     required = Set{Int}(z_ids)
#     queue = copy(z_ids)
    
#     while !isempty(queue)
#         out = pop!(queue)
#         for gate in gates
#             if gate.out == out
#                 push!(required, gate.in1, gate.in2)
#                 push!(queue, gate.in1, gate.in2)
#             end
#         end
#     end
#     return required
# end

# function swap_gates!(gates::Vector{Gate}, i::Int, j::Int)
#     gates[i], gates[j] = gates[j], gates[i]
# end

# function day24(input::String = readInput(joinpath(@__DIR__, "..", "data", "day24.txt")))
#     x, y, gates, node_map = parse_input(input)
#     p1 = compute_output(x, y, gates, node_map)
    
#     # Part 2: Find and fix swapped gates
#     test_cases = [(0b1100, 0b0110), (0b1010, 0b0101), (0b1111, 0b0000)]  # Example test cases
#     suspicious = findall(g -> g.op != :XOR && node_map["z45"] ∉ [g.in1, g.in2], gates)
#     swapped = String[]
    
#     for seq in find_sequences([i for i in 0:44 if !check_adders(0, 0, gates, node_map, [i])])
#         needed = needed_gates(gates, node_map, seq)
#         candidates = intersect(suspicious, needed)
        
#         for (i, j) in Iterators.product(candidates, candidates)
#             i == j && continue
#             swap_gates!(gates, i, j)
            
#             valid = all(tc -> check_adders(tc[1], tc[2], gates, node_map, seq), test_cases)
#             if valid
#                 push!(swapped, "z$(lpad(gates[i].out, 2, '0'))")
#                 push!(swapped, "z$(lpad(gates[j].out, 2, '0'))")
#                 break
#             else
#                 swap_gates!(gates, i, j)  # Revert if not valid
#             end
#         end
#     end
    
#     return [p1, join(sort!(swapped), ",")]
# end

# end # module