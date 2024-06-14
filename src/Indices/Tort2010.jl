export tort2010

function tortbin(p; n=20)
    p = p .+ π # Assume we are wrapped -π to π
    if minimum(p) < 0 || maximum(p) ≥ 2π
        error("Phase values must be in the range 0 to 2π (not $(extrema(p))")
    end
    w = 2π / n
    return ceil.(Int, p ./ w)
end

function tortprob(b, a; n=20)
    is = [a[b.==i] for i in 1:n]
    h = [mean(is[i]) for i in 1:n] # Mean amplitude for each bin
    h[isnan.(h)] .= mean(h[.!isnan.(h)])
    h ./= sum(h)
    return h
end

function _tort2010(b, a; n=20)
    h = tortprob(b, a; n)
    u = fill(1 / n, n)
    return kldivergence(h, u, n)
end

function tort2010(p, a; n=20, kwargs...) # Bin number for each value of p
    _tort2010(tortbin(p; n, kwargs...), a; n)
end

"""
The modulation index of Tort et al. 2010, "Measuring Phase-Amplitude Coupling Between Neuronal Oscillations of Different Frequencies"
"""
function tort2010(x::AbstractVector; fs::Number=1, fₚ, fₐ, dp, da)
    p = bandpass(x, fs, pass=[fₚ - dp, fₚ + dp]) |> hilbert .|> angle
    p = p .+ π
    a = bandpass(x, fs, pass=[fₐ - da, fₐ + da]) |> hilbert .|> abs
    return tort2010(p, a; n=20)
end

function tort2010(fs::Number=1; fₚ, fₐ, dp, da)
    Feature(x -> tort2010(x; fs, fₚ, fₐ, dp, da),
        Symbol("tort2010_$(fₚ)±$(dp)_$(fₐ)±$(da)"),
        "The modulation index of Tort et al. 2010, 'Measuring Phase-Amplitude Coupling Between Neuronal Oscillations of Different Frequencies'",
        ["modulation_index"])
end

tort2010(fₚ::Tuple, fₐ::Tuple) = tort2010(; fs=1, fₚ, fₐ)
