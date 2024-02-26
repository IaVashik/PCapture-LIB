::CalculateImpactNormal <- class {
    constructor(startpos, hitpos, ignoreEnts = null) {
        // Calculate the normalized direction vector from startpos to hitpos
        local dir = hitpos - startpos
        dir.Norm()

        local newStartsPos = GetNewStartsPos(startpos, dir)
        local intersectionPoints = GetIntersectionPoints(newStartsPos, dir, ignoreEnts)

        return GetImpactNormal(intersectionPoints)
    }

    function GetImpactNormal(intersectionPoints, hitpos) { 
        // Calculate two edge vectors from intersection point to hitpos
        local edge1 = intersectionPoints.point1 - hitpos;
        local edge2 = intersectionPoints.point2 - hitpos;
    
        // Calculate the cross product of the two edges to find the normal vector
        local normal = edge2.Cross(edge1)
        normal.Norm()
    
        return normal
    }


    function GetNewStartsPos(startpos, dir) {
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


    function GetIntersectionPoints(newStartsPos, dir, ignoreEnts) {
        return {
            point1 = _getIntPoint(newStartsPos[0], dir, ignoreEnts),
            point2 = _getIntPoint(newStartsPos[1], dir, ignoreEnts)
        }
    }


    function _getIntPoint(newStart, dir, ignoreEnts) {
        local endPos = newStart + dir * 8000
        
        if(ignoreEnts)
            return TraceLineAnalyzer(newStart, endPos, ignoreEnts).GetHitpos()
        
        return CheapTrace(newStart, endPos).GetHitpos()
    }
}