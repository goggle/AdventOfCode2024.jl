module Day09

using AdventOfCode2024


function day09(input::String = readInput(joinpath(@__DIR__, "..", "data", "day09.txt")))
    data, filelist, spacelist = parse_data(input)
    p1 = part1!(copy(data))
    p2 = part2!(data)
    return [p1, p2]
end

function parse_data(input)
    data = Int[]
    filelist = Tuple{Int,Int}[]
    spacelist = Tuple{Int,Int}[]
    id = 0
    isfile = true
    index = 1
    for d ∈ rstrip(input)
        n = parse(Int, d)
        if isfile
            push!(data, (id * ones(Int, n))...)
            push!(filelist, (index, n))
            id += 1
        else
            push!(data, (-1 * ones(Int, n))...)
            push!(spacelist, (index, n))
        end
        isfile = !isfile
        index += n
    end
    return data, filelist, spacelist
end

function part1!(data)
    ispace, inumber = 1, length(data)
    while ispace < inumber
        while ispace < length(data) && data[ispace] != -1
            ispace += 1
        end
        while inumber > 0 && data[inumber] == -1
            inumber -= 1
        end
        ispace > inumber && break
        data[ispace], data[inumber] = data[inumber], data[ispace]
        ispace += 1
        inumber -= 1
    end
    return checksum(data)
end

function checksum(data)
    s, i = 0, 1
    while i < length(data)
        if data[i] == -1
            i += 1
            continue
        end
        s += data[i] * (i - 1)
        i += 1
    end
    return s
end

# TODO: Debug: Why is this wrong?
function part2!(data, filelist, spacelist)
    for (ifilestart, ifilelength) ∈ reverse(filelist)
        for (i, (ispacestart, ispacelength)) ∈ enumerate(spacelist)
            if ispacelength >= ifilelength
                data[ispacestart:ispacestart + ifilelength - 1] .= data[ifilestart]
                data[ifilestart:ifilestart + ifilelength - 1] .= -1
                spacelist[i] = (ispacestart + ifilelength, ispacelength - ifilelength)
                break
            end
        end
        println(string(data))
    end
    return checksum(data)
end

function part2!(data)
    ifile = length(data)
    while true
        ifile, lenfile = prev_file(data, ifile)
        ifile == 0 && return checksum(data)
        ispace, lenspace = free_space(data, lenfile, ifile)
        if ispace == 0
            ifile -= 1
            continue
        else
            data[ispace:ispace+lenfile-1] .= data[ifile]
            data[ifile:ifile+lenfile-1] .= -1
            ifile -= 1
        end
    end

end

function prev_file(data, i)
    i <= 0 && return 0, 0
    if data[i] == -1
        while data[i] == -1
            if i == 0
                return 0, 0
            end
            i -= 1
        end
    end
    id = data[i]
    while i > 0 && data[i] == id
        i -= 1
    end
    istart = i + 1
    iend = istart
    while iend <= length(data) && data[iend] == data[istart]
        iend += 1
    end
    iend -= 1
    return istart, iend - istart + 1
end

function free_space(data, len, imax)
    free_indices = findall(x -> x == -1, data)
    visited = similar(data, Bool)
    visited .= false
    for i ∈ free_indices
        i >= imax && return 0, 0
        visited[i] && continue
        istart = iend = i
        while iend <= length(data) && data[iend] == -1
            visited[iend] = true
            iend += 1
        end
        iend -= 1
        l = iend - istart + 1
        l >= len && return istart, l
    end
    return 0, 0
end

end # module