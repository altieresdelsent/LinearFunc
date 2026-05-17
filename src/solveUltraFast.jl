function solveUltraFast(f1::LinearFunc2D, f2::LinearFunc2D)
    # Branchless segment intersection — zero if/elseif/else/&&/||
    # Uses only ifelse (cmov), &, | — all compile to branchless instructions

    # ---- Precomputed values used multiple times ----
    f1y_on_f2 = f1.xMax * f2.slope + f2.bias
    f2y_on_f1 = f2.xMax * f1.slope + f1.bias

    # ---- Case masks (priority-ordered for ifelse chain) ----
    f1pt  = f1.isXFixed & f1.isYFixed
    f2pt  = f2.isXFixed & f2.isYFixed
    sampt = f1pt & f2pt & (f1.xMax == f2.xMax) & (f1.yMax == f2.yMax)

    xperp = f1.isXFixed & !f1.isYFixed & f2.isYFixed & !f2.isXFixed
    yperp = f1.isYFixed & !f1.isXFixed & f2.isXFixed & !f2.isYFixed

    # ---- Intersection point (x, y) via nested ifelse ----
    x = ifelse(sampt,  f1.xMax,
        ifelse(f1pt,   f1.xMax,
        ifelse(f2pt,   f2.xMax,
        ifelse(xperp,  f1.xMax,
        ifelse(yperp,  f2.xMax,
        ifelse(f1.isXFixed & !f1.isYFixed,  f1.xMax,
        ifelse(f1.isYFixed & !f1.isXFixed,  f1.yMax * f2.slopeInv + f2.biasInv,
        ifelse(f2.isXFixed & !f2.isYFixed,  f2.xMax,
        ifelse(f2.isYFixed & !f2.isXFixed,  f2.yMax * f1.slopeInv + f1.biasInv,
        (f2.bias - f1.bias) / (f1.slope - f2.slope))))))))))

    y = ifelse(sampt,  f1.yMax,
        ifelse(f1pt,   f1y_on_f2,
        ifelse(f2pt,   f2y_on_f1,
        ifelse(xperp,  f2.yMax,
        ifelse(yperp,  f1.yMax,
        ifelse(f1.isXFixed & !f1.isYFixed,  f1.xMax * f2.slope + f2.bias,
        ifelse(f1.isYFixed & !f1.isXFixed,  f1.yMax,
        ifelse(f2.isXFixed & !f2.isYFixed,  f2.xMax * f1.slope + f1.bias,
        ifelse(f2.isYFixed & !f2.isXFixed,  f2.yMax,
        f1.slope * x + f1.bias)))))))))

    # ---- Overlap checks (simplified: amax > bmin & amin < bmax) ----
    both_xf = f1.isXFixed & !f1.isYFixed & f2.isXFixed & !f2.isYFixed
    both_yf = f1.isYFixed & !f1.isXFixed & f2.isYFixed & !f2.isXFixed
    parallel = !f1.isXFixed & !f1.isYFixed & !f2.isXFixed & !f2.isYFixed & (f1.slope == f2.slope)
    collinear = parallel & (f1.bias == f2.bias)

    same_x = both_xf & (f1.xMax == f2.xMax)
    same_y = both_yf & (f1.yMax == f2.yMax)

    xf_ov = same_x & (f1.yMax > f2.yMin) & (f1.yMin < f2.yMax)
    yf_ov = same_y & (f1.xMax > f2.xMin) & (f1.xMin < f2.xMax)
    col_ov = collinear & (f1.xMax > f2.xMin) & (f1.xMin < f2.xMax)

    # ---- Point-on-line checks ----
    f1_on_f2 = f1pt & !f2pt & (f1y_on_f2 == f1.yMax)
    f2_on_f1 = f2pt & !f1pt & (f2y_on_f1 == f2.yMax)

    # ---- Range & endpoint checks ----
    in_range = (x <= f1.xMax) & (x >= f1.xMin) & (y <= f1.yMax) & (y >= f1.yMin) &
               (x <= f2.xMax) & (x >= f2.xMin) & (y <= f2.yMax) & (y >= f2.yMin)

    is_end = ((x == f1.x1) & (y == f1.y1)) | ((x == f1.x2) & (y == f1.y2)) |
             ((x == f2.x1) & (y == f2.y1)) | ((x == f2.x2) & (y == f2.y2))

    # ---- Outcomes ----
    no_sol = (f1pt & f2pt & !sampt) |
             (f1pt & !f2pt & !f1_on_f2) |
             (f2pt & !f1pt & !f2_on_f1) |
             (both_xf & !same_x) |
             (both_yf & !same_y) |
             (parallel & !collinear)

    blocks = xf_ov | yf_ov | col_ov |
             (in_range & !is_end & !no_sol)

    many = same_x | same_y | collinear

    # ---- Final assembly: override x,y for many-solution & no-solution cases ----
    x_out = ifelse(no_sol, 0.0,
            ifelse(same_x, f1.x1,
            ifelse(same_y, f1.xMax,
            ifelse(collinear, f1.x1, x))))

    y_out = ifelse(no_sol, 0.0,
            ifelse(same_x, f1.yMax,
            ifelse(same_y, f1.y1,
            ifelse(collinear, f1.y1, y))))

    return FastSolution(!no_sol, blocks, many, x_out, y_out)
end
