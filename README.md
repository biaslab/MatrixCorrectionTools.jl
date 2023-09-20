# MatrixCorrectionTools

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://biaslab.github.io/MatrixCorrectionTools.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://biaslab.github.io/MatrixCorrectionTools.jl/dev/)
[![Build Status](https://github.com/biaslab/MatrixCorrectionTools.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/biaslab/MatrixCorrectionTools.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/biaslab/MatrixCorrectionTools.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/biaslab/MatrixCorrectionTools.jl)
[![PkgEval](https://JuliaCI.github.io/NanosoldierReports/pkgeval_badges/M/MatrixCorrectionTools.svg)](https://JuliaCI.github.io/NanosoldierReports/pkgeval_badges/M/MatrixCorrectionTools.html)

`MatrixCorrectionTools` is a lightweight package that offers a straightforward function called `correction!`. 
This function is designed to correct specific properties of a matrix using predefined strategies.

For instance, if a matrix contains zero diagonal entries, this package provides the means to replace (correct) 
them using either fixed predefined values or a more advanced algorithm based on SVD decomposition.

To learn more about the available correction strategies and see practical examples, please refer to the [documentation](https://biaslab.github.io/MatrixCorrectionTools.jl/stable/).