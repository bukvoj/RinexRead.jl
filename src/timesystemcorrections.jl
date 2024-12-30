struct TimeSystemCorrection
    a0::Float64
    a1::Float64
    reftime::Number # Reference time [seconds in week]
    refweek::Number # Reference week number
    source::String  # Source of the data (EGNOS,WAAS, etc.)
    utcidentifier::Int # UTC identifier
end
TimeSystemCorrection() = TimeSystemCorrection(NaN, NaN, 0, 0, "", 0)

# List of UTC identifiers:
# 0=Unknown
# 1=NIST
# 2=USNO
# 3=SU
# 4=BIPM
# 5=Europelab
# 6=CRL
# 7=NTSC (BDS)
# >7=Reserved




struct LeapSeconds
    current::Int
    future::Int
    week_number::Int
    day_of_week::Int
    time_system_id::Char
end
LeapSeconds() = LeapSeconds(0, 0, 0, 0, 'G')
LeapSeconds(ls::Int) = LeapSeconds(ls, ls, 0, 0, 'G')