struct FastSolution
    hasSolution::Bool
    blockVision::Bool
    hasManySolution::Bool
    x::Float64
    y::Float64
    FastSolution(a,b,c) = new(a,b,c,0.0,0.0)
    FastSolution(a,b,c,x,y) = new(a,b,c,x,y)
end
