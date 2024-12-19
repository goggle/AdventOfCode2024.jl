module Day17

using AdventOfCode2024


function day17(input::String = readInput(joinpath(@__DIR__, "..", "data", "day17.txt")))
    registers, instructions = parse_input(input)
    out = run_program!(copy(registers), copy(instructions))
    p1 = join(out, ",")

    sequence = find_sequence(copy(registers), copy(instructions))
    p2 = 0
    for elem ∈ sequence
        p2 += elem
        p2 *= 8
    end
    p2 ÷= 8

    return [p1, p2]
end

function find_sequence(registers, instructions)
    target_length = length(instructions)
    possible_values = 0:7
    sequence = Int[]
    current_value = 0

    function try_next_value(depth=1)
        if depth > target_length
            return true
        end
        for value ∈ possible_values
            new_current = current_value + value
            test_registers = copy(registers)
            test_registers['A'] = new_current
            out = run_program!(test_registers, copy(instructions))
            if out[1] == instructions[end - depth + 1]
                push!(sequence, value)
                old_current = current_value
                current_value = new_current * 8
                if try_next_value(depth + 1)
                    return true
                end
                pop!(sequence)
                current_value = old_current
            end
        end
        return false
    end

    if try_next_value()
        return sequence
    else
        return nothing
    end
end

function parse_input(input)
    lines = split(input, "\n")
    registers = Dict{Char,Int}()
    registers['A'] = parse(Int, split(lines[1], " ")[end])
    registers['B'] = parse(Int, split(lines[2], " ")[end])
    registers['C'] = parse(Int, split(lines[3], " ")[end])
    instructions = parse.(Int, split(split(lines[5], " ")[end], ","))
    return registers, instructions
end

function get_combo(combo_operand::Int, registers::Dict{Char,Int})
    if combo_operand ∈ 0:3
        return combo_operand
    elseif combo_operand == 4
        return registers['A']
    elseif combo_operand == 5
        return registers['B']
    elseif combo_operand == 6
        return registers['C']
    else
        println("Invalid")
    end
end

function adv!(registers::Dict{Char,Int}, out::Vector{Int}, combo::Int, ip::Int)
    registers['A'] ÷= 2^get_combo(combo, registers)
    return ip + 2
end

function bxl!(registers::Dict{Char,Int}, out::Vector{Int}, literal::Int, ip::Int)
    registers['B'] = xor(registers['B'], literal)
    return ip + 2
end

function bst!(registers::Dict{Char,Int}, out::Vector{Int}, combo::Int, ip::Int)
    registers['B'] = mod(get_combo(combo, registers), 8)
    return ip + 2
end

function jnz!(registers::Dict{Char,Int}, out::Vector{Int}, literal::Int, ip::Int)
    if registers['A'] != 0
        return literal + 1
    end
    return ip + 2
end

function bxc!(registers::Dict{Char,Int}, out::Vector{Int}, literal::Int, ip::Int)
    registers['B'] = xor(registers['B'], registers['C'])
    return ip + 2
end

function out!(registers::Dict{Char,Int}, out::Vector{Int}, combo::Int, ip::Int)
    push!(out, mod(get_combo(combo, registers), 8))
    return ip + 2
end

function bdv!(registers::Dict{Char,Int}, out::Vector{Int}, combo::Int, ip::Int)
    registers['B'] = registers['A'] ÷ 2^get_combo(combo, registers)
    return ip + 2
end

function cdv!(registers::Dict{Char,Int}, out::Vector{Int}, combo::Int, ip::Int)
    registers['C'] = registers['A'] ÷ 2^get_combo(combo, registers)
    return ip + 2
end

function run_program!(registers::Dict{Char,Int}, instructions::Vector{Int})
    ip = 1
    opcode_to_instruction = Dict(
        0 => adv!,
        1 => bxl!,
        2 => bst!,
        3 => jnz!,
        4 => bxc!,
        5 => out!,
        6 => bdv!,
        7 => cdv!
    )
    out = Int[]
    while ip <= length(instructions)
        ip = opcode_to_instruction[instructions[ip]](registers, out, instructions[ip + 1], ip)
    end
    return out
end


end # module