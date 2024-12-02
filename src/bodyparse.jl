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
    println("Parsing Observation File is not supported yet\n")
    return RinexBody()
end
