# standalone_test.jl — Tests solveUltraFast against a reference solve
# Uses modern Julia 1.x syntax compatible with Julia 1.12

# ---- Define types (modernized from LinearFunc2D.jl / FastSolution.jl) ----
struct LinearFunc2D
    x1::Float64; y1::Float64; x2::Float64; y2::Float64
    xMax::Float64; yMax::Float64; xMin::Float64; yMin::Float64
    slope::Float64; slopeInv::Float64; bias::Float64; biasInv::Float64
    isXFixed::Bool; isYFixed::Bool

    function LinearFunc2D(x1::Float64, y1::Float64, x2::Float64, y2::Float64)
        changeX = x1 - x2
        changeY = y1 - y2
        xMax = max(x1, x2); yMax = max(y1, y2)
        xMin = min(x1, x2); yMin = min(y1, y2)

        if changeX != 0.0 && changeY != 0.0
            slope = changeY / changeX
            slopeInv = changeX / changeY
            bias = y1 - slope * x1
            biasInv = x1 - slopeInv * y1
            return new(x1, y1, x2, y2, xMax, yMax, xMin, yMin, slope, slopeInv, bias, biasInv, false, false)
        elseif changeX != 0.0  # horizontal
            return new(x1, y1, x2, y2, xMax, yMax, xMin, yMin, 0.0, Inf, yMax, Inf, false, true)
        elseif changeY != 0.0  # vertical
            return new(x1, y1, x2, y2, xMax, yMax, xMin, yMin, Inf, 0.0, Inf, xMax, true, false)
        else  # point
            return new(x1, y1, x2, y2, xMax, yMax, xMin, yMin, 0.0, 0.0, 0.0, 0.0, true, true)
        end
    end
end

struct FastSolution
    hasSolution::Bool
    blockVision::Bool
    hasManySolution::Bool
    x::Float64
    y::Float64
end

# ---- Reference solver (ported from original solve.jl to return FastSolution) ----
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
    is_end = (x == f1.x1 && y == f1.y1) || (x == f1.x2 && y == f1.y2) ||
             (x == f2.x1 && y == f2.y1) || (x == f2.x2 && y == f2.y2)
    return FastSolution(true, !is_end, false, x, y)
end

# ---- Include the solveUltraFast function ----
include("src/solveUltraFast.jl")

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
    s = solveUltraFast(f1, f2)
    ok = cmp(r, s)
    if !ok
        println("FAIL: $name")
        println("  ref:   hasSol=$(r.hasSolution) block=$(r.blockVision) many=$(r.hasManySolution) x=$(r.x) y=$(r.y)")
        println("  ultra: hasSol=$(s.hasSolution) block=$(s.blockVision) many=$(s.hasManySolution) x=$(s.x) y=$(s.y)")
        global failed += 1
    else
        global passed += 1
    end
    return ok
end

# ---- Test cases ----
v = 3.7  # random-like test value

# Test 1: Same point
runtest("same point",
    LinearFunc2D(v,v,v,v),
    LinearFunc2D(v,v,v,v))

# Test 2: Different points
runtest("different points",
    LinearFunc2D(v,v,v,v),
    LinearFunc2D(v+1,v+1,v+1,v+1))

# Test 3: Point on sloped line (blocking)
runtest("point on sloped line (blocking)",
    LinearFunc2D(v,v,v,v),
    LinearFunc2D(v-1,v-1,v+1,v+1))

# Test 4: Point on sloped line (at endpoint)
runtest("point on sloped line (endpoint)",
    LinearFunc2D(v,v,v,v),
    LinearFunc2D(v,v,v+2,v+2))

# Test 5: Two crossing sloped lines
runtest("crossing sloped lines",
    LinearFunc2D(0.0,0.0,10.0,10.0),
    LinearFunc2D(0.0,10.0,10.0,0.0))

# Test 6: Parallel sloped lines (different bias)
runtest("parallel sloped lines",
    LinearFunc2D(0.0,0.0,10.0,10.0),
    LinearFunc2D(0.0,1.0,10.0,11.0))

# Test 7: Collinear overlapping lines
runtest("collinear overlapping",
    LinearFunc2D(0.0,0.0,10.0,10.0),
    LinearFunc2D(3.0,3.0,7.0,7.0))

