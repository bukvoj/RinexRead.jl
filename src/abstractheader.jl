abstract type RinexHeader end

mutable struct Marker
    name::String
    number::String
    type::String
end
Marker() = Marker("", "", "")

struct Receiver
    number::String
    type::String
    firmware::String
end
Receiver() = Receiver("", "", "")

mutable struct Antenna
    number::String
    type::String
    version::String
    xyz::Vector{Float64}
    delta_xyz::Vector{Float64}
    delta_hen::Vector{Float64}
    phase_center::Vector{Float64}
    bsight::Vector{Float64}
    zerodir_xyz::Vector{Float64}
    zerodir_azi::Vector{Float64}
    center_of_mass::Vector{Float64}
end
Antenna() = Antenna("", "", "",[[NaN,NaN,NaN] for i in 1:8]...)

struct SystemObs
    constellation::Char
    number_of_observables::Int
    types::Vector{String}
end
SystemObs() = SystemObs('G', 6, ["C1C", "L1C", "D1C", "C2X", "L2X", "D2X"])

struct Corrections 
    constellation::Char
    program::String
    url::String
end
Corrections() = Corrections(' ', "", "")

struct SysScaleFactor
    constellation::Char
    factor::Number
    number_of_observations::Number
    list_of_types::String
end
SystemScaleFactor() = SysScaleFactor('G', 1.0, 0, "")

struct SysPhaseShift
    constellation::Char
    observation_code::String
    correction_applied::Number
    number_of_sats::Number # 0 means all
    list_of_sats::Vector{String}
end
SysPhaseShift() = SysPhaseShift('G', "C1C", 0, 0, [])

struct GlonassSlots
    number_of_satellites::Int
    satellite_numbers::Vector{Int}
    frequency_numbers::Vector{Int}
end
GlonassSlots() = GlonassSlots(0, [], [])

struct GlonassCodPhsBis
    C1C::Real
    C1P::Real
    C2C::Real
    C2P::Real
end
GlonassCodPhsBis() = GlonassCodPhsBis(0.0, 0.0, 0.0, 0.0)

struct LeapSeconds
    current_leap_seconds::Int
    future_leap_seconds::Int
    week_number::Int
    day_of_week::Int
    time_system_id::String
end
LeapSeconds() = LeapSeconds(0, 0, 0, 0, "GPS")
LeapSeconds(ls::Int) = LeapSeconds(ls, ls, 0, 0, "GPS")

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
    sys_phase_shift::Dict{Char, SysPhaseShift}
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
                        Dict('G' => SysPhaseShift()),
                        GlonassSlots(),
                        GlonassCodPhsBis(),
                        Dict())

mutable struct NavHeader <: RinexHeader
    version::Number
    filetype::Char
    constellations::Char
    str::String
end
