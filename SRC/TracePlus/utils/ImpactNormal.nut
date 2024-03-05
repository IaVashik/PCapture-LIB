local GetImpactNormal = function(intersectionPoints, hitpos) { 
    // Calculate two edge vectors from intersection point to hitpos
    local edge1 = intersectionPoints.point1 - hitpos;
    local edge2 = intersectionPoints.point2 - hitpos;

    // Calculate the cross product of the two edges to find the normal vector
    local normal = edge2.Cross(edge1)
    normal.Norm()

    return normal
}


local GetNewStartsPos = function(startpos, dir) {
    // Calculate offset vectors perpendicular to the trace direction
    local perpDir = Vector(-dir.y, dir.x, 0)
    local offset1 = perpDir
    local offset2 = dir.Cross(offset1)

    // Calculate new start positions for two additional traces
    local newStart1 = startpos + offset1
    local newStart2 = startpos + offset2

    return [
        newStart1, 
        newStart2
    ]
}

local _getIntPoint = function(newStart, dir) {    
    return CheapTrace(newStart, (newStart + dir * 8000)).GetHitpos()
}

local _getIntPointCostly = function(newStart, dir, traceResult) {  
    // (startpos, endpos, ignoreEnts, settings, note)
    local endpos = newStart + dir * 8000   
    local trace = TraceLineAnalyzer(newStart, endpos, traceResult.GetIngoreEntities(), traceResult.GetTraceSettings(), traceResult.GetNote())
    return trace.GetHitpos()
}



::CalculateImpactNormal <- function(startpos, hitpos, traceResult) 
                        : (GetImpactNormal, GetNewStartsPos, _getIntPoint, _getIntPointCostly) 
{
    // Calculate the normalized direction vector from startpos to hitpos
    local dir = hitpos - startpos
    dir.Norm()

    local newStartsPos = GetNewStartsPos(startpos, dir)
    local intersectionPoints

    if(typeof traceResult == "BboxTraceResult" && traceResult.GetEntity() && traceResult.GetTraceSettings().useCostlyNormalComputation) {
        intersectionPoints = {
            point1 = _getIntPointCostly(newStartsPos[0], dir, traceResult),
            point2 = _getIntPointCostly(newStartsPos[1], dir, traceResult)
        }
    } else {
        intersectionPoints = {
            point1 = _getIntPoint(newStartsPos[0], dir),
            point2 = _getIntPoint(newStartsPos[1], dir)
        }
    }

    return GetImpactNormal(intersectionPoints, hitpos)
}