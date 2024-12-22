function readgpsnavdata!(stream::IOStream)
    satellite_id = readint(stream)

    year = readint(stream)
    month = readint(stream)
    day = readint(stream)
    hour = readint(stream)
    minute = readint(stream)
    second = readint(stream)

    time = TimeDate(year, month, day, hour, minute, second)

    # Read the data
    clk_bias = readfloat(stream)
    clk_drift = readfloat(stream)
    clk_drift_rate = readfloat(stream)

    iode = readfloat(stream)
    crs = readfloat(stream)
    delta_n = readfloat(stream)
    m0 = readfloat(stream)

    cuc = readfloat(stream)
    e = readfloat(stream)
    cus = readfloat(stream)
    sqrt_a = readfloat(stream)

    toe = readfloat(stream)
    cic = readfloat(stream)
    omega0 = readfloat(stream)
    cis = readfloat(stream)

    i0 = readfloat(stream)
    crc = readfloat(stream)
    omega = readfloat(stream)
    omega_dot = readfloat(stream)

    idot = readfloat(stream)
    codes = readfloat(stream)
    week = readfloat(stream)
    l2pdataflag = readfloat(stream)

    satellite_accuracy = readfloat(stream)
    satellite_health = readfloat(stream)
    tgd = readfloat(stream)
    iodc = readfloat(stream)

    transmission_time = readfloat(stream)
    fit_interval = readfloat(stream)



    return DataFrame(
        Time = time,
        SatelliteID = satellite_id,
        SVClockBias = clk_bias,
        SVClockDrift = clk_drift,
        SVClockDriftRate = clk_drift_rate,
        IODE = iode,
        Crs = crs,
        Delta_n = delta_n,
        M0 = m0,
        Cuc = cuc,
        Eccentricity = e,
        Cus = cus,
        sqrtA = sqrt_a,
        Toe = toe,
        Cic = cic,
        OMEGA0 = omega0,
        Cis = cis,
        i0 = i0,
        Crc = crc,
        omega = omega,
        OMEGA_DOT = omega_dot,
        IDOT = idot,
        L2ChannelCodes = codes,
        GPSWeek = week,
        L2PDataFlag = l2pdataflag,
        SVAccuracy = satellite_accuracy,
        SVHealth = satellite_health,
        TGD = tgd,
        IODC = iodc,
        TransmissionTime = transmission_time,
        FitInterval = fit_interval
    )
end

function readgalileonavdata!(stream::IOStream)
    satellite_id = readint(stream)

    year = readint(stream)
    month = readint(stream)
    day = readint(stream)
    hour = readint(stream)
    minute = readint(stream)
    second = readint(stream)

    time = TimeDate(year, month, day, hour, minute, second)

    # Read the data
    clk_bias = readfloat(stream)
    clk_drift = readfloat(stream)
    clk_drift_rate = readfloat(stream)

    iode = readfloat(stream)
    crs = readfloat(stream)
    delta_n = readfloat(stream)
    m0 = readfloat(stream)

    cuc = readfloat(stream)
    e = readfloat(stream)
    cus = readfloat(stream)
    sqrt_a = readfloat(stream)

    toe = readfloat(stream)
    cic = readfloat(stream)
    omega0 = readfloat(stream)
    cis = readfloat(stream)

    i0 = readfloat(stream)
    crc = readfloat(stream)
    omega = readfloat(stream)
    omega_dot = readfloat(stream)

    idot = readfloat(stream)
    datasources = readfloat(stream)
    week = readfloat(stream)
    spare = readfloat(stream)

    signalaccuracy = readfloat(stream)
    satellite_health = readfloat(stream)
    bgd_e1e5a = readfloat(stream)
    bgd_e1e5b = readfloat(stream)

    transmission_time = readfloat(stream)
    #3 spares....
    readuntil(stream, '\n')

    return DataFrame(
        Time = time,
        SatelliteID = satellite_id,
        SVClockBias = clk_bias,
        SVClockDrift = clk_drift,
        SVClockDriftRate = clk_drift_rate,
        IODnav = iode,
        Crs = crs,
        delta_n = delta_n,
        M0 = m0,
        Cuc = cuc,
        Eccentricity = e,
        Cus = cus,
        sqrtA = sqrt_a,
        Toe = toe,
        Cic = cic,
        OMEGA0 = omega0,
        Cis = cis,
        i0 = i0,
        Crc = crc,
        omega = omega,
        OMEGA_DOT = omega_dot,
        IDOT = idot,
        DataSources = datasources, # TODO: should be a bitfield...
        GALWeek = week,
        SISAccuracy = signalaccuracy,
        SVHealth = satellite_health,
        BGDE5aE1 = bgd_e1e5a,
        BGDE5bE1 = bgd_e1e5b,
        TransmissionTime = transmission_time
    )
end

