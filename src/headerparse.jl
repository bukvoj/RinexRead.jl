

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
    constellation = line[1]
    obs_code = line[3:5]
    x = parse_withwhitespace(line[6:15], Float64)   #kinda sus but in table ....  
    y = parse_withwhitespace(line[16:29], Float64)  # TABLE A2 GNSS OBSERVATION DATA FILE - HEADER SECTION DESCRIPTION    
    z = parse_withwhitespace(line[30:43], Float64)  #https://files.igs.org/pub/data/format/rinex303.pdf
    phase_center = DataFrame(constellation=constellation, obs_code=obs_code, x=x, y=y, z=z)
    vcat!(header.antenna.phase_center, phase_center)
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
    constellation = line[1]
    number_of_observables = parse(Int, line[2:6])
    types = [line[8+i*4:10+i*4] for i in 0:number_of_observables-1]
    sysobstypes = SystemObs(constellation, number_of_observables, types)
    header.systems[constellation] = sysobstypes
end

function lineparse!(header::ObsHeader,::Type{SignalStrengthUnit}, line::String)
    header.optional["signal_strength_unit"] = line[1:20]
end

function lineparse!(header::ObsHeader,::Type{Interval}, line::String)
    header.optional["interval"] = parse_withwhitespace(line[1:10], Float64)
end

function lineparse!(header::ObsHeader,::Type{TimeOfFirstObs}, line::String)
    year = parse(Int, line[1:6])
    month = parse(Int, line[7:12])
    day = parse(Int, line[13:18])
    hour = parse(Int, line[19:24])
    minute = parse(Int, line[25:30])
    second = parse(Float64, line[31:43])
    millisecond = floor(1000 * (second - floor(second)))
    second = floor(second)
    header.time_of_first_obs = DateTime(year, month, day, hour, minute, second, millisecond)
end

function lineparse!(header::ObsHeader,::Type{TimeOfLastObs}, line::String)
    year = parse(Int, line[1:6])
    month = parse(Int, line[7:12])
    day = parse(Int, line[13:18])
    hour = parse(Int, line[19:24])
    minute = parse(Int, line[25:30])
    second = parse(Float64, line[31:43])
    millisecond = floor(1000 * (second - floor(second)))
    second = floor(second)
    header.optional["time_of_last_obs"] = DateTime(year, month, day, hour, minute, second, millisecond)
end

function lineparse!(header::ObsHeader,::Type{RcvClockOffsAppl}, line::String)
    header.optional["rcv_clock_offs_appl"] = occursin("1", line[1:6])
end

function lineparse!(header::ObsHeader,::Type{SysDcbsApplied}, line::String)
    constellation = line[1]
    program = line[2:20]
    url = line[21:60]
    if haskey(header.optional, "sys_dcbs_applied")
        push!(header.optional["sys_dcbs_applied"], Corrections(constellation, program, url))
    else
        header.optional["sys_dcbs_applied"] = [Corrections(constellation, program, url)]
    end
end

function lineparse!(header::ObsHeader,::Type{SysPcvsApplied}, line::String)
    constellation = line[1]
    program = line[2:20]
    url = line[21:60]
    if haskey(header.optional, "sys_pcvs_applied")
        push!(header.optional["sys_pcvs_applied"], Corrections(constellation, program, url))
    else
        header.optional["sys_pcvs_applied"] = [Corrections(constellation, program, url)]
    end
end

function lineparse!(header::ObsHeader,::Type{SysScaleFactor}, line::String)
    println("SysScaleFactor not IMPLEMENTED") # TODO TODO TODO
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
    current = parse_withwhitespace(line[1:6], Int)
    future = parse_withwhitespace(line[7:12], Int)
    week_number = parse_withwhitespace(line[13:18], Int)
    day_of_week = parse_withwhitespace(line[19:24], Int)
    time_system_id = line[25:27]
    if time_system_id == "BDS"
        constellation = 'C'
    else
        constellation = 'G'
    end
    header.optional["leap_seconds"] = LeapSeconds(current, future, week_number, day_of_week, constellation)
end

function lineparse!(header::ObsHeader,::Type{NumSatellites}, line::String)
    header.optional["num_satellites"] = parse(Int, line[1:6])
end

function lineparse!(header::ObsHeader,::Type{PrnObsTypes}, line::String)
    println("PrnObsTypes")
end

function lineparse!(header::ObsHeader,::Type{EndOfHeader}, line::String)
    nothing
end

function lineparse!(header::ObsHeader,::Type{<:HeaderLabels}, line::String)
    println("Unknown Header Label")
end

