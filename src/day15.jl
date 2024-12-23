module Day15

using AdventOfCode2024


function day15(input::String = readInput(joinpath(@__DIR__, "..", "data", "day15.txt")))
    world, instructions = parse_input(input)
    world_p1 = copy(world)
    execute_instructions_p1!(world_p1, instructions)
    p1 = total_gps(world_p1)
    world_p2 = fill('.', (size(world) .* (1, 2))...)
    for ind ∈ eachindex(IndexCartesian(), world)
        if world[ind] == '#'
            world_p2[ind[1],2*ind[2]-1] = '#'
            world_p2[ind[1],2*ind[2]] = '#'
        elseif world[ind] == 'O'
            world_p2[ind[1],2*ind[2]-1] = '['
            world_p2[ind[1],2*ind[2]] = ']'
        elseif world[ind] == '@'
            world_p2[ind[1],2*ind[2]-1] = '@'
        end
    end
    execute_instructions_p2!(world_p2, instructions)
    return world_p2
end

function parse_input(input)
    wo, ins = split(input, "\n\n")
    return map(x -> x[1], reduce(vcat, permutedims.(map(x -> split(x, ""), split(wo))))), replace(ins, '\n' => "")
end

function execute_instructions_p1!(world, instructions)
    current = findall(x -> x == '@', world)[1]
    world[current] = '.'
    for instruction ∈ instructions
        next = current + _to_dir(instruction)
        if world[next] == '.'
            current = next
        elseif world[next] == 'O'
            while world[next] ∉ ('.', '#')
                next += _to_dir(instruction)
            end
            world[next] == '#' && continue
            while next != current
                pnext = next - _to_dir(instruction)
                world[next], world[pnext] = world[pnext], world[next]
                next = pnext
            end
            current = current + _to_dir(instruction)
        end
    end
end

function _to_dir(c::Char)
    c == 'v' && return CartesianIndex(1, 0)
    c == '^' && return CartesianIndex(-1, 0)
    c == '>' && return CartesianIndex(0, 1)
    c == '<' && return CartesianIndex(0, -1)
end

function total_gps(world::Matrix{Char})
    total = 0
    for index ∈ findall(x -> x == 'O', world)
        total += 100 * (index[1] - 1) + index[2] - 1
    end
    return total
end

function locate_box_complex!(tipping_positions::Set{CartesianIndex{2}}, move_positions::Set{CartesianIndex{2}}, world::Matrix{Char}, dir::CartesianIndex{2})
    new_tipping_positions = Set{CartesianIndex{2}}()
    for pos ∈ tipping_positions
        push!(move_positions, pos)
        if world[pos] == '['
            lockpos = CartesianIndex(pos[1], pos[2] + 1)
        elseif world[pos] == ']'
            lockpos = CartesianIndex(pos[1], pos[2] - 1)
        end
        push!(move_positions, lockpos)
        if world[pos + dir] == '#' || world[lockpos + dir] == '#'
            return false
        else
            if world[pos + dir] ∈ ('[', ']')
                push!(new_tipping_positions, pos + dir)
            end
            if world[lockpos + dir] ∈ ('[', ']')
                push!(new_tipping_positions, lockpos + dir)
            end
        end
    end
    if !isempty(new_tipping_positions)
        return locate_box_complex!(new_tipping_positions, move_positions, world, dir)
    end
    return true
end

function move!(move_positions::Set{CartesianIndex{2}}, world::Matrix{Char}, dir::CartesianIndex{2})
    if dir[1] == -1
        mpsorted = sort(collect(move_positions), by=x->x[1])
    else
        mpsorted = sort(collect(move_positions), by=x->x[1], rev=true)
    end
    for pos ∈ mpsorted
        world[pos + dir], world[pos] = world[pos], world[pos + dir]
    end
end

function execute_instructions_p2!(world, instructions)
    current = findall(x -> x == '@', world)[1]
    world[current] = '.'
    for instruction ∈ instructions
        dir = _to_dir(instruction)
        next = current + dir
        if world[next] == '.'
            current = next
        elseif world[next] ∈ ('[',']')
            if instruction ∈ ('>', '<')
                while world[next] ∉ ('.', '#')
                    next += dir
                end
                world[next] == '#' && continue
                while next != current
                    pnext = next - dir
                    world[next], world[pnext] = world[pnext], world[next]
                    next = pnext
                end
                current = current + dir
            else
                move_positions = Set{CartesianIndex{2}}()
                if locate_box_complex!(Set([next]), move_positions, world, dir)
                    move!(move_positions, world, dir)
                end
            end
        end
    end
end

end # module