function readglonassnavdata!(stream::IOStream)
    satellite_id = readint(stream)

    year = readint(stream)
    month = readint(stream)
    day = readint(stream)
    hour = readint(stream)
    minute = readint(stream)
    second = readint(stream)

    time = TimeDate(year, month, day, hour, minute, second)

    # Read the data
    clk_bias = readfloat(stream)
    clkrelativefreqbias = readfloat(stream)
    msgframetime = readfloat(stream)

    satellite_position_x = readfloat(stream)
    satellite_velocity_x = readfloat(stream)
    satellite_acceleration_x = readfloat(stream)
    satellite_health = readfloat(stream)

    satellite_position_y = readfloat(stream)
    satellite_velocity_y = readfloat(stream)
    satellite_acceleration_y = readfloat(stream)
    freqnum = readfloat(stream)

    satellite_position_z = readfloat(stream)
    satellite_velocity_z = readfloat(stream)
    satellite_acceleration_z = readfloat(stream)
    ageofopinfo = readfloat(stream)

    return DataFrame(
        Time = time,
        SatelliteID = satellite_id,
        SVClockBias = clk_bias,
        SVFrequencyBias = clkrelativefreqbias,
        MessageFrameTime = msgframetime,
        PositionX = satellite_position_x,
        VelocityX = satellite_velocity_x,
        AccelerationX = satellite_acceleration_x,
        Health = satellite_health,
        PositionY = satellite_position_y,
        VelocityY = satellite_velocity_y,
        AccelerationY = satellite_acceleration_y,
        FrequencyNumber = freqnum,
        PositionZ = satellite_position_z,
        VelocityZ = satellite_velocity_z,
        AccelerationZ = satellite_acceleration_z,
        AgeOperationInfo = ageofopinfo
    )
end

function readqzssnavdata!(stream::IOStream)
    satellite_id = readint(stream)

    year = readint(stream)
    month = readint(stream)
    day = readint(stream)
    hour = readint(stream)
    minute = readint(stream)
    second = readint(stream)

    time = TimeDate(year, month, day, hour, minute, second)

    # Read the data
    clk_bias = readfloat(stream)
    clk_drift = readfloat(stream)
    clk_drift_rate = readfloat(stream)

    iode = readfloat(stream)
    crs = readfloat(stream)
    delta_n = readfloat(stream)
    m0 = readfloat(stream)

    cuc = readfloat(stream)
    e = readfloat(stream)
    cus = readfloat(stream)
    sqrt_a = readfloat(stream)

    toe = readfloat(stream)
    cic = readfloat(stream)
    omega0 = readfloat(stream)
    cis = readfloat(stream)

    i0 = readfloat(stream)
    crc = readfloat(stream)
    omega = readfloat(stream)
    omega_dot = readfloat(stream)

    idot = readfloat(stream)
    codes = readfloat(stream)
    week = readfloat(stream)
    l2pdataflag = readfloat(stream)

    satellite_accuracy = readfloat(stream)
    satellite_health = readfloat(stream)
    tgd = readfloat(stream)
    iodc = readfloat(stream)

    transmission_time = readfloat(stream)
    fit_interval = readfloat(stream)

    return DataFrame(
        Time = time,
        SatelliteID = satellite_id,
        SVClockBias = clk_bias,
        SVClockDrift = clk_drift,
        SVClockDriftRate = clk_drift_rate,
        IODE = iode,
        Crs = crs,
        Delta_n = delta_n,
        M0 = m0,
        Cuc = cuc,
        Eccentricity = e,
        Cus = cus,
        sqrtA = sqrt_a,
        Toe = toe,
        Cic = cic,
        OMEGA0 = omega0,
        Cis = cis,
        i0 = i0,
        Crc = crc,
        omega = omega,
        OMEGA_DOT = omega_dot,
        IDOT = idot,
        L2ChannelCodes = codes,
        GPSWeek = week,
        L2PDataFlag = l2pdataflag,
        SVAccuracy = satellite_accuracy,
        SVHealth = satellite_health,
        TGD = tgd,
        IODC = iodc,
        TransmissionTime = transmission_time,
        FitInterval = fit_interval
    )
end

function readbeidounavdata!(stream::IOStream)
    satellite_id = readint(stream)

    year = readint(stream)
    month = readint(stream)
    day = readint(stream)
    hour = readint(stream)
    minute = readint(stream)
    second = readint(stream)

    time = TimeDate(year, month, day, hour, minute, second)

    # Read the data
    clk_bias = readfloat(stream)
    clk_drift = readfloat(stream)
    clk_drift_rate = readfloat(stream)

    aode = readfloat(stream)
    crs = readfloat(stream)
    delta_n = readfloat(stream)
    m0 = readfloat(stream)

    cuc = readfloat(stream)
    e = readfloat(stream)
    cus = readfloat(stream)
    sqrt_a = readfloat(stream)

    toe = readfloat(stream)
    cic = readfloat(stream)
    omega0 = readfloat(stream)
    cis = readfloat(stream)

    i0 = readfloat(stream)
    crc = readfloat(stream)
    omega = readfloat(stream)
    omega_dot = readfloat(stream)

    idot = readfloat(stream)
    spare = readfloat(stream)
    week = readfloat(stream)
    spare = readfloat(stream)

    satellite_accuracy = readfloat(stream)
    satellite_health = readfloat(stream)
    tgd1 = readfloat(stream)
    tgd2 = readfloat(stream)

    transmission_time = readfloat(stream)
    aodc = readfloat(stream)

    return DataFrame(
        Time = time,
        SVClockBias = clk_bias,
        SVClockDrift = clk_drift,
        SVClockDriftRate = clk_drift_rate,
        SatelliteID = satellite_id,
        AODE = aode,
        Crs = crs,
        Delta_n = delta_n,
        M0 = m0,
        Cuc = cuc,
        Eccentricity = e,
        Cus = cus,
        sqrtA = sqrt_a,
        Toe = toe,
        Cic = cic,
        OMEGA0 = omega0,
        Cis = cis,
        i0 = i0,
        Crc = crc,
        omega = omega,
        OMEGA_DOT = omega_dot,
        IDOT = idot,
        BDTWeek = week,
        SVAccuracy = satellite_accuracy,
        SatH1 = satellite_health,
        TGD1 = tgd1,
        TGD2 = tgd2,
        TransmissionTime = transmission_time,
        AODC = aodc
    )
