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
    return TracePlus.Cheap(newStart, (newStart + dir * 8000)).GetHitpos()
}

::CalculateImpactNormal <- function(startpos, hitpos, traceResult) 
                        : (GetNewStartsPos, _getIntPoint) {
    // Calculate the normalized direction vector from startpos to hitpos
    local dir = hitpos - startpos
    dir.Norm()

    local newStartsPos = GetNewStartsPos(startpos, dir)
    local intersectionPoints = {
        point1 = _getIntPoint(newStartsPos[0], dir),
        point2 = _getIntPoint(newStartsPos[1], dir)
    }

    // Calculate two edge vectors from intersection point to hitpos
    local edge1 = intersectionPoints.point1 - hitpos;
    local edge2 = intersectionPoints.point2 - hitpos;

    // Calculate the cross product of the two edges to find the normal vector
    local normal = edge2.Cross(edge1)
    normal.Norm()

    return normal
}