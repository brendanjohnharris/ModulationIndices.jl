module ModulationIndices

using Catch22
using DSP
using Statistics
using StatsBase

export analytic_signal, tort2010

analytic_signal = Feature(hilbert, :analytic_signal, "Analytic signal computed via the Hilbert transform", ["amplitude,phase"])

bandpass(x::Vector, fs=1; pass) = filtfilt(digitalfilter(Bandpass(pass...; fs), Butterworth(4)), x)


include("Indices/Tort2008.jl")


end
