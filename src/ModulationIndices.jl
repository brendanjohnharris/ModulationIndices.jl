module ModulationIndices

using Catch22
using DSP
using Statistics
using StatsBase
using DimensionalData
using Requires

export analytic_signal

analytic_signal = Feature(hilbert, :analytic_signal, "Analytic signal computed via the Hilbert transform", ["amplitude,phase"])

bandpass(x::Vector, fs=1; pass) = filtfilt(digitalfilter(Bandpass(pass...; fs), Butterworth(4)), x)

include("Indices/Tort2010.jl")
include("Comodulogram.jl")
include("Surrogates.jl")

function __init__()
    @require Makie="ee78f7c6-11fb-53f2-987a-cfe4a2b5a57a" @eval include("./Plots.jl")
end


end
