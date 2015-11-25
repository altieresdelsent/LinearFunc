immutable LinearFunc2D
    x1::Float64
    y1::Float64
    x2::Float64
    y2::Float64
    xMax::Float64
    yMax::Float64
    xMin::Float64
    yMin::Float64
    slope::Float64
    slopeInv::Float64
    bias::Float64
    biasInv::Float64
    isXFixed::Bool
    isYFixed::Bool
    function LinearFunc2D()
        xMax = realmax(Float64)
        yMax = realmax(Float64)
        xMin = realmin(Float64)
        yMin = realmin(Float64)
        slope = 1.0
        slopeInv = 1.0
        bias = 0.0
        biasInv = 0.0
        isXFixed = false
        isYFixed = false
        return new(xMax,yMax,xMin,yMin,slope,slopeInv,bias,biasInv,isXFixed,isYFixed)
    end
    function LinearFunc2D(x1::Float64,y1::Float64,x2::Float64,y2::Float64)
        changeX = x1 - x2
        changeY = y1 - y2

        xMax = max(x1,x2)
        yMax = max(y1,y2)
        xMin = min(x1,x2)
        yMin = min(y1,y2)

        if(changeX != 0.0)&&(changeY != 0)
            slope = changeY/changeX
            slopeInv = changeX/changeY
            bias = y1-slope*x1
            biasInv = x1-slopeInv*y1
            isXFixed = false
            isYFixed = false
            return new(x1,y1,x2,y2,xMax,yMax,xMin,yMin,slope,slopeInv,bias,biasInv,isXFixed,isYFixed)
        elseif(changeX != 0.0)
            slope = 0.0
            slopeInv = typemax(Float64)
            bias = yMax
            biasInv = typemax(Float64)
            isXFixed = false
            isYFixed = true
            return new(x1,y1,x2,y2,xMax,yMax,xMin,yMin,slope,slopeInv,bias,biasInv,isXFixed,isYFixed)
        elseif(changeY != 0.0)
            slope = typemax(Float64)
            slopeInv = 0.0
            bias = typemax(Float64)
            biasInv = xMax
            isXFixed = true
            isYFixed = false
            return new(x1,y1,x2,y2,xMax,yMax,xMin,yMin,slope,slopeInv,bias,biasInv,isXFixed,isYFixed)
        else
            slope = 0.0
            slopeInv = 0.0
            bias = 0.0
            biasInv = 0.0
            isXFixed = true
            isYFixed = true
            return new(x1,y1,x2,y2,xMax,yMax,xMin,yMin,slope,slopeInv,bias,biasInv,isXFixed,isYFixed)
        end
    end
    function LinearFunc2D(slope::Float64,bias::Float64,biasInv::Float64)
        MaxValue = realmax(Float64)
        MinValue = realmin(Float64)
        PositiveInfinity = typemax(Float64)
        NegativeInfinity = typemin(Float64)
        if slope == 0.0d
            slope = 0.0d
            yMax = MaxValue
            yMin = MinValue
            xMax = biasInv
            xMin = biasInv
            x1 = biasInv
            x2 = biasInv
            y1 = MaxValue
            y2 = MinValue
            bias = PositiveInfinity
            slopeInv = PositiveInfinity
            isXFixed = false
            isYFixed = true
            return new(x1,y1,x2,y2,xMax,yMax,xMin,yMin,slope,slopeInv,bias,biasInv,isXFixed,isYFixed)
        elseif PositiveInfinity == slope || slope == MaxValue
            slope = MaxValue
            xMax = MaxValue
            xMin = MinValue
            bias = bias
            yMax = bias
            yMin = bias
            y1 = bias
            y2 = bias
            x1 = MaxValue
            x2 = MinValue
            biasInv = PositiveInfinity
            slopeInv = 0.0d
            isXFixed = true
            isYFixed = false
            return new(x1,y1,x2,y2,xMax,yMax,xMin,yMin,slope,slopeInv,bias,biasInv,isXFixed,isYFixed)
        else
            slope = slope
            slopeInv = 1.0d / slope
            bias = bias
            biasInv = biasInv
            isXFixed = false
            isYFixed = false
            if slope > 0.0d
                if slope > 1.0d
                    yMax = MaxValue - abs(biasInv)
                    xMax = yMax * slopeInv + biasInv

                    yMin = MinValue + abs(biasInv)
                    xMin = yMin * slopeInv + biasInv
                elseif (slope < 1.0d)
                    xMax = MaxValue - abs(bias)
                    yMax = xMax * slope + bias

                    xMin = MinValue + abs(bias)
                    yMin = xMin * slope + bias
                elseif(bias != 0.0)
                    xMax = MaxValue - abs(bias)
                    yMax = MaxValue - abs(bias)

                    xMin = MinValue + abs(bias)
                    yMin = MinValue + abs(bias)
                else
                    xMax = MaxValue
                    yMax = MaxValue

                    xMin = MinValue
                    yMin = MinValue
                end
                x1 = xMax
                y1 = yMax
                x2 = xMin
                y2 = yMin
                return new(x1,y1,x2,y2,xMax,yMax,xMin,yMin,slope,slopeInv,bias,biasInv,isXFixed,isYFixed)
            else
                if slope < -1.0d
                    yMax = MaxValue - abs(biasInv)
                    xMin = yMax * slopeInv + biasInv

                    yMin = MinValue + abs(biasInv)
                    xMax = yMin * slopeInv + biasInv
                elseif slope > -1.0d
                    xMax = MaxValue - abs(bias)
                    yMin = xMax * slope + bias

                    xMin = MinValue + abs(bias)
                    yMax = xMin * slope + bias
                else
                    xMax = MaxValue - abs(bias)
                    yMax = MaxValue - abs(bias)

                    xMin = MinValue + abs(bias)
                    yMin = MinValue + abs(bias)
                end
                x1 = xMax
                y1 = yMin
                x2 = xMin
                y2 = yMax
                return new(x1,y1,x2,y2,xMax,yMax,xMin,yMin,slope,slopeInv,bias,biasInv,isXFixed,isYFixed)
            end
        end
    end
end
