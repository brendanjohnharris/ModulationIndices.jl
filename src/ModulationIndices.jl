module ModulationIndices

using Catch22
using DSP
using Statistics
using StatsBase
using DimensionalData

export analytic_signal

analytic_signal = Feature(hilbert, :analytic_signal, "Analytic signal computed via the Hilbert transform", ["amplitude,phase"])

bandpass(x::Vector, fs=1; pass) = filtfilt(digitalfilter(Bandpass(pass...; fs), Butterworth(4)), x)

include("Indices/Tort2010.jl")
include("Comodulogram.jl")


end
