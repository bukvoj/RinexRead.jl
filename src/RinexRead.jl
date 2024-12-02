module RinexRead
    using DataFrames
    using Dates

    # Utility functions
    include("utils.jl")

    # Abstract types and structs
    include("abstractheader.jl")
    include("headerlabels.jl")
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

export rinexread,
    RinexContent,
    RinexHeader,
    RNXType,
    NavigationFile,
    ObservationFile



end
