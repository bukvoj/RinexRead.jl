@testset "obs body parsing" begin
    path = "../data/obstest1.24O"
    content = rinexread(path)
    header,data = rinexread(path)

    # Test iterator
    @test isequal(content.data.GPS[1:5,:], data.GPS[1:5,:])
    @test isempty(content.header.systems) == false


    # Test that columns have correct names
    colnames = ["C1C", "L1C", "D1C", "C2X", "L2X", "D2X"]
    cols = [[name, name*"_LLI", name*"_SSI"][i] for i in 1:3 for name in colnames]
    cols = sort(vcat(["Time", "SatelliteID", "EpochFlag"], cols))
    @test names(data.GPS) == cols    
    
    colnames = split("C1C L1C D1C C2C L2C D2C")
    cols = [[name, name*"_LLI", name*"_SSI"][i] for i in 1:3 for name in colnames]
    cols = sort(vcat(["Time", "SatelliteID", "EpochFlag"], cols))
    @test names(data.GLONASS) == cols

    colnames = split("C1X L1X D1X C7X L7X D7X")
    cols = [[name, name*"_LLI", name*"_SSI"][i] for i in 1:3 for name in colnames]
    cols = sort(vcat(["Time", "SatelliteID", "EpochFlag"], cols))
    @test names(data.GALILEO) == cols

    colnames = split("C1I L1I D1I C7I L7I D7I")
    cols = [[name, name*"_LLI", name*"_SSI"][i] for i in 1:3 for name in colnames]
    cols = sort(vcat(["Time", "SatelliteID", "EpochFlag"], cols))
    @test names(data.BEIDOU) == cols



end