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
    for s in string
        if !isspace(s)
            return parse(type, string)
        end
    end
    return NaN
end