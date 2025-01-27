module Day22

using AdventOfCode2024

function day22(input::String = readInput(joinpath(@__DIR__, "..", "data", "day22.txt")))
    secrets = parse.(Int, split(rstrip(input), '\n'))
    p1 = 0

    # Precompute the size of the array based on 19^4 possible combinations (0-18 for each of 4 components)
    nbananas_size = 19^4
    nbananas = zeros(Int, nbananas_size)
    seen_bits = falses(nbananas_size)

    for secret in secrets
        nsecret = secret
        price = nsecret % 10
        cb = (Int8(0), Int8(0), Int8(0), Int8(0))
        for _ in 1:3
            nsecret = next_secret_number(nsecret)
            nprice = nsecret % 10
            diff = Int8(nprice - price)
            cb = (cb[2], cb[3], cb[4], diff)
            price = nprice
        end

        for _ in 4:2000
            nsecret = next_secret_number(nsecret)
            nprice = nsecret % 10
            diff = Int8(nprice - price)
            cb = (cb[2], cb[3], cb[4], diff)
            price = nprice

            d1 = cb[1] + 9
            d2 = cb[2] + 9
            d3 = cb[3] + 9
            d4 = cb[4] + 9

            key = (d1 % Int) << 15 | (d2 % Int) << 10 | (d3 % Int) << 5 | (d4 % Int)
            i1 = (key >> 15) & 0x1F
            i2 = (key >> 10) & 0x1F
            i3 = (key >> 5) & 0x1F
            i4 = key & 0x1F
            index = i1 * 19^3 + i2 * 19^2 + i3 * 19 + i4 + 1  # +1 for 1-based indexing

            if !seen_bits[index]
                seen_bits[index] = true
                nbananas[index] += price
            end
        end

        fill!(seen_bits, false)
        p1 += nsecret
    end

    return [p1, maximum(nbananas)]
end

@inline function next_secret_number(secret::Int)
    # Use bitmasking instead of modulo for faster operations
    step1 = xor(secret << 6, secret) & 0x00FFFFFF
    step2 = xor(step1 >> 5, step1) & 0x00FFFFFF
    return xor(step2 << 11, step2) & 0x00FFFFFF
end

end # module