end

function readsbasnavdata!(stream::IOStream)
    satellite_id = readint(stream)

    year = readint(stream)
    month = readint(stream)
    day = readint(stream)
    hour = readint(stream)
    minute = readint(stream)
    second = readint(stream)

    time = TimeDate(year, month, day, hour, minute, second)

    # Read the data
    clk_bias = readfloat(stream)
    clkrelativefreqbias = readfloat(stream)
    transmission_time = readfloat(stream)

    satellite_position_x = readfloat(stream)
    satellite_velocity_x = readfloat(stream)
    satellite_acceleration_x = readfloat(stream)
    satellite_health = readfloat(stream)

    satellite_position_y = readfloat(stream)
    satellite_velocity_y = readfloat(stream)
    satellite_acceleration_y = readfloat(stream)
    codeaccuracy = readfloat(stream)

    satellite_position_z = readfloat(stream)
    satellite_velocity_z = readfloat(stream)
    satellite_acceleration_z = readfloat(stream)
    iodn = readfloat(stream)

    return DataFrame(
        SatelliteID = satellite_id,
        Time = time,
        SVClockBias = clk_bias,
        SVFrequencyBias = clkrelativefreqbias,
        TransmissionTime = transmission_time,
        PositionX = satellite_position_x,
        VelocityX = satellite_velocity_x,
        AccelerationX = satellite_acceleration_x,
        Health = satellite_health,
        PositionY = satellite_position_y,
        VelocityY = satellite_velocity_y,
        AccelerationY = satellite_acceleration_y,
        AccuracyCode = codeaccuracy,
        PositionZ = satellite_position_z,
        VelocityZ = satellite_velocity_z,
        AccelerationZ = satellite_acceleration_z,
        IODN = iodn
    )
end

function readirnssnavdata!(stream::IOStream)
    satellite_id = readint(stream)

    year = readint(stream)
    month = readint(stream)
    day = readint(stream)
    hour = readint(stream)
    minute = readint(stream)
    second = readint(stream)

    time = TimeDate(year, month, day, hour, minute, second)

    # Read the data
    clk_bias = readfloat(stream)
    clk_drift = readfloat(stream)
    clk_drift_rate = readfloat(stream)

    iode = readfloat(stream)
    crs = readfloat(stream)
    delta_n = readfloat(stream)
    m0 = readfloat(stream)

    cuc = readfloat(stream)
    e = readfloat(stream)
    cus = readfloat(stream)
    sqrt_a = readfloat(stream)

    toe = readfloat(stream)
    cic = readfloat(stream)
    omega0 = readfloat(stream)
    cis = readfloat(stream)

    i0 = readfloat(stream)
    crc = readfloat(stream)
    omega = readfloat(stream)
    omega_dot = readfloat(stream)

    idot = readfloat(stream)
    spare = readfloat(stream)
    week = readfloat(stream)
    spare = readfloat(stream)

    userrangeaccuracy = readfloat(stream)
    satellite_health = readfloat(stream)
    tgd = readfloat(stream)
    spare = readfloat(stream)

    transmission_time = readfloat(stream)

    return DataFrame(
        Time = time,
        SatelliteID = satellite_id,
        SVClockBias = clk_bias,
        SVClockDrift = clk_drift,
        SVClockDriftRate = clk_drift_rate,
        IODE = iode,
        Crs = crs,
        Delta_n = delta_n,
        M0 = m0,
        Cuc = cuc,
        Eccentricity = e,
        Cus = cus,
        sqrtA = sqrt_a,
        Toe = toe,
        Cic = cic,
        OMEGA0 = omega0,
        Cis = cis,
        i0 = i0,
        Crc = crc,
        omega = omega,
        OMEGA_DOT = omega_dot,
        IDOT = idot,
        Week = week,
        UserRangeAccuracy = userrangeaccuracy,
        Health = satellite_health,
        TGD = tgd,
        TransmissionTime = transmission_time
    )
end