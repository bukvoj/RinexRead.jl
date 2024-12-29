mutable struct TimeSystemCorrections
    # Time system corrections
    # TO BE IMPLEMENTED
end



struct LeapSeconds
    current::Int
    future::Int
    week_number::Int
    day_of_week::Int
    time_system_id::Char
end
LeapSeconds() = LeapSeconds(0, 0, 0, 0, 'G')
LeapSeconds(ls::Int) = LeapSeconds(ls, ls, 0, 0, 'G')