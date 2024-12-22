@testset "obs body parsing" begin
    path = "../data/line22_fromhostivartopohorelec.24O"
    content = rinexread(path)
    header,data = rinexread(path)

    # Test iterator
    @test isequal(content.data.GPS[1:5,:], data.GPS[1:5,:])



    @test isempty(content.header.systems) == false
end