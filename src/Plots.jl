using ..Makie
using DimensionalData

export plotcomodulogram

function plotcomodulogram(args..., kwargs...)
    f = Figure();
    ax = Axis(f[1, 1]; xlabel="Phase Frequency (Hz)", ylabel="Amplitude Frequency (Hz)");
    plotcomodulogram!(ax, args...; kwargs...)
    return f
end

function plotcomodulogram!(ax, MI::DimArray{<:Number, 2}; kwargs...)
    x = dims(MI, 1) |> collect
    y = dims(MI, 2) |> collect
    plt = heatmap!(ax, x, y, collect(MI); kwargs...);
    Colorbar(f[1, 2], plt, label="PAC");
end

function plotcomodulogram!(ax, MI, ps; p=0.001, kwargs...)
    x = dims(MI, 1) |> collect
    y = dims(MI, 2) |> collect
    plt = heatmap!(ax, x, y, collect(MI); kwargs...);
    Colorbar(f[1, 2], plt, label="PAC");
    p′ = log10.(ps)
    x = dims(p′, 1) |> collect
    y = dims(p′, 2) |> collect
    contour!(ax, x, y, collect(p′), levels=[log10(p)], color=:white, linewidth=5)
end

function plotcomodulogram!(ax, MI, MI_sur::DimArray{<:Number, 3}; p=0.001, kwargs...)
    ps = ModulationIndices.pvalue(MI, MI_sur)
    plotcomodulogram!(ax, MI, ps; p, kwargs...)
end

function plotcomodulogram!(ax, x; dosurr=false, kwargs...)
    MI = comodulogram(x; kwargs...)
    if dosurr
        MI_sur = surrogatecomodulogram(x; kwargs...)
        plotcomodulogram!(ax, MI, MI_sur)
    else
        plotcomodulogram!(ax, MI)
    end
end
