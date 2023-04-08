using ModulationIndices
using ModulationIndices.Catch22
using Test

@testset "Tort" begin
    x = randn(5000)
    fs = 500
    o = @test_nowarn tort2010(x; fs, fₚ=5, fₐ=50, dp=1, da=20)
    f = @test_nowarn tort2010(fs, fₚ=5, fₐ=50, dp=1, da=20)
    @test f isa Catch22.Feature
    @test f(x) == o
end

@testset "Comodulogram_Tort" begin
    x = randn(5000)
    fs = 500
    o = @test_nowarn comodulogram(x; fs)
    f = @test_nowarn comodulogram(fs)
    fo = f(x)
    @test f isa Catch22.Feature
    @test fo == o
    g = @test_nowarn modulation_indices(fs, :tort)
    # @time g[1:10](x)
    # @time g[2](x)
end
