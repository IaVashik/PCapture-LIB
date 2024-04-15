/*
 * Calculates two new start positions for additional traces used in impact normal calculation. 
 * 
 * @param {Vector} startPos - The original start position of the trace. 
 * @param {Vector} dir - The direction vector of the trace. 
 * @returns {array} - An array containing two new start positions as Vectors. 
*/
 local GetNewStartsPos = function(startPos, dir) {
    // Calculate offset vectors perpendicular to the trace direction
    local perpDir = Vector(-dir.y, dir.x, 0)
    local offset1 = perpDir
    local offset2 = dir.Cross(offset1)

    // Calculate new start positions for two additional traces
    local newStart1 = startPos + offset1
    local newStart2 = startPos + offset2

    return [
        newStart1, 
        newStart2
    ]
}

/*
 * Performs a cheap trace from a new start position to find an intersection point.
 *
 * @param {Vector} newStart - The new start position for the trace. 
 * @param {Vector} dir - The direction vector of the trace. 
 * @returns {Vector} - The hit position of the trace.
*/
local _getIntPoint = function(newStart, dir) {    
    return TracePlus.Cheap(newStart, (newStart + dir * 8000)).GetHitpos()
}

/* 
 * Calculates the impact normal of a surface hit by a trace. 
 *
 * @param {Vector} startPos - The start position of the trace.
 * @param {Vector} hitPos - The hit position of the trace.
 * @param {TraceResult} traceResult - The trace result object.
 * @returns {Vector} - The calculated impact normal vector. 
*/
::CalculateImpactNormal <- function(startPos, hitPos, traceResult) 
                        : (GetNewStartsPos, _getIntPoint) {
    // Calculate the normalized direction vector from startpos to hitpos
    local dir = hitPos - startPos
    dir.Norm()

    // Get two new start positions for additional traces.
    local newStartsPos = GetNewStartsPos(startPos, dir)
    
    // Perform cheap traces from the new start positions to find intersection points.
    local intersectionPoints = {
        point1 = _getIntPoint(newStartsPos[0], dir),
        point2 = _getIntPoint(newStartsPos[1], dir)
    }

    // Calculate two edge vectors from intersection point to hitpos
    local edge1 = intersectionPoints.point1 - hitPos;
    local edge2 = intersectionPoints.point2 - hitPos;

    // Calculate the cross product of the two edges to find the normal vector
    local normal = edge2.Cross(edge1)
    normal.Norm()

    return normal
}