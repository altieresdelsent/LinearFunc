# test_julia1x.jl — Tests modernized master solveFast against a reference solver
include("src/LinearFunc.jl")
using .LinearFunc

# ---- Reference solver (ported from original solve.jl semantics) ----
function solveRef(f1::LinearFunc2D, f2::LinearFunc2D)
    x = 0.0; y = 0.0

    if !f1.isXFixed && !f1.isYFixed && !f2.isXFixed && !f2.isYFixed
        if f1.slope == f2.slope && f1.bias == f2.bias
            blocks = f1.xMax > f2.xMin && f1.xMin < f2.xMax
            return FastSolution(true, blocks, true, f1.x1, f1.y1)
        elseif f1.slope == f2.slope
            return FastSolution(false, false, false, 0.0, 0.0)
        else
            x = (f2.bias - f1.bias) / (f1.slope - f2.slope)
            y = x * f1.slope + f1.bias
        end
    elseif f1.isXFixed && f1.isYFixed && f2.isXFixed && f2.isYFixed
        same = f1.xMax == f2.xMax && f1.yMax == f2.yMax
        return FastSolution(same, false, false, same ? f1.xMax : 0.0, same ? f1.yMax : 0.0)
    elseif f1.isXFixed && f1.isYFixed
        y = f1.xMax * f2.slope + f2.bias
        x = f1.xMax
        if y != f1.yMax
            return FastSolution(false, false, false, 0.0, 0.0)
        end
    elseif f2.isXFixed && f2.isYFixed
        y = f2.xMax * f1.slope + f1.bias
        x = f2.xMax
        if y != f2.yMax
            return FastSolution(false, false, false, 0.0, 0.0)
        end
    elseif f1.isXFixed && f2.isYFixed
        x = f1.xMax; y = f2.yMax
    elseif f1.isYFixed && f2.isXFixed
        x = f2.xMax; y = f1.yMax
    elseif f1.isXFixed && f2.isXFixed
        if f1.xMax != f2.xMax
            return FastSolution(false, false, false, 0.0, 0.0)
        end
        blocks = f1.yMax > f2.yMin && f1.yMin < f2.yMax
        return FastSolution(true, blocks, true, f1.x1, f1.yMax)
    elseif f1.isYFixed && f2.isYFixed
        if f1.yMax != f2.yMax
            return FastSolution(false, false, false, 0.0, 0.0)
        end
        blocks = f1.xMax > f2.xMin && f1.xMin < f2.xMax
        return FastSolution(true, blocks, true, f1.xMax, f1.y1)
    elseif f1.isXFixed
        x = f1.xMax; y = f1.xMax * f2.slope + f2.bias
    elseif f1.isYFixed
        x = f1.yMax * f2.slopeInv + f2.biasInv; y = f1.yMax
    elseif f2.isXFixed
        x = f2.xMax; y = f2.xMax * f1.slope + f1.bias
    elseif f2.isYFixed
        x = f2.yMax * f1.slopeInv + f1.biasInv; y = f2.yMax
    end

    in_range = x <= f1.xMax && x >= f1.xMin && y <= f1.yMax && y >= f1.yMin &&
               x <= f2.xMax && x >= f2.xMin && y <= f2.yMax && y >= f2.yMin
    if !in_range
        return FastSolution(true, false, false, x, y)
    end
    is_end = ((x == f1.x1 && y == f1.y1) || (x == f1.x2 && y == f1.y2)) &&
             ((x == f2.x1 && y == f2.y1) || (x == f2.x2 && y == f2.y2))
    return FastSolution(true, !is_end, false, x, y)
end

# ---- Test harness ----
passed = 0
failed = 0

function cmp(a::FastSolution, b::FastSolution, tol=1e-12)
    return a.hasSolution == b.hasSolution &&
           a.blockVision == b.blockVision &&
           a.hasManySolution == b.hasManySolution &&
           (isnan(a.x) && isnan(b.x) || abs(a.x - b.x) < tol) &&
           (isnan(a.y) && isnan(b.y) || abs(a.y - b.y) < tol)
end

function runtest(name, f1, f2)
    global passed, failed
    r = solveRef(f1, f2)
    s = solveFast(f1, f2)
    ok = cmp(r, s)
    if !ok
        println("FAIL: $name")
        println("  ref:  hasSol=$(r.hasSolution) block=$(r.blockVision) many=$(r.hasManySolution) x=$(r.x) y=$(r.y)")
        println("  fast: hasSol=$(s.hasSolution) block=$(s.blockVision) many=$(s.hasManySolution) x=$(s.x) y=$(s.y)")
        global failed += 1
    else
        global passed += 1
    end
    return ok
end

# ---- Test cases ----
v = 3.7

