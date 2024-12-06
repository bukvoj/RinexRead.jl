function parsebody!(stream::IOStream, header::NavHeader)
    data = RinexBody()

    buff = read(stream, Char)
    while !eof(stream)
        if buff == 'G'
            data.GPS = vcat(data.GPS,readgpsnavdata!(stream))
        elseif buff == 'R'
            data.GLONASS = vcat(data.GLONASS,readglonassnavdata!(stream))
        elseif buff == 'E'
            data.GALILEO = vcat(data.GALILEO,readgalileonavdata!(stream))
        elseif buff == 'C'
            data.BEIDOU = vcat(data.BEIDOU,readbeidounavdata!(stream))
        elseif buff == 'S'
            data.SBAS = vcat(data.SBAS,readsbasnavdata!(stream))
        elseif buff == 'J'
            data.QZSS = vcat(data.QZSS,readqzssnavdata!(stream))
        elseif buff == 'I'
            data.IRNSS = vcat(data.IRNSS,readirnssnavdata!(stream))
        end
        buff = read(stream, Char)
    end
    close(stream)
    return data
end




function parsebody!(stream::IOStream, header::ObsHeader)
    time = DateTime(0)
    flag = 0
    clkoffset = 0.0

    d = Dict()
    for key in keys(header.systems)
        d[key] = Dict(
            "time" => DateTime[],
            "id" => Int[],
            "epoch_flag" => Int[],
            [name => Float64[] for name in header.systems[key].types]...,
            [name*"_LLI" => Float64[] for name in header.systems[key].types]...,
            [name*"_signal_strength" => Float64[] for name in header.systems[key].types]...
        )
    end
    
    for line in eachline(stream)
        l = length(line)
        if l == 0
            continue
        end
        if l[1] == '>'
            year = parse_withwhitespace(line[1:5], Int)
            month = parse_withwhitespace(line[6:8], Int)
            day = parse_withwhitespace(line[9:11], Int)
            hour = parse_withwhitespace(line[12:14], Int)
            minute = parse_withwhitespace(line[15:17], Int)
            second = parse_withwhitespace(line[18:29], Float64)
            millisecond = floor(1000 * (second - floor(second)))
            second = floor(second)
            time = DateTime(year, month, day, hour, minute, second, millisecond)
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
                push!(d[line[1]][names[i]*"_signal_strength"], signal)
            end
            push!(d[line[1]]["time"], time)
            push!(d[line[1]]["id"], id)
            push!(d[line[1]]["epoch_flag"], flag)
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


# function parsebody!(stream::IOStream, header::ObsHeader)
#     data = RinexBody()
#     time = DateTime(0)
#     flag = 0
#     clkoffset = 0.0
#     while !eof(stream)
#         buff = read(stream, Char)
#         if buff == '>'
#             year = parse(Int, String(read(stream, 5)))
#             month = parse(Int, String(read(stream, 3)))
#             day = parse(Int, String(read(stream, 3)))
#             hour = parse(Int, String(read(stream, 3)))
#             minute = parse(Int, String(read(stream, 3)))
#             second = parse(Float64, String(read(stream, 11)))
#             millisecond = floor(1000 * (second - floor(second)))
#             microsecond = floor(1000000 * (second - floor(second)))
#             nanosecond = floor(1000000000 * (second - floor(second)))
#             second = floor(second)
#             time = DateTime(year, month, day, hour, minute, second, millisecond)
#             flag = parse(Int, String(read(stream, 3)))
#             if flag != 0
#                 println("WARNING: Epoch flag is not 0\n special events not supported yet")
#             end
#             numsats = parse(Int, String(read(stream, 3)))
#             clkoffset = parse_withwhitespace(String(read(stream, 20)), Float64)
#         elseif haskey(header.systems, buff)
#             numobs = header.systems[buff].number_of_observables
#             names = header.systems[buff].types
#             buff = buff*readuntil(stream, '\n')
#             id = parse(Int, buff[2:3])
#             linelen = length(buff)
#             row = Dict()
#             for i in 1:numobs
#                 start_val = 4 + 16*(i-1)
#                 end_val = 4 + 16*i - 3
#                 if end_val > linelen
#                     end_val = linelen
#                 end
#                 value = parse_withwhitespace(buff[start_val:end_val], Float64)
#                 if end_val +1 <= linelen
#                     lli = parse_withwhitespace(buff[end_val+1], Float64)
#                 end
#                 if end_val + 2 <= linelen
#                     signal = parse_withwhitespace(buff[end_val+2], Float64)
#                 end
#                 row["time"] = time
#                 row["id"] = id
#                 row["epoch_flag"] = flag
#                 row["clkoffset"] = clkoffset
#                 row[names[i]] = value
#                 row[names[i]*"_LLI"] = lli
#                 row[names[i]*"_signal_strength"] = signal
#             end
#             if buff[1] == 'G'
#                 data.GPS = vcat(data.GPS, DataFrame(row))
#             elseif buff[1] == 'R'
#                 data.GLONASS = vcat(data.GLONASS, DataFrame(row))
#             elseif buff[1] == 'E'
#                 data.GALILEO = vcat(data.GALILEO, DataFrame(row))
#             elseif buff[1] == 'C'
#                 data.BEIDOU = vcat(data.BEIDOU, DataFrame(row))
#             elseif buff[1] == 'S'
#                 data.SBAS = vcat(data.SBAS, DataFrame(row))
#             elseif buff[1] == 'J'
#                 data.QZSS = vcat(data.QZSS, DataFrame(row))
#             elseif buff[1] == 'I'
#                 data.IRNSS = vcat(data.IRNSS, DataFrame(row))
#             else
#                 println("WARNING: Unknown system $buff")
#             end
#         end
#     end
#     return data
# end
