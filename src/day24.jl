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