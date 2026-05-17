function getEncounterPoint(first::LinearFunc2D,second::LinearFunc2D)

    determinant = first.slope*second.bias - second.slope*first.bias
    x = 0.0
    y = 0.0
    if(first.isXFixed)&&(first.isYFixed)&&(second.isXFixed)&&(second.isYFixed)
        if(first.xMax == second.xMax) && (first.yMax == second.yMax)
            x = first.xMax
            y = first.yMax
            return FastSolution(true,false,false)
        else
            return FastSolution(false,false,false)
        end
    elseif(first.isXFixed)&&(first.isYFixed)
        y = first.xMax*second.slope + eye.bias
        x = first.xMax
        if(y != first.yMax)
            return FastSolution(false,true,false)
        end
    elseif(second.isXFixed)&&(second.isYFixed)
        y = second.xMax*first.slope + first.bias
        x = second.xMax
        if(y != second.yMax)
            return FastSolution(false,true,[0.0,0.0])
        end
    elseif(first.isXFixed)&&(second.isYFixed)
        x = first.xMax
        y = second.yMax
    elseif(first.isYFixed)&&(second.isXFixed)
        x = second.xMax
        y = first.yMax
    elseif(first.isXFixed)&&(second.isXFixed)
        if(first.xMax == second.xMax)&&((first.yMin > second.yMax)||(first.yMax > second.yMin))
            return FastSolution(true,true,true)
        elseif(first.xMax == second.xMax)
            return FastSolution(true,false,true)
        else
            return FastSolution(false,false,false)
        end
    elseif(first.isYFixed)&&(second.isYFixed)
        if(first.yMax == second.yMax)&&((first.xMin > second.xMax)||(first.xMax > second.xMin))
            return FastSolution(true,true,true)
        elseif(first.yMax == second.yMax)
            return FastSolution(true,false,true)
        else
            return FastSolution(false,false,false)
        end
    elseif(first.isXFixed)
        x = first.xMax
        y = first.xMax*second.slope + second.bias
    elseif(first.isYFixed)
        x = first.yMax*second.slopeInv + second.biasInv
        y = first.yMax
    elseif(second.isXFixed)
        x = second.xMax
        y = second.xMax*first.slope + first.bias
    elseif(second.isYFixed)
        x = second.yMax*first.slopeInv + first.biasInv
        y = second.yMax
    else
        if(first.slope == second.slope)&&(first.bias == second.bias)&&((first.xMax <= second.xMax)&&(first.xMax >= second.xMin)||(first.xMin <= second.xMax)&&(first.xMin >= second.xMin))
            return FastSolution(true,true,true)
        elseif(second.slope == first.slope)
            return FastSolution(true,false,true)
        else
            x = (second.bias - first.bias)/(first.slope-second.slope)
            y = x*first.slope + first.bias
        end
    end

    if(x <= first.xMax)&&(x >= first.xMin)&&(y <= first.yMax)&&(y >= first.yMin)&&(x <= second.xMax)&&(x >= second.xMin)&&(y <= second.yMax)&&(y >= second.yMin)
        return FastSolution(true,true,false)
    else
        return FastSolution(true,false,false)
    end
end
