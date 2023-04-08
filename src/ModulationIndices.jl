module ModulationIndices

using Catch22
using DSP
using Statistics
using StatsBase
using DimensionalData
using Requires

export analytic_signal

function stepor(x, a)
    if x isa AbstractDimArray && dims(x, 1).val.data isa AbstractRange
        return step(dims(x, 1))
    else
        return a
    end
end
freqor(x, a) = 1/stepor(x, a)

analytic_signal = Feature(hilbert, :analytic_signal, "Analytic signal computed via the Hilbert transform", ["amplitude,phase"])

bandpass(x::Vector, fs=freqor(x, 1); pass) = filtfilt(digitalfilter(Bandpass(pass...; fs), Butterworth(4)), x)

include("Indices/Tort2010.jl")
include("Comodulogram.jl")
include("Surrogates.jl")

function __init__()
    @require Makie="ee78f7c6-11fb-53f2-987a-cfe4a2b5a57a" @eval include("./Plots.jl")
end


end
