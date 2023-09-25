```@meta
CurrentModule = MatrixCorrectionTools
```

# MatrixCorrectionTools

`MatrixCorrectionTools` is a lightweight package that offers a straightforward function called `correction!`. 
This function is designed to correct specific properties of a matrix using predefined strategies.

For instance, if a matrix contains zero diagonal entries, this package provides the means to replace (correct) 
them using either fixed predefined values or a more advanced algorithm based on SVD decomposition.

## General functionality 

```@docs 
MatrixCorrectionTools.correction!
MatrixCorrectionTools.correction
MatrixCorrectionTools.AbstractCorrectionStrategy
```

## Available strategies

A strategy must implement a single function: [`MatrixCorrectionTools.correction!`](@ref).
Note that all defined strategies in the package are subtypes of the [`MatrixCorrectionTools.AbstractCorrectionStrategy`], but it is not 
necessary to subtype from it for the `correction!` function to work.

```@docs
MatrixCorrectionTools.NoCorrection
MatrixCorrectionTools.ReplaceZeroDiagonalEntries
MatrixCorrectionTools.AddToDiagonalEntries
MatrixCorrectionTools.ClampDiagonalEntries
MatrixCorrectionTools.ClampSingularValues
```

