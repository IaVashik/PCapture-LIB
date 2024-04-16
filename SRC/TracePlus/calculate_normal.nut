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
 * Calculates the normal vector of a triangle .
 * 
 * @param {Vector} v1 - The first . 
 * @param {Vector} v2 - The second .
 * @param {Vector} v3 - The third . 
 * @returns {Vector} - The normal vector of the triangle. 
*/
local _calculateNormal = function(v1, v2, v3) {
    // Calculate two edge vectors of the triangle. 
    local edge1 = v2 - v1
    local edge2 = v3 - v1

    // Calculate the normal vector using the cross product of the edge vectors.
    local normal = edge1.Cross(edge2)
    normal.Norm()

    return normal 
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
                        : (GetNewStartsPos, _getIntPoint, _calculateNormal) {
    // Calculate the normalized direction vector from startpos to hitpos
    local dir = hitPos - startPos
    dir.Norm()

    // Get two new start positions for additional traces.
    local newStartsPos = GetNewStartsPos(startPos, dir)
    
    // Perform cheap traces from the new start positions to find intersection points.
    local point1 = _getIntPoint(newStartsPos[0], dir)
    local point2 = _getIntPoint(newStartsPos[1], dir)
    
    return _calculateNormal(hitPos, point2, point1)
}


/*
 * Finds the three closest vertices to a given point from a list of vertices. 
 *
 * @param {Vector} point - The point to find the closest vertices to.
 * @param {array} vertices - An array of Vector objects representing the vertices. 
 * @returns {array} - An array containing the three closest vertices as Vector objects.
*/ 
local _findClosestVertices = function(point, vertices) {
    // Sort the vertices based on their distance to the point.
    vertices.sort(function(a, b):(point) {
        return (a - point).LengthSqr() - (b - point).LengthSqr() 
    })

    // Return the three closest vertices.
    return vertices.slice(0, 3)  
}


/*
 * Calculates the impact normal of a surface hit by a trace using the bounding box of the hit entity.
 *
 * @param {Vector} startPos - The start position of the trace.
 * @param {Vector} hitPos - The hit position of the trace.
 * @param {BboxTraceResult} traceResult - The trace result object.
 * @returns {Vector} - The calculated impact normal vector. 
*/
 ::CalculateImpactNormalFromBbox <- function(startPos, hitPos, hitEntity)
                                    : (_findClosestVertices, _calculateNormal) {
    // Get the entity bounding box vertices.
    local bboxVertices = hitEntity.getBBoxPoints()

    // Calculate the vector from the trace start position to the hit position.
    local traceDir = (hitPos - startPos)
    traceDir.Norm()

    // Find the three closest vertices to the hit position.
    local closestVertices = _findClosestVertices(hitPos - hitEntity.GetOrigin(), bboxVertices)

    // foreach(k, i in closestVertices) { todo dev code
        //     dev.drawbox(hitEntity.GetOrigin() + i, Vector(125,125,0), 0.03)
    // }

    // Calculate the normal vector of the face formed by the three closest vertices.
    local faceNormal = _calculateNormal(closestVertices[0], closestVertices[1], closestVertices[2])

    // Ensure the normal vector points away from the trace direction. // TODO
    if (faceNormal.Dot(traceDir) > 0) {
        faceNormal = faceNormal * -1
    }

    return faceNormal 
}