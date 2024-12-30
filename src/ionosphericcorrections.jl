mutable struct KlobucharParams
    # Klobuchar model parameters
    a0::Float64
    a1::Float64
    a2::Float64
    a3::Float64
    b0::Float64
    b1::Float64
    b2::Float64
    b3::Float64
end
KlobucharParams() = KlobucharParams(NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN)
function seta!(k::KlobucharParams, a0, a1, a2, a3)
    k.a0 = a0
    k.a1 = a1
    k.a2 = a2
    k.a3 = a3
end
function setb!(k::KlobucharParams, b0, b1, b2, b3)
    k.b0 = b0
    k.b1 = b1
    k.b2 = b2
    k.b3 = b3
end



mutable struct IonosphericCorrections
    # Ionospheric corrections
    GALILEO::NamedTuple{(:a0, :a1, :a2), Tuple{Float64, Float64, Float64}}
    GPS::KlobucharParams
    QZSS::KlobucharParams
    GLONASS::KlobucharParams
    IRNSS::KlobucharParams
    BEIDOU::KlobucharParams
end
IonosphericCorrections() = IonosphericCorrections(
    (a0 = NaN, a1 = NaN, a2 = NaN),
    KlobucharParams(NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN),
    KlobucharParams(NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN),
    KlobucharParams(NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN),
    KlobucharParams(NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN),
    KlobucharParams(NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN)
)