@testset "nav header parsing" begin
    path = "../data/navtest1.24N"
    content = rinexread(path)
    header,data = rinexread(path)

    # test that they are equal
    @test content.header.str == header.str

    # Test ionocorrections
    @test header.ionocorrections.GPS.a0 ≈ 0.1490 / 1e7
    @test header.ionocorrections.GPS.a1 ≈ 0.2235 / 1e7
    @test header.ionocorrections.GPS.a2 ≈ -0.5960 / 1e7
    @test header.ionocorrections.GPS.a3 ≈ -0.1192 / 1e6
    @test header.ionocorrections.GPS.b0 ≈ 0.1167 * 1e6
    @test header.ionocorrections.GALILEO.a0 ≈ 0.1638 * 1e3
    @test header.ionocorrections.GALILEO.a1 ≈ 0.3359
    @test header.ionocorrections.GALILEO.a2 ≈ 0.01791
    @test header.ionocorrections.BEIDOU.a2 ≈ -0.1192 / 1e5
    @test isnan(header.ionocorrections.QZSS.b0)


    # Test timecorrections
    @test header.timecorrections["GPUT"].a0 ≈ 0.9313225746 / 1e9
    @test header.timecorrections["GPUT"].a1 ≈ 0.177635684 / 1e14
    @test header.timecorrections["GPUT"].reftime == 405504
    @test header.timecorrections["GPUT"].refweek == 2322
    @test header.timecorrections["GPUT"].source == "EGNOS"
    @test header.timecorrections["GPUT"].utcidentifier == 42
    @test header.timecorrections["GAUT"].utcidentifier == 0
    @test header.timecorrections["GAUT"].reftime == 259200
    @test haskey(header.timecorrections, "GAUT")
    @test !haskey(header.timecorrections, "GLGP")
    @test !haskey(header.timecorrections, "GALP")
    @test haskey(header.timecorrections, "BDUT")
    @test haskey(header.timecorrections, "GLUT")


    # Test leapseconds
    content.header.leapseconds == header.leapseconds
    @test header.leapseconds.current == 18
    @test header.leapseconds.future == 18
    @test header.leapseconds.week_number == 2203
    @test header.leapseconds.day_of_week == 7
    @test header.leapseconds.time_system_id == 'G'
    path2 = "../data/navtest2.24N"
    content2 = rinexread(path2)
    @test content2.header.leapseconds.time_system_id == 'C'

end