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

@testset "Surrogates" begin
    x = randn(100000)
    MI = @test_nowarn comodulogram(x; fs=300)
    MI_sur = ModulationIndices.surrogatecomodulogram(x; fs=300)
    p = ModulationIndices.pvalue(MI, MI_sur)
end


@testset "TestSignal" begin
    dt = 0.001
    _x = 0:dt:10
    fs = 1/dt
    x = 10.0.*sin.(_x.*5.0.*(2π)) .+ (1 .+ sin.((_x.+π).*5.0.*(2π))) .* sin.((50*2π).*_x).+randn(length(_x)).*0.001
    # plotcomodulogram(x; fs)
    MI = @test_nowarn comodulogram(x; fs)
    MI_sur = @test_nowarn ModulationIndices.surrogatecomodulogram(x; fs)
    p = @test_nowarn ModulationIndices.pvalue(MI, MI_sur)
    # plotcomodulogram(MI, MI_sur)
end
