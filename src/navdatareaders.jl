function readgpsnavdata!(stream::IOStream)
    satellite_id = readint(stream)

    year = readint(stream)
    month = readint(stream)
    day = readint(stream)
    hour = readint(stream)
    minute = readint(stream)
    second = readint(stream)

    time = DateTime(year, month, day, hour, minute, second)

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
        time = time,
        satellite_id = satellite_id,
        clk_bias = clk_bias,
        clk_drift = clk_drift,
        clk_drift_rate = clk_drift_rate,
        iode = iode,
        crs = crs,
        delta_n = delta_n,
        m0 = m0,
        cuc = cuc,
        e = e,
        cus = cus,
        sqrt_a = sqrt_a,
        toe = toe,
        cic = cic,
        omega0 = omega0,
        cis = cis,
        i0 = i0,
        crc = crc,
        omega = omega,
        omega_dot = omega_dot,
        idot = idot,
        codes = codes,
        gps_week = week,
        l2pdataflag = l2pdataflag,
        satellite_accuracy = satellite_accuracy,
        satellite_health = satellite_health,
        tgd = tgd,
        iodc = iodc,
        transmission_time = transmission_time,
        fit_interval = fit_interval
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

    time = DateTime(year, month, day, hour, minute, second)

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
        time = time,
        satellite_id = satellite_id,
        clk_bias = clk_bias,
        clk_drift = clk_drift,
        clk_drift_rate = clk_drift_rate,
        iode = iode,
        crs = crs,
        delta_n = delta_n,
        m0 = m0,
        cuc = cuc,
        e = e,
        cus = cus,
        sqrt_a = sqrt_a,
        toe = toe,
        cic = cic,
        omega0 = omega0,
        cis = cis,
        i0 = i0,
        crc = crc,
        omega = omega,
        omega_dot = omega_dot,
        idot = idot,
        data_sources = datasources, # TODO: should be a bitfield...
        gal_week = week,
        sisa = signalaccuracy,
        satellite_health = satellite_health,
        bgd_e1e5a = bgd_e1e5a,
        bgd_e1e5b = bgd_e1e5b,
        transmission_time = transmission_time
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

    time = DateTime(year, month, day, hour, minute, second)

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
        time = time,
        satellite_id = satellite_id,
        clk_bias = clk_bias,
        clk_relative_freq_bias = clkrelativefreqbias,
        msg_frame_time = msgframetime,
        satellite_position_x = satellite_position_x,
        satellite_velocity_x = satellite_velocity_x,
        satellite_acceleration_x = satellite_acceleration_x,
        health = satellite_health,
        satellite_position_y = satellite_position_y,
        satellite_velocity_y = satellite_velocity_y,
        satellite_acceleration_y = satellite_acceleration_y,
        frequency_number = freqnum,
        satellite_position_z = satellite_position_z,
        satellite_velocity_z = satellite_velocity_z,
        satellite_acceleration_z = satellite_acceleration_z,
        age_of_op_info = ageofopinfo
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

    time = DateTime(year, month, day, hour, minute, second)

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
        time = time,
        satellite_id = satellite_id,
        clk_bias = clk_bias,
        clk_drift = clk_drift,
        clk_drift_rate = clk_drift_rate,
        iode = iode,
        crs = crs,
        delta_n = delta_n,
        m0 = m0,
        cuc = cuc,
        e = e,
        cus = cus,
        sqrt_a = sqrt_a,
        toe = toe,
        cic = cic,
        omega0 = omega0,
        cis = cis,
        i0 = i0,
        crc = crc,
        omega = omega,
        omega_dot = omega_dot,
        idot = idot,
        codes = codes,
        gps_week = week,
        l2pdataflag = l2pdataflag,
        satellite_accuracy = satellite_accuracy,
        satellite_health = satellite_health,
        tgd = tgd,
        iodc = iodc,
        transmission_time = transmission_time,
        fit_interval = fit_interval
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

    time = DateTime(year, month, day, hour, minute, second)

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
        time = time,
        clk_bias = clk_bias,
        clk_drift = clk_drift,
        clk_drift_rate = clk_drift_rate,
        satellite_id = satellite_id,
        aode = aode,
        crs = crs,
        delta_n = delta_n,
        m0 = m0,
        cuc = cuc,
        e = e,
        cus = cus,
        sqrt_a = sqrt_a,
        toe = toe,
        cic = cic,
        omega0 = omega0,
        cis = cis,
        i0 = i0,
        crc = crc,
        omega = omega,
        omega_dot = omega_dot,
        idot = idot,
        bdt_week = week,
        satellite_accuracy = satellite_accuracy,
        sath1 = satellite_health,
        tgd1 = tgd1,
        tgd2 = tgd2,
        transmission_time = transmission_time,
        aodc = aodc
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

    time = DateTime(year, month, day, hour, minute, second)

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
        satellite_id = satellite_id,
        time = time,
        clk_bias = clk_bias,
        clkrelativefreqbias = clkrelativefreqbias,
        transmission_time = transmission_time,
        satellite_position_x = satellite_position_x,
        satellite_velocity_x = satellite_velocity_x,
        satellite_acceleration_x = satellite_acceleration_x,
        satellite_health = satellite_health,
        satellite_position_y = satellite_position_y,
        satellite_velocity_y = satellite_velocity_y,
        satellite_acceleration_y = satellite_acceleration_y,
        codeaccuracy = codeaccuracy,
        satellite_position_z = satellite_position_z,
        satellite_velocity_z = satellite_velocity_z,
        satellite_acceleration_z = satellite_acceleration_z,
        iodn = iodn
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

    time = DateTime(year, month, day, hour, minute, second)

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
        time = time,
        satellite_id = satellite_id,
        clk_bias = clk_bias,
        clk_drift = clk_drift,
        clk_drift_rate = clk_drift_rate,
        iode = iode,
        crs = crs,
        delta_n = delta_n,
        m0 = m0,
        cuc = cuc,
        e = e,
        cus = cus,
        sqrt_a = sqrt_a,
        toe = toe,
        cic = cic,
        omega0 = omega0,
        cis = cis,
        i0 = i0,
        crc = crc,
        omega = omega,
        omega_dot = omega_dot,
        idot = idot,
        week = week,
        user_range_accuracy = userrangeaccuracy,
        health = satellite_health,
        tgd = tgd,
        transmission_time = transmission_time
    )
end