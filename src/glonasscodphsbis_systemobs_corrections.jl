struct GlonassCodPhsBis
    C1C::Real
    C1P::Real
    C2C::Real
    C2P::Real
end
GlonassCodPhsBis() = GlonassCodPhsBis(0.0, 0.0, 0.0, 0.0)

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