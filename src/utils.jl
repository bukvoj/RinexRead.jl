function readfloat(stream::IOStream)
    buff = read(stream, Char)
    while isspace(buff)
        buff = read(stream, Char)
    end
    while !isspace(buff[end])
        buff = buff * read(stream, Char)
    end
    buff = replace(buff, 'D' => 'E')
    buff = replace(buff, 'd' => 'E')
    return parse(Float64, buff)
end

function readint(stream::IOStream)
    buff = read(stream, Char)
    while isspace(buff)
        buff = read(stream, Char)
    end
    while !isspace(buff[end])
        buff = buff * read(stream, Char)
    end
    return parse(Int, buff)
end

function readint(string::String)
    i = 1
    buff = string[i]
    while isspace(buff)
        i += 1
        buff = string[i]
    end
    while !isspace(buff[end])
        buff = buff * read(stream, Char)
    end
    return parse(Int, buff)
end


function parse_withwhitespace(string::String, type::Type)
    if length(strip(string)) == 0
        return NaN
    end
    return parse(type, string)
end

function parse_withwhitespace(s::Char, type::Type)
    if !isspace(s)
        return parse(type, string(s))
    end
    return NaN
end



function TimesDates.TimeDate(string::String, format::String)
    year = parse(Int, join([string[id] for id in findall("y", format)]))
    month = parse(Int, join([string[id] for id in findall("m", format)]))
    day = parse(Int, join([string[id] for id in findall("d", format)]))
    hour = parse(Int, join([string[id] for id in findall("H", format)]))
    minute = parse(Int, join([string[id] for id in findall("M", format)]))
    second = parse(Int, join([string[id] for id in findall("S", format)]))
    fracsec = parse(Float64, join(["0.",join([string[id] for id in findall("s", format)])]))
    millisecond = Int(floor(fracsec*1000))
    microsecond = Int(floor(fracsec*1000000) - millisecond*1000)
    nanosecond = Int(floor(fracsec*1000000000) - millisecond*1000000 - microsecond*1000)
    return TimeDate(year, month, day, hour, minute, second, millisecond, microsecond, nanosecond)
end