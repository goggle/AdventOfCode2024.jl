module Day02

using AdventOfCode2024


function day02(input::String = readInput(joinpath(@__DIR__, "..", "data", "day02.txt")))
    data = [parse.(Int, split(x)) for x ∈ eachsplit(rstrip(input), "\n")]
    p1 = count(_check_savety(a) for a ∈ data)
    p2 = 0
    for a ∈ data
        if _check_savety(a)
            p2 += 1
        else
            for i ∈ eachindex(a)
                if _check_savety(vcat(a[1:i-1], a[i+1:end]))
                    p2 += 1
                    break
                end
            end
        end
    end
    return [p1, p2]
end

_check_savety(a::Vector{Int}) = allequal(sign.(@view(a[2:end]) - @view(a[1:end-1]))) && all(1 .<= abs.(@view(a[2:end]) - @view(a[1:end-1])) .<= 3)

end # module