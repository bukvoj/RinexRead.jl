abstract type RinexHeader end

mutable struct ObsHeader <: RinexHeader
    version::Number
    filetype::Char
    constellations::Char
    str::String
    pgm::String
    runby::String
    date::DateTime
    marker::Marker
    observer::String
    agency::String
    receiver::Receiver
    antenna::Antenna
    systems::Dict{Char, SystemObs}
    time_of_first_obs::DateTime
    sys_phase_shift::Dict{Tuple, Real}
    glonass_slot_frq::GlonassSlots
    glonass_cod_phs_bis::GlonassCodPhsBis
    optional::Dict{String, Any}
end
ObsHeader() = ObsHeader(3.0, 
                        'O',
                        'G',
                        "",
                        "",
                        "",
                        DateTime(0),
                        Marker(),
                        "",
                        "",
                        Receiver(),
                        Antenna(),
                        Dict('G' => SystemObs()),
                        DateTime(0),
                        Dict(('G',"C1C",0) => 0.0),
                        GlonassSlots(),
                        GlonassCodPhsBis(),
                        Dict())

mutable struct NavHeader <: RinexHeader
    version::Number
    filetype::Char
    constellations::Char
    str::String
end
