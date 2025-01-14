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
    header =  NavHeader()
    header.version = version
    header.constellations = constellation
    header.str = str
    
    strlines = split(str, '\n')
    for l in strlines
        lineparse!(header::NavHeader,HEADER_LABELS[strip(l[61:end])], string(l))
    end
    return header
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

function lineparse!(header::ObsHeader,::Type{PgmRunbyDate}, line::String)
    header.pgm = line[1:20]
    header.runby = line[21:40]
    header.date = TimeDate(parse(Int, line[41:44]), 
                            parse(Int, line[45:46]), 
                            parse(Int, line[47:48]),
                            parse(Int, line[50:51]),
                            parse(Int, line[52:53]),
                            parse(Int, line[54:55]))
    if !occursin("UTC", line)
        println("Warning: Date is not in UTC")
    end
end

function lineparse!(header::ObsHeader,::Type{RinexVersionType}, line::String)
    nothing
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
    header.optional["SIGNAL STRENGTH UNIT"] = line[1:20]
end

function lineparse!(header::ObsHeader,::Type{Interval}, line::String)
    header.optional["INTERVAL"] = parse_withwhitespace(line[1:10], Float64)
end

function lineparse!(header::ObsHeader,::Type{TimeOfFirstObs}, line::String)
    header.time_of_first_obs = TimeDate(line[1:43], "  yyyy    mm    dd    HH    MM   SS.sssssss")
end

function lineparse!(header::ObsHeader,::Type{TimeOfLastObs}, line::String)
    header.optional["TIME OF LAST OBS"] = TimeDate(line[1:43], "  yyyy    mm    dd    HH    MM   SS.sssssss")
end

function lineparse!(header::ObsHeader,::Type{RcvClockOffsAppl}, line::String)
    header.optional["RCV CLOCK OFFS APPL"] = occursin("1", line[1:6])
end

function lineparse!(header::ObsHeader,::Type{SysDcbsApplied}, line::String)
    constellation = line[1]
    program = line[2:20]
    url = line[21:60]
    if haskey(header.optional, "SYS / DCBS APPLIED")
        push!(header.optional["SYS / DCBS APPLIED"], Corrections(constellation, program, url))
    else
        header.optional["SYS / DCBS APPLIED"] = [Corrections(constellation, program, url)]
    end
end

function lineparse!(header::ObsHeader,::Type{SysPcvsApplied}, line::String)
    constellation = line[1]
    program = line[2:20]
    url = line[21:60]
    if haskey(header.optional, "SYS / PCVS APPLIED")
        push!(header.optional["SYS / PCVS APPLIED"], Corrections(constellation, program, url))
    else
        header.optional["SYS / PCVS APPLIED"] = [Corrections(constellation, program, url)]
    end
end

function lineparse!(header::ObsHeader,::Type{SysScaleFactor}, line::String)
    constellation = line[1]
    factor = parse_withwhitespace(line[3:6], Int)
    factor = isnan(factor) ? 1 : factor
    number_of_types = parse_withwhitespace(line[9:11], Int)
    number_of_types = isnan(number_of_types) ? header.system[constellation].number_of_observables : number_of_types
    if number_of_types > 12
        println("DANGER: TOO MANY OBSERVABLES IN SCALE FACTOR, CONTINUATION LINE NOT IMPLEMENTED")
        return
    end    
    types = [line[13+i*4:15+i*4] for i in 0:number_of_types-1]
    if haskey(header.optional, "SYS / SCALE FACTOR")
        for t in types
            header.optional["SYS / SCALE FACTOR"][(constellation,t)] = factor
        end
    else
        header.optional["SYS / SCALE FACTOR"] = Dict{Tuple, Real}()
        for t in types
            header.optional["SYS / SCALE FACTOR"][(constellation,t)] = factor
        end
    end
end

function lineparse!(header::ObsHeader,::Type{SysPhaseShift}, line::String)
    constellation = line[1]
    obs_code = line[3:5]
    correction_applied = parse_withwhitespace(line[7:14], Float64)
    correction_applied = isnan(correction_applied) ? 0 : correction_applied
    number_of_sats = parse_withwhitespace(line[15:19], Int)
    number_of_sats = isnan(number_of_sats) ? 0 : number_of_sats # 0 means all
    if number_of_sats > 10
        println("DANGER: TOO MANY SATELLITES IN PHASE SHIFT, CONTINUATION LINE NOT IMPLEMENTED")
        return
    end
    if number_of_sats == 0
        list_of_sats = 0
    else
        list_of_sats = [parse(Int, line[21+i*4:22+i*4]) for i in 0:number_of_sats-1]
    end
    for sv in list_of_sats
        header.sys_phase_shift[(constellation, obs_code, sv)] = correction_applied
    end
end

