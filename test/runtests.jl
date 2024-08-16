using ModulationIndices
using ModulationIndices.TimeseriesFeatures
using Test

@testset "Tort" begin
    x = randn(5000)
    fs = 500
    o = @test_nowarn tort2010(x; fs, fₚ=5, fₐ=50, dp=1, da=20)
    f = @test_nowarn tort2010(fs, fₚ=5, fₐ=50, dp=1, da=20)
    @test f isa TimeseriesFeatures.Feature
    @test f(x) == o
end

@testset "Bounded by 1?" begin
    ϕs = -pi:0.001:pi
    ϕs = repeat(ϕs, 100)
    rs = zeros(size(ϕs))
    rs[0 .< ϕs .< 1 / 2pi] .= 1.0
    @test tort2010(ϕs, rs; n=20) == 1

    rs[-1/2pi.<ϕs.<1/2pi] .= 1.0
    @test 0.7 < tort2010(ϕs, rs; n=20) < 1

    rs .= abs.(randn(size(rs)))
    @test tort2010(ϕs, rs; n=20) ≈ 0 atol = 1e-5
end

@testset "Comodulogram_Tort" begin
    x = randn(5000)
    fs = 500
    o = @test_nowarn comodulogram(x; fs)
    # f = @test_nowarn comodulogram(fs)
    # fo = f(x)
    # @test f isa TimeseriesFeatures.Feature
    # @test fo == o
    # g = @test_nowarn modulation_indices(fs, :tort)
    # @time g[1:10](x)
    # @time g[2](x)
end

@testset "Surrogates" begin
    x = randn(10000)
    MI = @test_nowarn comodulogram(x; fs=300)
    MI_sur = ModulationIndices.surrogatecomodulogram(x; fs=300, n_sur=10)
    p = ModulationIndices.pvalue(MI, MI_sur)
end


@testset "TestSignal" begin
    dt = 0.001
    _x = 0:dt:5
    fs = 1 / dt
    x = 10.0 .* sin.(_x .* 5.0 .* (2π)) .+ (1 .+ sin.((_x .+ π) .* 5.0 .* (2π))) .* sin.((50 * 2π) .* _x) .+ randn(length(_x)) .* 0.001
    # plotcomodulogram(x; fs)
    MI = @test_nowarn comodulogram(x; fs)
    MI_sur = @test_nowarn ModulationIndices.surrogatecomodulogram(x; fs, n_sur=10)
    p = @test_nowarn ModulationIndices.pvalue(MI, MI_sur)
    # plotcomodulogram(MI, MI_sur)
end


@testset "Float32" begin
    dt = 0.001
    _x = 0:dt:5
    fs = 1 / dt
    x = 10.0 .* sin.(_x .* 5.0 .* (2π)) .+ (1 .+ sin.((_x .+ π) .* 5.0 .* (2π))) .* sin.((50 * 2π) .* _x) .+ randn(length(_x)) .* 0.001
    x = x .|> Float32
    MI = @test_nowarn comodulogram(x; fs)
    MI_sur = @test_nowarn ModulationIndices.surrogatecomodulogram(x; fs, n_sur=10)
    p = @test_nowarn ModulationIndices.pvalue(MI, MI_sur)
end
