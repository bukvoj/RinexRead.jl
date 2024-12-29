mutable struct Antenna
    number::String
    type::String
    version::String
    xyz::Vector{Real}
    delta_xyz::Vector{Real}
    delta_hen::Vector{Real} # height, east/north eccentricity
    bsight::Vector{Real}
    zerodir_xyz::Vector{Real}
    phase_center::DataFrames.DataFrame
    zerodir_azi::Real
    center_of_mass::Vector{Real}
end
Antenna() = Antenna("", "", "",[[NaN,NaN,NaN] for i in 1:5]...,DataFrame(),NaN,[NaN,NaN,NaN])



mutable struct Marker
    name::String
    number::String
    type::String
end
Marker() = Marker("", "", "")

struct Receiver
    number::String
    type::String
    verion::String
end
Receiver() = Receiver("", "", "")