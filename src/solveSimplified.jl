function solveSimplified(f1::LinearFunc2D, f2::LinearFunc2D)
    # Simplified branch-based segment intersection
    # Strategy: early-return for trivial cases, compute x,y once, common range check at end

    # ---- Only 2 precomputations (reused in point-on-line checks) ----
    f1y_on_f2 = f1.xMax * f2.slope + f2.bias
    f2y_on_f1 = f2.xMax * f1.slope + f1.bias

    # ---- Case 1: Both are points ----
    if f1.isXFixed && f1.isYFixed && f2.isXFixed && f2.isYFixed
        same = f1.xMax == f2.xMax && f1.yMax == f2.yMax
        return FastSolution(same, false, false, same ? f1.xMax : 0.0, same ? f1.yMax : 0.0)
    end

    # ---- Case 2: f1 is a point, f2 is not ----
    if f1.isXFixed && f1.isYFixed
        f1y_on_f2 != f1.yMax && return FastSolution(true, false, false, 0.0, 0.0)
        x, y = f1.xMax, f1.yMax  # point lies on f2's line

    # ---- Case 3: f2 is a point, f1 is not ----
    elseif f2.isXFixed && f2.isYFixed
        f2y_on_f1 != f2.yMax && return FastSolution(true, false, false, 0.0, 0.0)
        x, y = f2.xMax, f2.yMax

    # ---- Case 4: Both vertical lines ----
    elseif f1.isXFixed && !f1.isYFixed && f2.isXFixed && !f2.isYFixed
        f1.xMax != f2.xMax && return FastSolution(false, false, false, 0.0, 0.0)
        blocks = f1.yMax > f2.yMin && f1.yMin < f2.yMax
        return FastSolution(true, blocks, true, f1.x1, f1.yMax)

    # ---- Case 5: Both horizontal lines ----
    elseif f1.isYFixed && !f1.isXFixed && f2.isYFixed && !f2.isXFixed
        f1.yMax != f2.yMax && return FastSolution(false, false, false, 0.0, 0.0)
        blocks = f1.xMax > f2.xMin && f1.xMin < f2.xMax
        return FastSolution(true, blocks, true, f1.xMax, f1.y1)

    # ---- Both sloped lines (general case) ----
    elseif !f1.isXFixed && !f1.isYFixed && !f2.isXFixed && !f2.isYFixed
        if f1.slope == f2.slope
            if f1.bias == f2.bias
                blocks = f1.xMax > f2.xMin && f1.xMin < f2.xMax
                return FastSolution(true, blocks, true, f1.x1, f1.y1)
            end
            return FastSolution(false, false, false, 0.0, 0.0)
        end
        x = (f2.bias - f1.bias) / (f1.slope - f2.slope)
        y = f1.slope * x + f1.bias

    # ---- f1 vertical, f2 sloped or horizontal ----
    elseif f1.isXFixed && !f1.isYFixed
        x = f1.xMax
        y = f2.isYFixed && !f2.isXFixed ? f2.yMax : f1.xMax * f2.slope + f2.bias

    # ---- f1 horizontal, f2 sloped or vertical ----
    elseif f1.isYFixed && !f1.isXFixed
        y = f1.yMax
        x = f2.isXFixed && !f2.isYFixed ? f2.xMax : f1.yMax * f2.slopeInv + f2.biasInv

    # ---- f2 vertical, f1 sloped ----
    elseif f2.isXFixed && !f2.isYFixed
        x = f2.xMax
        y = f2.xMax * f1.slope + f1.bias

    # ---- f2 horizontal, f1 sloped ----
    else # f2.isYFixed && !f2.isXFixed
        y = f2.yMax
        x = f2.yMax * f1.slopeInv + f1.biasInv
    end

    # ---- Common range check for all single-solution cases ----
    in_range = x <= f1.xMax && x >= f1.xMin && y <= f1.yMax && y >= f1.yMin &&
               x <= f2.xMax && x >= f2.xMin && y <= f2.yMax && y >= f2.yMin

    in_range || return FastSolution(true, false, false, x, y)

    # ---- Endpoint check: intersection at segment endpoints is not blocking ----
    is_end = (x == f1.x1 && y == f1.y1) || (x == f1.x2 && y == f1.y2) ||
             (x == f2.x1 && y == f2.y1) || (x == f2.x2 && y == f2.y2)

    return FastSolution(true, !is_end, false, x, y)
end
