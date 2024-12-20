@testset "nav body parsing" begin
    path = "..\\data\\line22_fromhostivartopohorelec.24N"
    content = rinexread(path)
    header,data = rinexread(path)
    
    # Test iterator
    @test content.data.GPS == data.GPS


    @test isempty(data.GPS) == false


end


@testset "obs body parsing" begin
    path = "..\\data\\line22_fromhostivartopohorelec.24O"
    content = rinexread(path)
    header,data = rinexread(path)

    # Test iterator
    @test isequal(content.data.GPS[1:5,:], data.GPS[1:5,:])



    @test isempty(content.header.systems) == false
end