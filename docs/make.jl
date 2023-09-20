using MatrixCorrectionTools
using Documenter

DocMeta.setdocmeta!(MatrixCorrectionTools, :DocTestSetup, :(using MatrixCorrectionTools); recursive=true)

makedocs(;
    modules=[MatrixCorrectionTools],
    authors="Bagaev Dmitry <d.v.bagaev@tue.nl>",
    repo="https://github.com/biaslab/MatrixCorrectionTools.jl/blob/{commit}{path}#{line}",
    sitename="MatrixCorrectionTools.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://biaslab.github.io/MatrixCorrectionTools.jl",
        edit_link="main",
        assets=String[]
    ),
    pages=[
        "Home" => "index.md",
    ]
)

deploydocs(;
    repo="github.com/biaslab/MatrixCorrectionTools.jl",
    devbranch="main"
)
