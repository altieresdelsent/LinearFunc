function solve(first::LinearFunc2D,second::LinearFunc2D)
    x = 0.0
    y = 0.0


    if !first.isXFixed && !first.isYFixed && !second.isXFixed && !second.isYFixed
        #if enter here, means the no slope are zeros, and we can solve using normal equation solution
        #check if both lines are the same line and the range touch of one touch the another
        if first.slope == second.slope && first.bias == second.bias && ((first.xMax <= second.xMax && first.xMax >= second.xMin) || (first.xMin <= second.xMax && first.xMin >= second.xMin))
            return false
        #check if both line are the same line
        elseif second.slope == first.slope && first.bias == second.bias
            return true
        #check if both lines are parallel
        elseif second.slope == first.slope
            return true
        # finally solve the equation system
        # first.slope*x + first.bias = y
        # second.slope*x + second.bias = y
        # by the magic of high school math it can be transforme in
        # first.slope*x + first.bias = second.slope*x + second.bias
        # and
        # first.slope*x  = second.slope*x + second.bias  - first.bias
        # and
        # first.slope*x - second.slope*x  = second.bias  - first.bias
        # and
        # x * (first.slope - second.slope) = second.bias  - first.bias
        # and FINALLY
        # x = (second.bias - first.bias)/(first.slope-second.slope)
        # after solve the "x" unknown, just put x in any of the equations
        # like
        # y = x*first.slope + first.bias
        # and we have x and y
        else
            x = (second.bias - first.bias)/(first.slope-second.slope)
            y = x*first.slope + first.bias
        end
    #Test if both linear func are points
    elseif first.isXFixed && first.isYFixed && second.isXFixed && second.isYFixed
        #if they are the same points, they are visible one to other and no one is
        #blocking the vision
        if first.xMax == second.xMax && first.yMax == second.yMax
            x = first.xMax
            y = first.yMax
            return true
        else
           #otherwise they have no solution, but still dont block the vision
            return true
        end
    #if first is a point, check is that point is part of the line of the second
    elseif first.isXFixed && first.isYFixed
        y = first.xMax*second.slope + second.bias
        x = first.xMax
        #if it's not, it will return that it's not blocking the vision, if it is, will
        #load y and x to later check if they are in the range.
        if y != first.yMax
            return true
        end
    #the same check but now with second
    elseif second.isXFixed && second.isYFixed
        y = second.xMax*first.slope + first.bias
        x = second.xMax
        if y != second.yMax
            return true
        end
    # if first and second are perpendicular it's easy to calc the encounter point
    elseif first.isXFixed && second.isYFixed
        x = first.xMax
        y = second.yMax
    # if first and second are perpendicular it's easy to calc the encounter point( again, hehe)
    elseif first.isYFixed && second.isXFixed
        x = second.xMax
        y = first.yMax
    #if first and second are parallel horizontaly
    elseif first.isXFixed && second.isXFixed
        #check if they are the same line, and also check if the range of the two lines crosses one another
        #if yes, they are blocking the vision
        if first.xMax == second.xMax && ((first.yMax < second.yMax && first.yMax > second.yMin) || (first.yMin < second.yMax && first.yMin > second.yMin) || (second.yMin < first.yMax && second.yMin > first.yMin))
            return false
        #otherwise still check if they are the same line, but they are not blocking the vision and systems have many solutions
        elseif first.xMax == second.xMax
            return true
        else
        # if they are not the same line, there is no solution
            return true
        end
    #if first and second are parallel vertically, do the same check before
    elseif first.isYFixed && second.isYFixed
        if first.yMax == second.yMax && ((first.xMax < second.xMax && first.xMax > second.xMin) || (first.xMin < second.xMax && first.xMin > second.xMin) || (second.xMin < first.xMax && second.xMin > first.xMin))
            return false
        elseif first.yMax == second.yMax
            return true
        else
            return true
        end
    #if it is here, the two lines are not fixed, so check
    #if one is fixed, if it is, keep the variable who is fixed, fixed
    # and run the linear func to calc the y point
    elseif first.isXFixed
        x = first.xMax
        y = first.xMax*second.slope + second.bias
     # the same thing as before
    elseif first.isYFixed
        x = first.yMax*second.slopeInv + second.biasInv
        y = first.yMax
    # the same thing as before ( again)
    elseif second.isXFixed
        x = second.xMax
        y = second.xMax*first.slope + first.bias
    # the same thing as before ( again II)
    elseif second.isYFixed
        x = second.yMax*first.slopeInv + first.biasInv
        y = second.yMax

    #else
        #return true
        #warn("if falls here, it will create a black hole and destroy all humankind")
    end

    # if it's here, means the both lines are not parallel, neither the same line
    # so checks if the only solution to the system are inside of the range of both lines
    # if it is, it means that the lines are blocking the vision one from another
    if x <= first.xMax && x >= first.xMin && y <= first.yMax && y >= first.yMin && x <= second.xMax && x >= second.xMin && y <= second.yMax && y >= second.yMin
        #the only exception is if the encounter point is exactly the start or the end of any of the lines
        # it could consider that as blocking the vision, but the way it's now, it's easier to check if
        # two obstacles are crossing one another and also the visibility problem, so I solve two problems with one algorithm
        if (x == first.x1 && y == first.y1)|| (x == first.x2 && y == first.y2) || (x == second.x1 && y == second.y1) || (x == second.x2 && y == second.y2)
            return true
        else
            return false
        end
    # otherwise the system has one solution and line intersection are out of the range
    else
        return true
    end
end
