abstract type RinexHeader end

mutable struct ObsHeader <: RinexHeader
    version::Number
    filetype::Char
    constellations::Char
    str::String
    pgm::String
    runby::String
    date::TimeDate
    marker::Marker
    observer::String
    agency::String
    receiver::Receiver
    antenna::Antenna
    systems::Dict{Char, SystemObs}
    time_of_first_obs::TimeDate
    sys_phase_shift::Dict{Tuple, Real}
    glonass_slot_frq::Dict{Int, Int}
    glonass_cod_phs_bis::GlonassCodPhsBis
    optional::Dict{String, Any}
end
ObsHeader() = ObsHeader(3.0, 
                        'O',
                        'G',
                        "",
                        "",
                        "",
                        TimeDate(0),
                        Marker(),
                        "",
                        "",
                        Receiver(),
                        Antenna(),
                        Dict('G' => SystemObs()),
                        TimeDate(0),
                        Dict(('G',"C1C",0) => 0.0),
                        Dict(0=>0),
                        GlonassCodPhsBis(),
                        Dict())

mutable struct NavHeader <: RinexHeader
    version::Number
    filetype::Char
    constellations::Char
    str::String
    pgm::String
    runby::String
    date::TimeDate
    ionocorrections::IonosphericCorrections
    timecorrections::TimeSystemCorrections
    leapseconds::LeapSeconds
end
NavHeader() = NavHeader(3.0, 
                        'N',
                        'G',
                        "",
                        "",
                        "",
                        TimeDate(0),
                        IonosphericCorrections(),
                        TimeSystemCorrections(),
                        LeapSeconds())
