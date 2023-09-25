module MatrixCorrectionToolsTests

using Test, MatrixCorrectionTools, LinearAlgebra

import MatrixCorrectionTools: correction!, correction, AbstractCorrectionStrategy

struct CustomStrategyAddsOne end
struct CustomStrategyAddsOneWithAbstractType <: AbstractCorrectionStrategy end

MatrixCorrectionTools.correction!(::CustomStrategyAddsOne, input) = map!(Base.Fix2(+, 1), input, input)
MatrixCorrectionTools.correction!(::CustomStrategyAddsOneWithAbstractType, input) = map!(Base.Fix2(+, 1), input, input)

@testset "MatrixCorrectionTools.jl" begin

    for strategy in (CustomStrategyAddsOne(), CustomStrategyAddsOneWithAbstractType(),)
        A = rand(2, 2)

        # Test the actual behaviour
        @test correction!(strategy, deepcopy(A)) == (A .+ 1)

        # Test inplace version
        copyA = deepcopy(A)
        @test correction!(strategy, copyA) === copyA

        # Test that non-inplace version allocates a new array
        copyA = deepcopy(A)
        @test correction(strategy, copyA) !== copyA

    end

    @testset "`NoCorrection` strategy" begin
        import MatrixCorrectionTools: NoCorrection

        @test correction!(NoCorrection(), 0) === 0

        for n in (3, 4, 5)
            local A = rand(n, n)
            @test correction!(NoCorrection(), A) == deepcopy(A)
        end

    end

    @testset "`ReplaceZeroDiagonalEntries` strategy" begin
        import MatrixCorrectionTools: ReplaceZeroDiagonalEntries

        @test correction!(ReplaceZeroDiagonalEntries(1), 0) === 1
        @test correction!(ReplaceZeroDiagonalEntries(1), 0.0) === 1.0
        @test correction!(ReplaceZeroDiagonalEntries(1), 2.0) === 2.0

        A = [0 0; 0 0]
        correction!(ReplaceZeroDiagonalEntries(1), A)
        @test A == [1 0; 0 1]

        @test correction!(ReplaceZeroDiagonalEntries(1), [0 0; 0 2]) == [1 0; 0 2]
        @test correction!(ReplaceZeroDiagonalEntries(1.0), [0 0; 0 2]) == [1 0; 0 2]
        @test correction!(ReplaceZeroDiagonalEntries(1), [0.0 0.0; 0.0 2.0]) == [1.0 0.0; 0.0 2.0]

    end

    @testset "`AddToDiagonalEntries` strategy" begin
        import MatrixCorrectionTools: AddToDiagonalEntries

        @test correction!(AddToDiagonalEntries(1), 0) === 1
        @test correction!(AddToDiagonalEntries(1), 0.0) === 1.0
        @test correction!(AddToDiagonalEntries(1), 2.0) === 3.0

        A = [0 0; 0 0]
        correction!(AddToDiagonalEntries(1), A)
        @test A == [1 0; 0 1]

        @test correction!(AddToDiagonalEntries(1), [0 0; 0 2]) == [1 0; 0 3]
        @test correction!(AddToDiagonalEntries(1.0), [0 0; 0 2]) == [1 0; 0 3]
        @test correction!(AddToDiagonalEntries(1), [0.0 0.0; 0.0 2.0]) == [1.0 0.0; 0.0 3.0]

    end

    @testset "`ClampDiagonalEntries` strategy" begin
        import MatrixCorrectionTools: ClampDiagonalEntries

        @test correction!(ClampDiagonalEntries(0.1, 1.0), 0) === 0.1
        @test correction!(ClampDiagonalEntries(-1, 1), 0.0) === 0.0
        @test correction!(ClampDiagonalEntries(0.0, 3.0), 100.0) === 3.0

        A = [0.0 0.0; 0.0 0.0]
        correction!(ClampDiagonalEntries(0.01, 100.0), A)
        @test A == [0.01 0.0; 0.0 0.01]

        @test correction!(ClampDiagonalEntries(0.1, 100.0), [0.0 0.0; 0.0 200.0]) == [0.1 0.0; 0.0 100.0]
        @test correction!(ClampDiagonalEntries(-100, 100), [0.0 0.0; 0.0 10.0]) == [0.0 0.0; 0.0 10.0]

    end

    @testset "`ClampSingularValues` strategy" begin
        import MatrixCorrectionTools: ClampSingularValues

        @test correction!(ClampSingularValues(0.1, 1.0), 0) === 0.1
        @test correction!(ClampSingularValues(-1, 1), 0.0) === 0.0
        @test correction!(ClampSingularValues(0.0, 3.0), 100.0) === 3.0


        for lo in (0.01, 0.0001, 1.0), hi in (10.0, 100.0), A in ([0.0 0.0; 0.0 0.0], [0.0 0.0; 0.0 10000.0])
            correction!(ClampSingularValues(lo, hi), A)
            @test all(v -> lo <= v <= hi, eigvals(A))
        end

    end


end

end
