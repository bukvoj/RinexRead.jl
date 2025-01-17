@testset "obs header parsing" begin
    path = "../data/obstest1.24O"
    content = rinexread(path)
    header,data = rinexread(path)

    # test that they are equal
    @test content.header.str == header.str

    # Test sys/phaseshift 
    @test header.sys_phase_shift[('G',"L2S",15)] ≈ -0.25
    @test header.sys_phase_shift[('G',"L2S",16)] ≈ -0.25

    # glonass slots
    @test header.glonass_cod_phs_bis.C1C ≈ 8765.321 && 
          header.glonass_cod_phs_bis.C1P ≈ 1234.678 && 
          header.glonass_cod_phs_bis.C2C ≈ 1234.678 && 
          header.glonass_cod_phs_bis.C2P ≈ 1234.678
    @test header.glonass_slot_frq[2] == -4 &&
            header.glonass_slot_frq[3] == 5 &&
            header.glonass_slot_frq[4] == 6 &&
            header.glonass_slot_frq[18] == -3 &&
            header.glonass_slot_frq[19] == 3 &&
            header.glonass_slot_frq[20] == 2

      # time test 
      @test header.time_of_first_obs - TimeDate(2024,7,10,7,31,17,2,426,900) < Nanosecond(10)
      @test header.optional["TIME OF LAST OBS"] - TimeDate(2024,7,10,8,14,38,4,0,500) < Nanosecond(10)
      @test header.date - TimeDate(2024,7,10,12,38) < Nanosecond(10)
end