runtest("same point", LinearFunc2D(v,v,v,v), LinearFunc2D(v,v,v,v))
runtest("different points", LinearFunc2D(v,v,v,v), LinearFunc2D(v+1,v+1,v+1,v+1))
runtest("point on sloped line (blocking)", LinearFunc2D(v,v,v,v), LinearFunc2D(v-1,v-1,v+1,v+1))
runtest("point on sloped line (endpoint)", LinearFunc2D(v,v,v,v), LinearFunc2D(v,v,v+2,v+2))
runtest("crossing sloped lines", LinearFunc2D(0.0,0.0,10.0,10.0), LinearFunc2D(0.0,10.0,10.0,0.0))
runtest("parallel sloped lines", LinearFunc2D(0.0,0.0,10.0,10.0), LinearFunc2D(0.0,1.0,10.0,11.0))
runtest("collinear overlapping", LinearFunc2D(0.0,0.0,10.0,10.0), LinearFunc2D(3.0,3.0,7.0,7.0))
runtest("collinear disjoint", LinearFunc2D(0.0,0.0,2.0,2.0), LinearFunc2D(5.0,5.0,8.0,8.0))
runtest("perpendicular crossing", LinearFunc2D(5.0,0.0,5.0,10.0), LinearFunc2D(0.0,5.0,10.0,5.0))
runtest("perpendicular crossing 2", LinearFunc2D(0.0,5.0,10.0,5.0), LinearFunc2D(5.0,0.0,5.0,10.0))
runtest("vertical same x overlapping", LinearFunc2D(5.0,0.0,5.0,8.0), LinearFunc2D(5.0,3.0,5.0,10.0))
runtest("vertical same x disjoint", LinearFunc2D(5.0,0.0,5.0,2.0), LinearFunc2D(5.0,4.0,5.0,8.0))
runtest("vertical different x", LinearFunc2D(5.0,0.0,5.0,8.0), LinearFunc2D(7.0,0.0,7.0,8.0))
runtest("horizontal same y overlapping", LinearFunc2D(0.0,5.0,8.0,5.0), LinearFunc2D(3.0,5.0,10.0,5.0))
runtest("horizontal same y disjoint", LinearFunc2D(0.0,5.0,2.0,5.0), LinearFunc2D(4.0,5.0,8.0,5.0))
runtest("horizontal different y", LinearFunc2D(0.0,5.0,8.0,5.0), LinearFunc2D(0.0,7.0,8.0,7.0))
runtest("sloped crossing at endpoint", LinearFunc2D(0.0,0.0,5.0,5.0), LinearFunc2D(5.0,5.0,10.0,0.0))
runtest("point on vertical line", LinearFunc2D(5.0,3.0,5.0,3.0), LinearFunc2D(5.0,0.0,5.0,10.0))
runtest("point on horizontal line", LinearFunc2D(4.0,5.0,4.0,5.0), LinearFunc2D(0.0,5.0,10.0,5.0))
runtest("point not on vertical line", LinearFunc2D(7.0,3.0,7.0,3.0), LinearFunc2D(5.0,0.0,5.0,10.0))
runtest("point not on horizontal line", LinearFunc2D(4.0,7.0,4.0,7.0), LinearFunc2D(0.0,5.0,10.0,5.0))
runtest("vertical x sloped (inside)", LinearFunc2D(5.0,0.0,5.0,10.0), LinearFunc2D(0.0,0.0,10.0,10.0))
runtest("horizontal x sloped (inside)", LinearFunc2D(0.0,5.0,10.0,5.0), LinearFunc2D(0.0,0.0,10.0,10.0))
runtest("vertical x sloped (outside)", LinearFunc2D(15.0,0.0,15.0,10.0), LinearFunc2D(0.0,0.0,10.0,10.0))
runtest("sloped meeting at endpoint", LinearFunc2D(0.0,0.0,4.0,4.0), LinearFunc2D(4.0,4.0,8.0,0.0))
runtest("horizontal x sloped (endpoint)", LinearFunc2D(0.0,5.0,10.0,5.0), LinearFunc2D(0.0,0.0,0.0,10.0))

# ---- Fuzz tests ----
using Random
Random.seed!(42)
for i in 1:500
    x1, y1 = rand(2) .* 20 .- 10
    x2, y2 = rand(2) .* 20 .- 10
    f1 = LinearFunc2D(x1, y1, x2, y2)
    x1, y1 = rand(2) .* 20 .- 10
    x2, y2 = rand(2) .* 20 .- 10
    f2 = LinearFunc2D(x1, y1, x2, y2)
    runtest("fuzz $i", f1, f2)
end

println("\n========================")
println("Results: $passed passed, $failed failed")
println("========================")
