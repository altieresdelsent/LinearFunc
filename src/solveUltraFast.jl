function solveUltraFast(first::LinearFunc2D, second::LinearFunc2D)
    # Branchless line-segment intersection using ifelse (compiles to conditional move)
    # No if/elseif/else, no &&/|| — only ifelse, &, |
    
    f1 = first; f2 = second
    
    # ---- Boolean masks (bitwise & and | only, no short-circuit) ----
    both_pts      = f1.isXFixed & f1.isYFixed & f2.isXFixed & f2.isYFixed
    same_pt       = both_pts & (f1.xMax == f2.xMax) & (f1.yMax == f2.yMax)
    
    f1_is_pt      = f1.isXFixed & f1.isYFixed & !(f2.isXFixed & f2.isYFixed)
    f1_on_f2_y    = f1.xMax * f2.slope + f2.bias
    f1_on_f2      = f1_is_pt & (f1_on_f2_y == f1.yMax)
    
    f2_is_pt      = f2.isXFixed & f2.isYFixed & !(f1.isXFixed & f1.isYFixed)
    f2_on_f1_y    = f2.xMax * f1.slope + f1.bias
    f2_on_f1      = f2_is_pt & (f2_on_f1_y == f2.yMax)
    
    xperp_y       = f1.isXFixed & !f1.isYFixed & f2.isYFixed & !f2.isXFixed
    yperp_x       = f1.isYFixed & !f1.isXFixed & f2.isXFixed & !f2.isYFixed
    
    f1_only_x     = f1.isXFixed & !f1.isYFixed
    f1_only_y     = f1.isYFixed & !f1.isXFixed
    f2_only_x     = f2.isXFixed & !f2.isYFixed
    f2_only_y     = f2.isYFixed & !f2.isXFixed
    
    both_xf       = f1.isXFixed & !f1.isYFixed & f2.isXFixed & !f2.isYFixed
    same_xline    = both_xf & (f1.xMax == f2.xMax)
    xf_overlap    = same_xline & (
        (f1.yMax < f2.yMax) & (f1.yMax > f2.yMin) |
        (f1.yMin < f2.yMax) & (f1.yMin > f2.yMin) |
        (f2.yMin < f1.yMax) & (f2.yMin > f1.yMin)
    )
    
    both_yf       = f1.isYFixed & !f1.isXFixed & f2.isYFixed & !f2.isXFixed
    same_yline    = both_yf & (f1.yMax == f2.yMax)
    yf_overlap    = same_yline & (
        (f1.xMax < f2.xMax) & (f1.xMax > f2.xMin) |
        (f1.xMin < f2.xMax) & (f1.xMin > f2.xMin) |
        (f2.xMin < f1.xMax) & (f2.xMin > f1.xMin)
    )
    
    neither_fixed = !f1.isXFixed & !f1.isYFixed & !f2.isXFixed & !f2.isYFixed
    parallel      = neither_fixed & (f1.slope == f2.slope)
    collinear     = parallel & (f1.bias == f2.bias)
    col_overlap   = collinear & (
        (f1.xMax < f2.xMax) & (f1.xMax > f2.xMin) |
        (f1.xMin < f2.xMax) & (f1.xMin > f2.xMin)
    )
    
    # ---- Compute intersection point (all cases, using ifelse cascade) ----
    x_normal = (f2.bias - f1.bias) / (f1.slope - f2.slope)
    y_normal = f1.slope * x_normal + f1.bias
    
    # x selection — priority: same_pt > xperp_y > yperp_x > f1_x > f1_y > f2_x > f2_y > f1_pt > f2_pt > normal
    x = ifelse(same_pt,    f1.xMax,
        ifelse(xperp_y,    f1.xMax,
        ifelse(yperp_x,    f2.xMax,
        ifelse(f1_only_x,  f1.xMax,
        ifelse(f1_only_y,  f1.yMax * f2.slopeInv + f2.biasInv,
        ifelse(f2_only_x,  f2.xMax,
        ifelse(f2_only_y,  f2.yMax * f1.slopeInv + f1.biasInv,
        ifelse(f1_is_pt,   f1.xMax,
        ifelse(f2_is_pt,   f2.xMax,
        x_normal)))))))))
    
    # y selection — same priority order
    y = ifelse(same_pt,    f1.yMax,
        ifelse(xperp_y,    f2.yMax,
        ifelse(yperp_x,    f1.yMax,
        ifelse(f1_only_x,  f1.xMax * f2.slope + f2.bias,
        ifelse(f1_only_y,  f1.yMax,
        ifelse(f2_only_x,  f2.xMax * f1.slope + f1.bias,
        ifelse(f2_only_y,  f2.yMax,
        ifelse(f1_is_pt,   f1_on_f2_y,
        ifelse(f2_is_pt,   f2_on_f1_y,
        y_normal)))))))))
    
    # ---- Range check ----
    in_range = (x <= f1.xMax) & (x >= f1.xMin) & (y <= f1.yMax) & (y >= f1.yMin) &
               (x <= f2.xMax) & (x >= f2.xMin) & (y <= f2.yMax) & (y >= f2.yMin)
    
    is_endpt = ((x == f1.x1) & (y == f1.y1)) | ((x == f1.x2) & (y == f1.y2)) |
               ((x == f2.x1) & (y == f2.y1)) | ((x == f2.x2) & (y == f2.y2))
    
    # ---- Outcome booleans ----
    no_sol   = (both_pts & !same_pt) |
               (f1_is_pt & !f1_on_f2) |
               (f2_is_pt & !f2_on_f1) |
               (both_xf & !same_xline) |
               (both_yf & !same_yline) |
               (parallel & !collinear)
    
    blocks   = xf_overlap | yf_overlap | col_overlap |
               f1_on_f2 | f2_on_f1 |
               (in_range & !is_endpt & !no_sol)
    many     = same_xline | same_yline | collinear
    
    # ---- Final result assembly using ifelse ----
    x_out = ifelse(no_sol, 0.0,
            ifelse(xf_overlap, f1.x1,
            ifelse(yf_overlap, f1.xMax,
            ifelse(col_overlap, f1.x1,
            x))))
    
    y_out = ifelse(no_sol, 0.0,
            ifelse(xf_overlap, f1.yMax,
            ifelse(yf_overlap, f1.y1,
            ifelse(col_overlap, f1.y1,
            y))))
    
    return FastSolution(!no_sol, blocks, many, x_out, y_out)
end
