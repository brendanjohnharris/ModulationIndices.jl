export comodulogram, modulation_indices

comodulogram(x::AbstractVector, method::Symbol=:tort; kwargs...) = comodulogram(x, Val(method); kwargs...)

function comodulogram(x::AbstractVector, ::Val{:tort}; fs::Number=freqor(x, 1), fₚ=2:0.25:10, fₐ=25:1:100, dp=1, da=20)
    x = collect(x)
    fps = [[fₚ[i]-dp/2, fₚ[i]+dp/2] for i in 1:length(fₚ)]
    fas = [[fₐ[i]-da/2, fₐ[i]+da/2] for i in 1:length(fₐ)]
    pcentres = [mean(f) for f in fps]
    acentres = [mean(f) for f in fas]

    bp = [bandpass(x, fs, pass=f) |> hilbert for f in fps]
    p = [b .|> angle for b in bp]
    p = [_p .+ π for _p in p]
    bs = [tortbin(_p) for _p in p]

    ba = [bandpass(x, fs, pass=f) |> hilbert for f in fas]
    a = [b .|> abs for b in ba]

    MI = [_tort2010(b, _a) for b in bs, _a in a]
    return DimArray(MI, (Dim{:fₚ}(pcentres), Dim{:fₐ}(acentres)))
end





comodulogram(fs::Number, method=:tort; fₚ=2:0.25:10, fₐ=25:1:100,
dp=1, da=20) = Feature(
                            x->comodulogram(x, method; fs, fₚ, fₐ, dp, da),
                                Symbol("comodulogram_$method"),
                                "Comodulogram using the $method method, fₚ=$fₚ, fₐ=$fₐ, dp=$dp, da=$da", ["modulation_index"])

modulation_indices(fs, method=:tort; fₚ=2:2:10, fₐ=30:10:100,
dp=1, da=20) = SuperFeatureSet(
                [x->x[i, j] for i ∈ eachindex(fₚ), j ∈ eachindex(fₐ)][:],
                Symbol.(["modulation_index_$(method)_fₚ=$(fₚ[i])±$(dp)_fₐ=$(fₐ[j])±$da" for i ∈ eachindex(fₚ), j ∈ eachindex(fₐ)])[:],
                ["Modulation index" for i ∈ eachindex(fₚ), j ∈ eachindex(fₐ)][:],
                [["modulation_index"] for i ∈ eachindex(fₚ), j ∈ eachindex(fₐ)][:],
                comodulogram(fs, method; fₚ, fₐ,
                dp, da))
