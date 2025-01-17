@testset "nav body parsing" begin
    path = "../data/navtest1.24N"
    content = rinexread(path)
    header,data = rinexread(path)
    
    # Test iterator
    @test content.data.GPS == data.GPS


    # Test that the data is not empty
    @test isempty(data.GPS) == false
    @test isempty(data.GALILEO) == false
    @test isempty(data.BEIDOU) == false
    @test isempty(data.GLONASS) == false
    @test isempty(data.SBAS) == false

    # Test that the data is correct (random samples)
    @test data.GPS.Time[1] == TimeDate(2024,7,10,7,59,44,0,0,0)
    @test data.BEIDOU.Time[1] == TimeDate(2024,7,10,7,0,0,0,0,0)
    @test data.GALILEO.Time[1] == TimeDate(2024,7,10,7,20,0,0,0,0)
    @test data.GLONASS.Time[1] == TimeDate(2024,7,10,7,45,0,0,0,0)

    @test data.GPS.SatelliteID[1] == 1
    @test data.BEIDOU.SatelliteID[1] == 27
    @test data.GALILEO.SatelliteID[1] == 34
    @test data.GALILEO.SatelliteID[2] == 15
    @test data.GLONASS.SatelliteID[2] == 3

    @test data.GLONASS.SVFrequencyBias[1] ≈ 0.181898940355e-11
    @test data.GLONASS.AgeOperationInfo[1] ≈ 0.0

    @test data.BEIDOU.SVClockBias[1] ≈ 0.338684534654e-03
    @test data.BEIDOU.sqrtA[1] ≈ 0.528262133789e+04

    @test data.GPS.M0[1] ≈ 0.230261819644e+01
    @test data.GPS.OMEGA_DOT[1] ≈ -0.807890794752e-08

    @test data.GALILEO.Eccentricity[1] ≈ 0.353266019374e-03
    @test data.GALILEO.SISAccuracy[2] ≈ 0.312000000000e+01
    @test data.GALILEO.BGDE5aE1[2] ≈ 0.349245965481e-08

end


