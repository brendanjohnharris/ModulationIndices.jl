using ModulationIndices
using Documenter

DocMeta.setdocmeta!(ModulationIndices, :DocTestSetup, :(using ModulationIndices); recursive=true)

makedocs(;
    modules=[ModulationIndices],
    authors="brendanjohnharris <brendanjohnharris@gmail.com> and contributors",
    repo="https://github.com/brendanjohnharris/ModulationIndices.jl/blob/{commit}{path}#{line}",
    sitename="ModulationIndices.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)
