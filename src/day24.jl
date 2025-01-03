module Day24

using AdventOfCode2024


function day24(input::String = readInput(joinpath(@__DIR__, "..", "data", "day24.txt")))
    state, rules = parse_input(input)
    maxnumber = maximum(max(_to_number(k[2]), _to_number(k[3]), _to_number(k[4])) for k ∈ rules)
    orig_state = copy(state)
    run!(state, rules)
    p1 = result_to_number(state, maxnumber)

    wrong_indices = Int[]
    # for index ∈ 0:maxnumber-1
    #     state = copy(orig_state)
    #     init!(state, maxnumber-1, index, 1, 0)
    #     run!(state, rules)
    #     result = result_to_number(state, maxnumber)
    #     expected = 1 << index
    #     # println("index: $index, result = $result, expected = $expected")
    #     if result != expected
    #         push!(wrong_indices, index)
    #     end
    # end
    for index ∈ 0:maxnumber-1
        if !check_adder_at_index(orig_state, rules, index, maxnumber)
            push!(wrong_indices, index)
        end
    end

    current_record = 4
    swapps = String[]
    swapps_inds = []
    for i ∈ 1:size(rules, 1)
        current_record == 0 && break
        for j ∈ i+1:size(rules, 1)
            first, second = swap_outputs!(rules, i , j)
            if less_wrong_indices(orig_state, rules, maxnumber, current_record)
                println("swapped outputs = $first, $second, current_record = $current_record")
                push!(swapps, first)
                push!(swapps, second)
                push!(swapps_inds, (i, j))
                current_record -= 1
                current_record == 0 && break
            else
                swap_outputs!(rules, i, j)
            end
        end
    end
    return swapps, swapps_inds

    # return less_wrong_indices(orig_state, rules, maxnumber, 4)

    # index = 5
    # rule_indices = collect(get_rule_indices(rules, index))
    # for i ∈ 1:size(rule_indices, 1)
    #     for j ∈ i+1:size(rule_indices, 1)
    #         first, second = swap_outputs!(rules, i, j)
    #         if check_adder_at_index(orig_state, rules, maxnumber, index)
    #             println("YES")
    #             println("first = $first, second = $second")
    #         else
    #             swap_outputs!(rules, i, j)
    #         end
    #     end
    # end

end

_to_id(number::Int, pre::String) = pre * lpad(number, 2, '0')
# _to_number(id::String) = tryparse(Int, id[2:end])
_to_number(id::String) = isdigit(id[end]) ? parse(Int, id[2:end]) : 0

function less_wrong_indices(state, rules, maxnumber, prevrecord)
    wrong_indices = Int[]
    for index ∈ 0:maxnumber-1
        if !check_adder_at_index(state, rules, index, maxnumber)
            push!(wrong_indices, index)
            length(wrong_indices) >= prevrecord && return false
        end
    end
    return true
end

function swap_outputs!(rules, i, j)
    first = rules[i][end]
    second = rules[j][end]
    rules[i] = (rules[i][1], rules[i][2], rules[i][3], second)
    rules[j] = (rules[j][1], rules[j][2], rules[j][3], first)
    return first, second
end

function get_rule_indices(rules, ind)
    indices = Set{Int}()
    queue = [_to_id(ind, "x"), _to_id(ind, "y")]
    while !isempty(queue)
        elem = popfirst!(queue)
        for (i, rule) ∈ enumerate(rules)
            if rule[2] == elem || rule[3] == elem
                push!(indices, i)
                if rule[4] ∉ queue
                    push!(queue, rule[4])
                end
            end
        end
    end
    return indices
end

function check_adder_at_index(state, rules, index, maxnumber)
    s = copy(state)
    init!(s, maxnumber-1, index, 1, 0)
    run!(s, rules)
    return result_to_number(s, maxnumber) == (1 << index)
end

function init!(state, last, index, x, y)
    for i ∈ 0:last
        if i == index
            state[_to_id(i, "x")] = x
            state[_to_id(i, "y")] = y
        else
            state[_to_id(i, "x")] = false
            state[_to_id(i, "y")] = false
        end
    end
end

function result_to_number(state, maxnumber)
    number = 0
    for i ∈ 0:maxnumber
        !haskey(state, _to_id(i, "z")) && return -1
        number += state[_to_id(i, "z")] * 2^i
    end
    return number
end

function parse_input(input)
    inits, rules = split(input, "\n\n")
    init = Dict{String,Bool}()
    reg1 = r"(.+):\s(\d)"
    for line ∈ split(rstrip(inits), "\n")
        m = match(reg1, line)
        if m.captures[2] == "1"
            init[m.captures[1]] = true
        else
            init[m.captures[1]] = false
        end
    end
    reg2 = r"([a-z0-9]+)\s+(AND|OR|XOR)\s+([a-z0-9]+)\s+->\s+([a-z0-9]+)"
    rule = Tuple{String,String,String,String}[]
    for line ∈ split(rstrip(rules), "\n")
        m = match(reg2, line)
        push!(rule, (string(m.captures[2]), string(m.captures[1]), string(m.captures[3]), string(m.captures[4])))
    end
    return init, rule
end

function run!(state, rules)
    changed = true
    while changed
        changed = false
        for (op, inp1, inp2, out) ∈ rules
            if haskey(state, inp1) && haskey(state, inp2)
                if !haskey(state, out)
                    changed = true
                end
                if op == "AND"
                    state[out] = state[inp1] & state[inp2]
                elseif op == "OR"
                    state[out] = state[inp1] | state[inp2]
                elseif op == "XOR"
                    state[out] = state[inp1] ⊻ state[inp2]
                end
            end
        end
    end
    # return state
end

end # module