function lineparse!(header::ObsHeader,::Type{GlonassSlots}, line::String)
    for i in 0:7
        slot = parse_withwhitespace(line[6+i*7:7+i*7], Int)
        freq = parse_withwhitespace(line[9+i*7:10+i*7], Int)
        if !isnan(slot)
            header.glonass_slot_frq[slot] = freq
        end
    end
end

function lineparse!(header::ObsHeader,::Type{GlonassCodPhsBis}, line::String)
    c1c = parse_withwhitespace(line[6:13], Float64)
    c1p = parse_withwhitespace(line[19:26], Float64)
    c2c = parse_withwhitespace(line[32:39], Float64)
    c2p = parse_withwhitespace(line[45:52], Float64)
    header.glonass_cod_phs_bis = GlonassCodPhsBis(c1c, c1p, c2c, c2p)
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
    header.optional["LEAP SECONDS"] = LeapSeconds(current, future, week_number, day_of_week, constellation)
end

function lineparse!(header::ObsHeader,::Type{NumSatellites}, line::String)
    header.optional["# OF SATELLITES"] = parse(Int, line[1:6])
end

function lineparse!(header::ObsHeader,::Type{PrnObsTypes}, line::String)
    println("Warning: PRN / # OF OBS parsing not supported, skipping line")
end

function lineparse!(header::ObsHeader,::Type{EndOfHeader}, line::String)
    nothing
end

function lineparse!(header::ObsHeader,::Type{<:HeaderLabels}, line::String)
    println("WARNING: Unknown Header Label encountered")
end

# START OF NAVIGATION FILE PARSING
function lineparse!(header::NavHeader,::Type{PgmRunbyDate}, line::String)
    header.pgm = line[1:20]
    header.runby = line[21:40]
    header.date = TimeDate(parse(Int, line[41:44]), 
                            parse(Int, line[45:46]), 
                            parse(Int, line[47:48]),
                            parse(Int, line[50:51]),
                            parse(Int, line[52:53]),
                            parse(Int, line[54:55]))
    if !occursin("UTC", line)
        println("Warning: Date is not in UTC")
    end
end

function lineparse!(header::NavHeader,::Type{Comment}, line::String)
    nothing # YOU CAN READ THEM IN THE STRING IF YOU WANT....
end

function lineparse!(header::NavHeader,::Type{IonosphericCorrections}, line::String)
    constellation = line[1:4]
    params = [parse_withwhitespace(replace(line[6+i*12:17+i*12], 'D'=>'e', 'E'=>'e', 'd'=>'e'), Float64) for i in 0:3]
    if constellation == "GAL "
        header.ionocorrections.GALILEO = (a0 = params[1], a1 = params[2], a2 = params[3])
    elseif constellation == "GPSA"
        seta!(header.ionocorrections.GPS, params...)
    elseif constellation == "GPSB"
        setb!(header.ionocorrections.GPS, params...)
    elseif constellation == "QZSA"
        seta!(header.ionocorrections.QZSS, params...)
    elseif constellation == "QZSB"
        setb!(header.ionocorrections.QZSS, params...)
    elseif constellation == "BDSA"
        seta!(header.ionocorrections.BEIDOU, params...)
    elseif constellation == "BDSB"
        setb!(header.ionocorrections.BEIDOU, params...)
    elseif constellation == "IRNA"
        seta!(header.ionocorrections.IRNSS, params...)
    elseif constellation == "IRNB"
        setb!(header.ionocorrections.IRNSS, params...)
    else
        println("WARNING: Unknown constellation encountered: ", constellation)
    end
end

function lineparse!(header::NavHeader,::Type{TimeSystemCorrections}, line::String)
    constellation = line[1:4]
    a0 = parse_withwhitespace(replace(line[5:22], "D"=>"e", "E"=>"e", "d"=>"e"), Float64)
    a1 = parse_withwhitespace(replace(line[23:38], "D"=>"e", "E"=>"e", "d"=>"e"), Float64)
    reftime = parse_withwhitespace(line[39:45], Int)
    refweek = parse_withwhitespace(line[46:50], Int)
    source = line[52:56]
    utcidentifier = parse_withwhitespace(line[58:59], Int)
    utcidentifier = isnan(utcidentifier) ? 0 : utcidentifier
    header.timecorrections[constellation] = TimeSystemCorrection(a0, a1, reftime, refweek, source, utcidentifier)
end

function lineparse!(header::NavHeader,::Type{LeapSeconds}, line::String)
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
    header.leapseconds = LeapSeconds(current, future, week_number, day_of_week, constellation)
end

function lineparse!(header::NavHeader,::Type{EndOfHeader}, line::String)
    nothing
end

function lineparse!(header::NavHeader,::Type{RinexVersionType}, line::String)
    nothing
end

function lineparse!(header::NavHeader,::Type{<:HeaderLabels}, line::String)
    println("WARNING: Unknown Header Label encountered")
end