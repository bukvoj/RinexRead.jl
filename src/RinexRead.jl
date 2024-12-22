module RinexRead
    using DataFrames
    using TimesDates # TimeDate is like DateTime but with nanosecond precision

    # Utility functions
    include("utils.jl")

    # Abstract types and structs
    include("headerlabels.jl")
    include("abstractheader.jl")
    include("abstractbody.jl")

    # Header parsing
    include("headerparse.jl")

    # Body parsing
    include("navdatareaders.jl")
    include("bodyparse.jl")

    struct RinexContent
        header::RinexHeader
        data::RinexBody
    end

    function rinexread(file::String)
        f = open(file, "r")
        header = readheader(f)

        body = parsebody!(f, header)

        close(f)
        return RinexContent(header, body)
    end

    Base.iterate(content::RinexContent, state=1) = 
        state == 1 ? (content.header, 2) : 
        state == 2 ? (content.data, nothing) : 
        nothing

export rinexread,
    RinexContent,
    RinexHeader,
    RNXType,
    NavigationFile,
    ObservationFile



end
