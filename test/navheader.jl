@testset "nav header parsing" begin
    path = "../data/line22_fromhostivartopohorelec.24N"
    content = rinexread(path)
    header,data = rinexread(path)

    # test that they are equal
    @test content.header.str == header.str

    # Test ionocorrections
    # TODO

    # Test timecorrections
    # TODO

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