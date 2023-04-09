using TimeseriesSurrogates
using HypothesisTests
using MultipleTesting
using ProgressLogging

export surrogatecomodulogram
import HypothesisTests.pvalue

function surrogatecomodulogram(x, args...; fs=freqor(x, 1), n_sur=1000, fₚ=2:0.5:10, fₐ=25:5:100, surromethod=IAAFT(), kwargs...)
    x = collect(x)
    MI_sur = zeros(length(fₚ), length(fₐ), n_sur)
    # @withprogress name="Surrogate PAC" begin
        # threadlog, threadmax = (0, n_sur)
        for i in 1:n_sur # ? Threads.@threads
            @fastmath y = surrogate(x, surromethod)
            @fastmath MI_sur[:, :, i] .= comodulogram(y, args...; fs, fₚ, fₐ, kwargs...)
            # if threadmax > 1
            #     Threads.threadid() == 1 && (threadlog += Threads.nthreads())%10 == 0 && @logprogress threadlog/threadmax
            # end
        end
    # end
    return DimArray(MI_sur, (Dim{:fₚ}(fₚ), Dim{:fₐ}(fₐ), Dim{:surrogate}(1:n_sur)))
end

function pvalue(MI::DimArray{<:Number, 2}, MI_sur::DimArray{<:Number, 3})
    ps = deepcopy(MI[At(collect(dims(MI_sur, 1))), At(collect(dims(MI_sur, 2)))])
    ps .= 1.0
    vals = Iterators.product(dims(ps)...) |> collect
    for i in CartesianIndices(ps)
        v = vals[i]
        ps[i] = SignedRankTest(collect(MI_sur[At(v[1]), At(v[2]), :]) .- MI[At(v[1]), At(v[2])]) |> x->HypothesisTests.pvalue(x; tail=:left)
    end
    ps[:] .= adjust(ps[:], BenjaminiHochberg())
    return ps
end

function significancethreshold(ps::DimArray{<:Number, 2}; p=0.001)
    # Build contour
    thsh = deepcopy(ps)
    thsh = thsh .< p
end

significancethreshold(MI, MI_sur::DimArray{<:Number, 3}) = significancethreshold(MI, pvalue(MI, MI_sur))
