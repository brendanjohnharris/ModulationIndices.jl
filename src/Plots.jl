using ..Makie
using DimensionalData

export plotcomodulogram

function plotcomodulogram(MI::DimArray{<:Number, 2})
    f = Figure();
    ax = Axis(f[1, 1]; xlabel="Phase Frequency (Hz)", ylabel="Amplitude Frequency (Hz)");
    x = dims(MI, 1) |> collect
    y = dims(MI, 2) |> collect
    plt = heatmap!(ax, x, y, collect(MI));
    Colorbar(f[1, 2], plt, label="PAC");
    return f
end

function plotcomodulogram(MI, ps; p=0.001)
    f = Figure();
    ax = Axis(f[1, 1]; xlabel="Phase Frequency (Hz)", ylabel="Amplitude Frequency (Hz)");
    x = dims(MI, 1) |> collect
    y = dims(MI, 2) |> collect
    plt = heatmap!(ax, x, y, collect(MI));
    Colorbar(f[1, 2], plt, label="PAC");
    p′ = log10.(ps)
    x = dims(p′, 1) |> collect
    y = dims(p′, 2) |> collect
    contour!(ax, x, y, collect(p′), levels=[log10(p)], color=:white, linewidth=5)
    return f
end

function plotcomodulogram(MI, MI_sur::DimArray{<:Number, 3}; p=0.001)
    ps = ModulationIndices.pvalue(MI, MI_sur)
    plotcomodulogram(MI, ps; p)
end

function plotcomodulogram(x; dosurr=false, kwargs...)
    MI = comodulogram(x; kwargs...)
    if dosurr
        MI_sur = surrogatecomodulogram(x; kwargs...)
        plotcomodulogram(MI, MI_sur; kwargs...)
    else
        plotcomodulogram(MI)
    end
end
