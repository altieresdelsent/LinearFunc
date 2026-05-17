module LinearFunc
    include("LinearFunc2D.jl")
    include("FastSolution.jl")
    include("getEncounterPoint.jl")
    include("solve.jl")
    include("solveFast.jl")
    include("solveUltraFast.jl")

    export LinearFunc2D, FastSolution
    export solve, solveFast, solveUltraFast, getEncounterPoint
end
