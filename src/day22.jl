module Day22

using AdventOfCode2024
using DataStructures

function day22(input::String = readInput(joinpath(@__DIR__, "..", "data", "day22.txt")))
    secrets = parse.(Int, split(rstrip(input), '\n'))
    p1 = 0

    nbananas = Dict{Int,Int}()
    for i1 ∈ 0:18
        for i2 ∈ 0:18
            for i3 ∈ 0:18
                for i4 ∈ 0:18
                    nbananas[(i1<<15, i2<<10, i3<<5, i4) |> sum] = 0
                end
            end
        end
    end

    for secret ∈ secrets
        seen = Set{Int}()
        cb = CircularBuffer{Int8}(4)
        nsecret = secret
        price = nsecret % 10
        for _ ∈ 1:3
            nsecret = next_secret_number(nsecret)
            nprice = nsecret % 10
            push!(cb, nprice - price)
            price = nprice
        end
        for _ ∈ 4:2000
            nsecret = next_secret_number(nsecret)
            nprice = nsecret % 10
            push!(cb, nprice - price)
            price = nprice

            diffseq = ((cb[1] + 9) << 15, (cb[2] + 9) << 10, (cb[3] + 9) << 5, cb[4] + 9) |> sum
            if diffseq ∉ seen
                push!(seen, diffseq)
                nbananas[diffseq] += price
            end
        end
        p1 += nsecret
    end

    return [p1, maximum(values(nbananas))]
end

function next_secret_number(secret::Int)
    step1 = mix(secret << 6, secret) |> prune
    step2 = mix(step1 >> 5, step1) |> prune
    return mix(step2 << 11, step2) |> prune
end

mix(number::Int, secret::Int) = xor(number, secret)
prune(secret::Int) = secret % 16777216

end # module