# Test 8: Collinear non-overlapping
runtest("collinear disjoint",
    LinearFunc2D(0.0,0.0,2.0,2.0),
    LinearFunc2D(5.0,5.0,8.0,8.0))

# Test 9: Perpendicular crossing
runtest("perpendicular crossing",
    LinearFunc2D(5.0,0.0,5.0,10.0),
    LinearFunc2D(0.0,5.0,10.0,5.0))

# Test 10: Perpendicular crossing 2
runtest("perpendicular crossing 2",
    LinearFunc2D(0.0,5.0,10.0,5.0),
    LinearFunc2D(5.0,0.0,5.0,10.0))

# Test 11: Vertical lines same x overlapping
runtest("vertical same x overlapping",
    LinearFunc2D(5.0,0.0,5.0,8.0),
    LinearFunc2D(5.0,3.0,5.0,10.0))

# Test 12: Vertical lines same x disjoint
runtest("vertical same x disjoint",
    LinearFunc2D(5.0,0.0,5.0,2.0),
    LinearFunc2D(5.0,4.0,5.0,8.0))

# Test 13: Vertical lines different x
runtest("vertical different x",
    LinearFunc2D(5.0,0.0,5.0,8.0),
    LinearFunc2D(7.0,0.0,7.0,8.0))

# Test 14: Horizontal lines same y overlapping
runtest("horizontal same y overlapping",
    LinearFunc2D(0.0,5.0,8.0,5.0),
    LinearFunc2D(3.0,5.0,10.0,5.0))

# Test 15: Horizontal lines same y disjoint
runtest("horizontal same y disjoint",
    LinearFunc2D(0.0,5.0,2.0,5.0),
    LinearFunc2D(4.0,5.0,8.0,5.0))

# Test 16: Horizontal lines different y
runtest("horizontal different y",
    LinearFunc2D(0.0,5.0,8.0,5.0),
    LinearFunc2D(0.0,7.0,8.0,7.0))

# Test 17: Sloped crossing near endpoint
runtest("sloped crossing at endpoint",
    LinearFunc2D(0.0,0.0,5.0,5.0),
    LinearFunc2D(5.0,5.0,10.0,0.0))

# Test 18: Point on vertical line
runtest("point on vertical line",
    LinearFunc2D(5.0,3.0,5.0,3.0),
    LinearFunc2D(5.0,0.0,5.0,10.0))

# Test 19: Point on horizontal line
runtest("point on horizontal line",
    LinearFunc2D(4.0,5.0,4.0,5.0),
    LinearFunc2D(0.0,5.0,10.0,5.0))

# Test 20: Point NOT on vertical line
runtest("point not on vertical line",
    LinearFunc2D(7.0,3.0,7.0,3.0),
    LinearFunc2D(5.0,0.0,5.0,10.0))

# Test 21: Point NOT on horizontal line
runtest("point not on horizontal line",
    LinearFunc2D(4.0,7.0,4.0,7.0),
    LinearFunc2D(0.0,5.0,10.0,5.0))

# Test 22: Vertical crossing sloped
runtest("vertical x sloped (inside)",
    LinearFunc2D(5.0,0.0,5.0,10.0),
    LinearFunc2D(0.0,0.0,10.0,10.0))

# Test 23: Horizontal crossing sloped
runtest("horizontal x sloped (inside)",
    LinearFunc2D(0.0,5.0,10.0,5.0),
    LinearFunc2D(0.0,0.0,10.0,10.0))

# Test 24: Vertical crossing sloped outside range
runtest("vertical x sloped (outside)",
    LinearFunc2D(15.0,0.0,15.0,10.0),
    LinearFunc2D(0.0,0.0,10.0,10.0))

# Test 25: Sloped lines meeting at endpoint
runtest("sloped meeting at endpoint",
    LinearFunc2D(0.0,0.0,4.0,4.0),
    LinearFunc2D(4.0,4.0,8.0,0.0))

# Test 26: Horizontal crossing sloped (endpoint)
runtest("horizontal x sloped (endpoint)",
    LinearFunc2D(0.0,5.0,10.0,5.0),
    LinearFunc2D(0.0,0.0,0.0,10.0))

# ---- Randomized fuzz tests ----
using Random
Random.seed!(42)
for i in 1:500
    # Generate random segments
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
