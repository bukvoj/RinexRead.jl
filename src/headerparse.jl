

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
    println("RecNumberTypeVers")
end

function lineparse!(header::ObsHeader,::Type{AntNumberType}, line::String)
    println("AntNumberType")
end

function lineparse!(header::ObsHeader,::Type{ApproxPositionXYZ}, line::String)
    println("ApproxPositionXYZ")
end

function lineparse!(header::ObsHeader,::Type{AntennaDeltaHEN}, line::String)
    println("AntennaDeltaHEN")
end

function lineparse!(header::ObsHeader,::Type{AntennaDeltaXYZ}, line::String)
    println("AntennaDeltaXYZ")
end

function lineparse!(header::ObsHeader,::Type{AntennaPhaseCenter}, line::String)
    println("AntennaPhaseCenter")
end

function lineparse!(header::ObsHeader,::Type{AntennaBsight}, line::String)
    println("AntennaBsight")
end

function lineparse!(header::ObsHeader,::Type{AntennaZerodirXYZ}, line::String)
    println("AntennaZerodirXYZ")
end

function lineparse!(header::ObsHeader,::Type{AntennaZerodirAzi}, line::String)
    println("AntennaZerodirAzi")
end

function lineparse!(header::ObsHeader,::Type{AntennaCenterOfMass}, line::String)
    println("AntennaCenterOfMass")
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

