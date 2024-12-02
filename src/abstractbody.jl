abstract type RNXType end
abstract type NavigationFile <: RNXType end
abstract type ObservationFile <: RNXType end

mutable struct RinexBody
    GPS::DataFrame
    GLONASS::DataFrame
    GALILEO::DataFrame
    BEIDOU::DataFrame
    SBAS::DataFrame
    QZSS::DataFrame
    IRNSS::DataFrame
end
RinexBody() = RinexBody(
        DataFrame(),
        DataFrame(),
        DataFrame(),
        DataFrame(),
        DataFrame(),
        DataFrame(),
        DataFrame()
    )