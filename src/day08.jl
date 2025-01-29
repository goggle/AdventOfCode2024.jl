module Day08

using AdventOfCode2024

function day08(input::String = readInput(joinpath(@__DIR__, "..", "data", "day08.txt")))
    data = stack(split(rstrip(input), '\n'))
    solve(data)
end

function solve(data)
    rows, cols = size(data)
    antinodes_p1 = falses(rows, cols)
    antinodes_p2 = falses(rows, cols)
    frequencies = filter!(x -> x ≠ '.', unique(data))
    
    for freq in frequencies
        positions = findall(==(freq), data)
        n = length(positions)
        n < 2 && continue
        pos_tuples = [Tuple(p) for p in positions]
        
        @inbounds for i in 1:n-1
            x = pos_tuples[i]
            for j in i+1:n
                y = pos_tuples[j]
                anti1 = (2x[1] - y[1], 2x[2] - y[2])
                if 1 <= anti1[1] <= rows && 1 <= anti1[2] <= cols
                    antinodes_p1[anti1...] = true
                end                
                anti2 = (2y[1] - x[1], 2y[2] - x[2])
                if 1 <= anti2[1] <= rows && 1 <= anti2[2] <= cols
                    antinodes_p1[anti2...] = true
                end
            end
        end
        
        @inbounds for i in 1:n-1
            x = pos_tuples[i]
            for j in i+1:n
                y = pos_tuples[j]
                dx = y[1] - x[1]
                dy = y[2] - x[2]
                
                antinodes_p2[x...] = true
                
                i_pos, j_pos = x
                while true
                    i_pos += dx
                    j_pos += dy
                    (i_pos < 1 || i_pos > rows || j_pos < 1 || j_pos > cols) && break
                    antinodes_p2[i_pos, j_pos] = true
                end
                
                i_neg, j_neg = x
                while true
                    i_neg -= dx
                    j_neg -= dy
                    (i_neg < 1 || i_neg > rows || j_neg < 1 || j_neg > cols) && break
                    antinodes_p2[i_neg, j_neg] = true
                end
            end
        end
    end
    
    return [sum(antinodes_p1), sum(antinodes_p2)]
end

end # module