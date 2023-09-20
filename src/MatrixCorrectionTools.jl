module MatrixCorrectionTools

using LinearAlgebra

"""
    correction!(strategy, input)

Modifies the `input` in-place using a specified correction strategy.
The `input` can be either a matrix or a number. 
Certain strategies may require the input to satisfy specific properties beforehand, e.g., the input must be a square matrix.
"""
function correction! end

"""
    correction(strategy, input)

Similar to `correction!`, but it first performs a `deepcopy` of the `input`.
"""
correction(strategy, input) = correction!(strategy, deepcopy(input))

"""
    NoCorrection

A correction strategy option for the `correction!` function. It does not modify the input and simply returns the original.
"""
struct NoCorrection end

correction!(::NoCorrection, input) = input


"""
    ReplaceZeroDiagonalEntries(value)

A correction strategy option for the `correction!` function. It replaces zero diagonal entries with the predefined `value`.
The `LinearAlgebra.diagint` function is employed to iterate over the diagonal entries.
The `iszero` function is utilized to determine whether a diagonal entry is zero or not.
This strategy converts the type of `value` to the exact element type of the container.
"""
struct ReplaceZeroDiagonalEntries{T} 
    value :: T
end

correction!(strategy::ReplaceZeroDiagonalEntries, number::Number) = iszero(number) ? convert(typeof(number), strategy.value) : number

function correction!(strategy::ReplaceZeroDiagonalEntries, container)
    @inbounds for ind in LinearAlgebra.diagind(container)
        value = container[ind]
        if iszero(value)
            container[ind] = convert(eltype(container), strategy.value)
        end
    end
    return container
end

"""
    AddToDiagonalEntries(value)

A correction strategy option for the `correction!` function. It adds the predefined `value` to the diagonal entries.
The `LinearAlgebra.diagint` function is employed to iterate over the diagonal entries.
This strategy converts the type of `value` to the exact element type of the container.
"""
struct AddToDiagonalEntries{T} 
    value :: T
end

correction!(strategy::AddToDiagonalEntries, number::Number) = number + convert(typeof(number), strategy.value)

function correction!(strategy::AddToDiagonalEntries, container)
    @inbounds for ind in LinearAlgebra.diagind(container)
        container[ind] += convert(eltype(container), strategy.value)
    end
    return container
end

"""
    ClampDiagonalEntries(lo, hi)

A correction strategy option for the `correction!` function. It clamps the diagonal entries between `lo` and `ho`.
The `LinearAlgebra.diagint` function is employed to iterate over the diagonal entries.
"""
struct ClampDiagonalEntries{L, H} 
    lo::L
    hi::H
end

correction!(strategy::ClampDiagonalEntries, number::Number) = clamp(number, strategy.lo, strategy.hi)

function correction!(strategy::ClampDiagonalEntries, container)
    @inbounds for ind in LinearAlgebra.diagind(container)
        container[ind] = clamp(container[ind], strategy.lo, strategy.hi)
    end
    return container
end

"""
    ClampSingularValues(lo, hi)

A correction strategy option for the `correction!` function. It clamps the singular values of the matrix between `lo` and `hi`.
The `LinearAlgebra.diagint` function is employed to iterate over the diagonal entries.
The `LinearAlgebra.svd` function is employed to make the SVD decomposition.

"""
struct ClampSingularValues{L, H}
    lo::L
    hi::H
end

correction!(strategy::ClampSingularValues, value::Number) = clamp(value, strategy.lo, strategy.hi)

function correction!(strategy::ClampSingularValues, input)

    F = svd(input)
    clamp!(F.S, strategy.lo, strategy.hi)
    R = lmul!(Diagonal(F.S), F.Vt)
    M = mul!(input, F.U, R)

    return M
end

end
