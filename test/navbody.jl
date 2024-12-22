@testset "nav body parsing" begin
    path = "../data/line22_fromhostivartopohorelec.24N"
    content = rinexread(path)
    header,data = rinexread(path)
    
    # Test iterator
    @test content.data.GPS == data.GPS


    @test isempty(data.GPS) == false


end


