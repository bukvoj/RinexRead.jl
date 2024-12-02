

function readheader(stream::IOStream)
    str = readuntil(stream, "END OF HEADER"; keep=true) * readuntil(stream, '\n')
    if occursin("RINEX VERSION / TYPE", str[61:end])
        version = parse(Float64, str[1:9])
        file_type = str[21]
        constellations = str[41]
    else 
        print("ERROR: FIRST LINE MUST BE RINEX VERSION / TYPE")
        return nothing
    end

    if file_type == 'N'
        return readheader(str, NavigationFile; version=version, constellation=constellations)
    elseif file_type == 'O'
        return readheader(str, ObservationFile; version=version, constellation=constellations)
    else
        print("ERROR: FILE TYPE NOT RECOGNIZED")
        return nothing
    end

end


function readheader(str::String, ::Type{NavigationFile}; version=3.0, constellation='M')
    return NavHeader(version, 'N', constellation, str) # NOT IMPLEMENTED 
end

function readheader(str::String, ::Type{ObservationFile}; version=3.0, constellation='M')
    header = ObsHeader()
    header.version = version
    header.constellations = constellation
    header.str = str

    strlines = split(str, '\n')
    for l in strlines
        lineparse!(header::ObsHeader,HEADER_LABELS[strip(l[61:end])], string(l))
    end
    return header
end

function lineparse!(header::ObsHeader,::Type{RinexVersionType}, line::String)
    nothing
end

function lineparse!(header::ObsHeader,::Type{PgmRunbyDate}, line::String)
    header.pgm = line[1:20]
    header.runby = line[21:40]
    header.date = DateTime(parse(Int, line[41:44]), 
                            parse(Int, line[45:46]), 
                            parse(Int, line[47:48]),
                            parse(Int, line[50:51]),
                            parse(Int, line[52:53]),
                            parse(Int, line[54:55]))
    if !occursin("UTC", line)
        println("Warning: Date is not in UTC")
    end
end

function lineparse!(header::ObsHeader,::Type{Comment}, line::String)
    nothing # YOU CAN READ THEM IN THE STRING IF YOU WANT....
end

function lineparse!(header::ObsHeader,::Type{MarkerName}, line::String)
    header.marker.name = line[1:60]
end

function lineparse!(header::ObsHeader,::Type{MarkerNumber}, line::String)
    header.marker.number = line[1:20]
end

function lineparse!(header::ObsHeader,::Type{MarkerType}, line::String)
    header.marker.type = line[1:20]
end

function lineparse!(header::ObsHeader,::Type{Observer}, line::String)
    header.observer = line[1:20]
    header.agency = line[21:60]
end

function lineparse!(header::ObsHeader,::Type{RecNumberTypeVers}, line::String)
    header.receiver = Receiver(line[1:20], line[21:40], line[41:60])
end

function lineparse!(header::ObsHeader,::Type{AntNumberType}, line::String)
    header.antenna.number = line[1:20]
    header.antenna.type = line[21:40]
end

function lineparse!(header::ObsHeader,::Type{ApproxPositionXYZ}, line::String)
    x = parse_withwhitespace(line[1:14], Float64)
    y = parse_withwhitespace(line[15:28], Float64)
    z = parse_withwhitespace(line[29:42], Float64)
    header.antenna.xyz = [x, y, z]
end

function lineparse!(header::ObsHeader,::Type{AntennaDeltaHEN}, line::String)
    h = parse_withwhitespace(line[1:14], Float64)
    e = parse_withwhitespace(line[15:28], Float64)
    n = parse_withwhitespace(line[29:42], Float64)
    header.antenna.delta_hen = [h,e,n]
end

function lineparse!(header::ObsHeader,::Type{AntennaDeltaXYZ}, line::String)
    x = parse_withwhitespace(line[1:14], Float64)
    y = parse_withwhitespace(line[15:28], Float64)
    z = parse_withwhitespace(line[29:42], Float64)
    header.antenna.delta_xyz = [x, y, z]
end

function lineparse!(header::ObsHeader,::Type{AntennaPhaseCenter}, line::String)
    println("AntennaPhaseCenter parsing not implemented. WIP") # TODO
end

function lineparse!(header::ObsHeader,::Type{AntennaBsight}, line::String)
    x = parse_withwhitespace(line[1:14], Float64)
    y = parse_withwhitespace(line[15:28], Float64)
    z = parse_withwhitespace(line[29:42], Float64)
    header.antenna.bsight = [x, y, z]
end

function lineparse!(header::ObsHeader,::Type{AntennaZerodirXYZ}, line::String)
    x = parse_withwhitespace(line[1:14], Float64)
    y = parse_withwhitespace(line[15:28], Float64)
    z = parse_withwhitespace(line[29:42], Float64)
    header.antenna.zerodir_xyz = [x, y, z]
end

function lineparse!(header::ObsHeader,::Type{AntennaZerodirAzi}, line::String)
    header.antenna.zerodir_azi = parse_withwhitespace(line[1:14], Float64)
end

function lineparse!(header::ObsHeader,::Type{AntennaCenterOfMass}, line::String)
    x = parse_withwhitespace(line[1:14], Float64)
    y = parse_withwhitespace(line[15:28], Float64)
    z = parse_withwhitespace(line[29:42], Float64)
    header.antenna.center_of_mass = [x, y, z]
end

function lineparse!(header::ObsHeader,::Type{SystemObsType}, line::String)
    println("SystemObsType")
end

function lineparse!(header::ObsHeader,::Type{SignalStrengthUnit}, line::String)
    println("SignalStrengthUnit")
end

function lineparse!(header::ObsHeader,::Type{Interval}, line::String)
    println("Interval")
end

function lineparse!(header::ObsHeader,::Type{TimeOfFirstObs}, line::String)
    println("TimeOfFirstObs")
end

function lineparse!(header::ObsHeader,::Type{TimeOfLastObs}, line::String)
    println("TimeOfLastObs")
end

function lineparse!(header::ObsHeader,::Type{RcvClockOffsAppl}, line::String)
    println("RcvClockOffsAppl")
end

function lineparse!(header::ObsHeader,::Type{SysDcbsApplied}, line::String)
    println("SysDcbsApplied")
end

function lineparse!(header::ObsHeader,::Type{SysPcvsApplied}, line::String)
    println("SysPcvsApplied")
end

function lineparse!(header::ObsHeader,::Type{SysScaleFactor}, line::String)
    println("SysScaleFactor")
end

function lineparse!(header::ObsHeader,::Type{SysPhaseShift}, line::String)
    println("SysPhaseShift")
end

function lineparse!(header::ObsHeader,::Type{GlonassSlotFrqNum}, line::String)
    println("GlonassSlotFrqNum")
end

function lineparse!(header::ObsHeader,::Type{GlonassCodPhsBis}, line::String)
    println("GlonassCodPhsBis")
end

function lineparse!(header::ObsHeader,::Type{LeapSeconds}, line::String)
    println("LeapSeconds")
end

function lineparse!(header::ObsHeader,::Type{NumSatellites}, line::String)
    println("NumSatellites")
end

function lineparse!(header::ObsHeader,::Type{PrnObsTypes}, line::String)
    println("PrnObsTypes")
end

function lineparse!(header::ObsHeader,::Type{EndOfHeader}, line::String)
    println("EndOfHeader")
end

function lineparse!(header::ObsHeader,::Type{<:HeaderLabels}, line::String)
    println("Unknown Header Label")
end

