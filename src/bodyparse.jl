function parsebody!(stream::IOStream, header::NavHeader)
    data = RinexBody()

    buff = read(stream, Char)
    while !eof(stream)
        if buff == 'G'
            data.GPS = append!(data.GPS,readgpsnavdata!(stream))
        elseif buff == 'R'
            data.GLONASS = append!(data.GLONASS,readglonassnavdata!(stream))
        elseif buff == 'E'
            data.GALILEO = append!(data.GALILEO,readgalileonavdata!(stream))
        elseif buff == 'C'
            data.BEIDOU = append!(data.BEIDOU,readbeidounavdata!(stream))
        elseif buff == 'S'
            data.SBAS = append!(data.SBAS,readsbasnavdata!(stream))
        elseif buff == 'J'
            data.QZSS = append!(data.QZSS,readqzssnavdata!(stream))
        elseif buff == 'I'
            data.IRNSS = append!(data.IRNSS,readirnssnavdata!(stream))
        end
        buff = read(stream, Char)
    end
    close(stream)
    return data
end




function parsebody!(stream::IOStream, header::ObsHeader)
    time = TimeDate(0)
    flag = 0
    clkoffset = 0.0

    d = Dict()
    for key in keys(header.systems)
        d[key] = Dict(
            "Time" => TimeDate[],
            "SatelliteID" => Int[],
            "EpochFlag" => Int[],
            [name => Float64[] for name in header.systems[key].types]...,
            [name*"_LLI" => Float64[] for name in header.systems[key].types]...,
            [name*"_SSI" => Float64[] for name in header.systems[key].types]...
        )
    end
    
    for line in eachline(stream)
        l = length(line)
        if l == 0
            continue
        end
        if line[1] == '>'
            time = TimeDate(line[3:29], "yyyy mm dd HH MM SS.sssssss")
            flag = parse(Int, line[30:32])
            if flag != 0
                println("WARNING: Epoch flag is not 0\n special events not supported yet\nthe parsing will most likely fail or give incorrect results!")
            end
            numsats = parse_withwhitespace(line[33:35], Int)
            clkoffset = parse_withwhitespace(line[36:55], Float64)
        elseif haskey(header.systems, line[1])
            numobs = header.systems[line[1]].number_of_observables
            names = header.systems[line[1]].types
            id = parse_withwhitespace(line[2:3], Int)
            row = Dict()
            for i in 1:numobs
                start_val = 4 + 16*(i-1)
                end_val = 4 + 16*i - 3
                if end_val > l
                    end_val = l
                end
                value = parse_withwhitespace(line[start_val:end_val], Float64)
                if end_val +1 <= l
                    lli = parse_withwhitespace(line[end_val+1], Float64)
                end
                if end_val + 2 <= l
                    signal = parse_withwhitespace(line[end_val+2], Float64)
                end
                push!(d[line[1]][names[i]], value)
                push!(d[line[1]][names[i]*"_LLI"], lli)
                push!(d[line[1]][names[i]*"_SSI"], signal)
            end
            push!(d[line[1]]["Time"], time)
            push!(d[line[1]]["SatelliteID"], id)
            push!(d[line[1]]["EpochFlag"], flag)
        end
    end
    data = RinexBody()
    for key in keys(d)
        if key == 'G'
            data.GPS = DataFrame(d[key])
        elseif key == 'R'
            data.GLONASS = DataFrame(d[key])
        elseif key == 'E'
            data.GALILEO = DataFrame(d[key])
        elseif key == 'C'
            data.BEIDOU = DataFrame(d[key])
        elseif key == 'S'
            data.SBAS = DataFrame(d[key])
        elseif key == 'J'
            data.QZSS = DataFrame(d[key])
        elseif key == 'I'
            data.IRNSS = DataFrame(d[key])
        else
            println("WARNING: Unknown system $key")
        end
    end
    return data
end
