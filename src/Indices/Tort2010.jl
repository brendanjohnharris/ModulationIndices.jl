export tort2010

function tortbin(p; n=20)
    @assert minimum(p) >= 0
    @assert maximum(p) <= 2π
    w = 2π/n
    return ceil.(Int, p ./ w)
end

function _tort2010(b, a; n=20)
    h = [mean(a[b .== i]) for i in 1:n] # Mean amplitude for each bin
    h ./= sum(h)
    u = fill(1/n, n)
    return kldivergence(h, u, n)
end

function tort2010(p, a; kwargs...) # Bin number for each value of p
    _tort2010(tortbin(p; kwargs...), a)
    # return 1 + sum(h.*log.(h))/log(n)
end

"""
The modulation index of Tort et al. 2010, "Measuring Phase-Amplitude Coupling Between Neuronal Oscillations of Different Frequencies"
"""
function tort2010(x::AbstractVector; fs::Number=1, fₚ, fₐ, dp, da)
    p = bandpass(x, fs, pass=[fₚ-dp, fₚ+dp]) |> hilbert .|> angle
    p = p .+ π
    a = bandpass(x, fs, pass=[fₐ-da, fₐ+da]) |> hilbert .|> abs
    return tort2010(p, a; n=20)
end

function tort2010(fs::Number=1; fₚ, fₐ, dp, da)
    Feature(x->tort2010(x; fs, fₚ, fₐ, dp, da),
            Symbol("tort2010_$(fₚ)±$(dp)_$(fₐ)±$(da)"),
            "The modulation index of Tort et al. 2010, 'Measuring Phase-Amplitude Coupling Between Neuronal Oscillations of Different Frequencies'",
            ["modulation_index"])
end

tort2010(fₚ::Tuple, fₐ::Tuple) = tort2010(; fs=1, fₚ, fₐ)
