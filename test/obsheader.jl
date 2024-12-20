@testset "nav body parsing" begin
    path = "..\\data\\line22_fromhostivartopohorelec.24O"
    content = rinexread(path)
    header,data = rinexread(path)

    # Test sys/phaseshift 
    @test header.sys_phase_shift[('G',"L2S",15)] ≈ -0.25
    @test header.sys_phase_shift[('G',"L2S",16)] ≈ -0.25



end