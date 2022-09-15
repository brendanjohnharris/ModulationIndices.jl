"""
The modulation index of Tort et al. 2010, "Measuring Phase-Amplitude Coupling Between Neuronal Oscillations of Different Frequencies"
"""
function tort2010(x::AbstractVector, fs::Number=1; fₚ, fₐ)
    p = bandpass(x, fs, pass=fₚ) |> hilbert .|> angle
    p = p .+ π
    a = bandpass(x, fs, pass=fₐ) |> hilbert .|> abs

    # * Now we bin the phases every 20 degrees, or π/9 radians
    n = 20
    w = 2π/n
    b = ceil.(Int, p ./ w) # Bin number for each value of p
    h = [mean(a[b .== i]) for i in 1:n] # Mean amplitude for each bin
    h ./= sum(h)
    u = fill(1/20, 20)
    return kldivergence(h, u, n)
end

function tort2010(fs::Number=1; fₚ, fₐ)
    Feature(x->tort2010(x, fs; fₚ, fₐ),
            Symbol("tort2010_$(fₚ[1])_$(fₚ[2])_$(fₐ[1])_$(fₐ[2])"),
            "The modulation index of Tort et al. 2010, 'Measuring Phase-Amplitude Coupling Between Neuronal Oscillations of Different Frequencies'",
            ["modulation_index"])
end

tort2010(fₚ::Tuple, fₐ::Tuple) = tort2010(1; fₚ, fₐ)
