using DataFrames
using Dates

include("utils.jl")
include("ephreaders.jl")


mutable struct NavData
    GPS::DataFrame
    GLONASS::DataFrame
    GALILEO::DataFrame
    BEIDOU::DataFrame
    SBAS::DataFrame
    QZSS::DataFrame
    IRNSS::DataFrame
end

struct NavRinex
    header::String
    data::NavData
end

function navheader!(stream::IOStream)
    # Read the header
    header = readuntil(stream, "END OF HEADER"; keep=true) * readuntil(stream, '\n')
    return header
end

function parse_nav_file(file::String)
    # Read the file
    stream = open(file, "r")
    header = navheader!(stream)

    data = NavData(
        DataFrame(),
        DataFrame(),
        DataFrame(),
        DataFrame(),
        DataFrame(),
        DataFrame(),
        DataFrame()
    )

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
    return header, data
end


#testing
path = "C:\\Users\\jakub\\gnss\\urban_canyon_gnss\\data\\2024_10_7\\rinex\\line22_fromhostivartopohorelec.24N"
header,data = parse_nav_file(path)
print(header)