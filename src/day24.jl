module Day24

using AdventOfCode2024

function day24(input::String = readInput(joinpath(@__DIR__, "..", "data", "day24.txt")))
    x, y, rules, var_ids, x_bits, y_bits, z_outputs, ruleorder = parse_input_optimized(input)
    p1 = run_optimized(x, y, rules, var_ids, x_bits, y_bits, z_outputs, ruleorder)

    swapped_outputs = String[]
    swapped_inds = Int[]
    wrong_adders = [i for i ∈ 0:44 if !check_adders_dynamic(rules, var_ids, x_bits, y_bits, z_outputs, [i], ruleorder)[1]]

    suspicious_rules = findall(x -> startswith(rules[x][4], "z") && rules[x][4] != "z45" && rules[x][1] != "XOR", 1:length(rules))

    sequences = find_sequences(wrong_adders)
    for sequence ∈ sequences
        nrules = needed_rules_optimized(rules, sequence) |> collect
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
                    first, second = swap_outputs!(rules, ri, rj)
                    corrects_critical, _ = check_adders_dynamic(rules, var_ids, x_bits, y_bits, z_outputs, sequence, ruleorder)
                    if corrects_critical
                        success, _ = check_adders_dynamic(rules, var_ids, x_bits, y_bits, z_outputs, setdiff(0:44, wrong_adders), ruleorder)
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
    isempty(arr) && return Vector{Int}[]
    sequences = Vector{Int}[]
    current_seq = [arr[1]]
    for i ∈ 2:length(arr)
        arr[i] == arr[i-1] + 1 ? push!(current_seq, arr[i]) : (push!(sequences, current_seq); current_seq = [arr[i]])
    end
    push!(sequences, current_seq)
    sequences
end

function swap_outputs!(rules::Vector{NTuple{4, String}}, i::Int, j::Int)
    rules[i], rules[j] = ( (rules[i][1], rules[i][2], rules[i][3], rules[j][4]), (rules[j][1], rules[j][2], rules[j][3], rules[i][4]) )
    return (rules[i][4], rules[j][4])
end

function parse_input_optimized(input::AbstractString)
    inits, rules = split(input, "\n\n")
    var_ids = Dict{String, Int}()
    current_id = 1

    x, y = 0, 0
    reg1 = r"([xy])(\d{2}):\s(\d)"
    x_bits = Dict{Int, Int}()
    y_bits = Dict{Int, Int}()
    for line ∈ split(rstrip(inits), "\n")
        m = match(reg1, line)
        var = m.captures[1] * m.captures[2]
        get!(var_ids, var) do
            current_id += 1
        end
        index = parse(Int, m.captures[2])
        bit = parse(Int, m.captures[3])
        id = var_ids[var]
        if m.captures[1] == "x"
            x_bits[id] = index
            x += bit << index
        else
            y_bits[id] = index
            y += bit << index
        end
    end

    reg2 = r"([a-z0-9]+)\s+(AND|OR|XOR)\s+([a-z0-9]+)\s+->\s+([a-z0-9]+)"
    parsed_rules = NTuple{4, String}[]
    output_vars = String[]
    for line ∈ split(rstrip(rules), "\n")
        m = match(reg2, line)
        op, left, right, output = m.captures[2], m.captures[1], m.captures[3], m.captures[4]
        for var in [left, right, output]
            get!(var_ids, var) do
                current_id += 1
            end
        end
        push!(parsed_rules, (op, left, right, output))
        push!(output_vars, output)
    end

    adjacency = Dict{String, Vector{String}}()
    in_degree = Dict{String, Int}()
    for var ∈ output_vars
        adjacency[var] = []
        in_degree[var] = 0
    end

    for (_, left, right, output) ∈ parsed_rules
        for input_var ∈ [left, right]
            if input_var ∈ keys(in_degree)
                push!(adjacency[input_var], output)
                in_degree[output] += 1
            end
        end
    end

    queue = [var for var ∈ output_vars if in_degree[var] == 0]
    top_order = String[]
    while !isempty(queue)
        var = popfirst!(queue)
        push!(top_order, var)
        for neighbor ∈ adjacency[var]
            in_degree[neighbor] -= 1
            if in_degree[neighbor] == 0
                push!(queue, neighbor)
            end
        end
    end

    output_to_rule = Dict(var => i for (i, (_, _, _, var)) ∈ enumerate(parsed_rules))
    ruleorder = [output_to_rule[var] for var ∈ top_order]

    z_outputs = String[]
    i = 0
    while true
        z_id = _to_id(i, "z")
        haskey(var_ids, z_id) ? push!(z_outputs, z_id) : break
        i += 1
    end

    return x, y, parsed_rules, var_ids, x_bits, y_bits, z_outputs, ruleorder
end

function run_optimized(x::Int, y::Int, rules::Vector{NTuple{4, String}}, var_ids::Dict{String, Int}, x_bits::Dict{Int, Int}, y_bits::Dict{Int, Int}, z_outputs::Vector{String}, ruleorder::Vector{Int})
    max_id = maximum(values(var_ids))
    state = falses(max_id)
    for (id, idx) ∈ x_bits
        state[id] = (x >> idx) & 1 == 1
    end
    for (id, idx) ∈ y_bits
        state[id] = (y >> idx) & 1 == 1
    end

    for ri ∈ ruleorder
        op, left, right, output = rules[ri]
        lid, rid, oid = var_ids[left], var_ids[right], var_ids[output]
        lval = state[lid]
        rval = state[rid]
        if op == "AND"
            state[oid] = lval & rval
        elseif op == "OR"
            state[oid] = lval | rval
        elseif op == "XOR"
            state[oid] = lval ⊻ rval
        end
    end

    result = 0
    for (i, z) ∈ enumerate(z_outputs)
        result += state[var_ids[z]] << (i - 1)
    end
    return result
end

function needed_rules_optimized(rules::Vector{NTuple{4, String}}, outinds::Vector{Int})
    needed = Set{Int}()
    queue = [_to_id(ind, "z") for ind ∈ outinds]
    outputs = Set([rule[4] for rule ∈ rules])
    while !isempty(queue)
        out = popfirst!(queue)
        for (i, rule) ∈ enumerate(rules)
            if rule[4] == out
                push!(needed, i)
                for j ∈ 2:3
                    input_var = rule[j]
                    if input_var ∈ outputs
                        push!(queue, input_var)
                    end
                end
                break
            end
        end
    end
    return needed
end

function check_adders_dynamic(rules, var_ids, x_bits, y_bits, z_outputs, indices, ruleorder)
    xi    = (1, 1, 0, 1, 1)
    yi    = (0, 1, 0, 0, 1)
    cprev = (0, 0, 1, 1, 1)
    for index ∈ indices
        iter = index == 0 ? (1:2) : (1:5)
        for i ∈ iter
            x_val = (xi[i] << index) + (cprev[i] << (index - 1))
            y_val = (yi[i] << index) + (cprev[i] << (index - 1))
            result = run_optimized(x_val, y_val, rules, var_ids, x_bits, y_bits, z_outputs, ruleorder)
            expected = x_val + y_val
            if result != expected
                return false, nothing
            end
        end
    end
    return true, nothing
end

end # module