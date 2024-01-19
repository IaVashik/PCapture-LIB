/*
* Get the surface normal at the impact point.
*
* @returns {Vector} Surface normal. 
*/
function bboxcast::GetImpactNormal() { 
    // If the surface normal is already calculated, return it
    if(surfaceNormal)
        return surfaceNormal

    local intersectionPoint = this.hitpos

    // Calculate the normalized direction vector from startpos to hitpos
    local dir = (this.hitpos - this.startpos)
    dir.Norm()

    // Calculate offset vectors perpendicular to the trace direction
    local perpDir = Vector(-dir.y, dir.x, 0)
    local offset1 = perpDir
    local offset2 = dir.Cross(offset1)

    // Calculate new start positions for two additional traces
    local newStart1 = this.startpos + offset1
    local newStart2 = this.startpos + offset2

    // Perform two additional traces to find intersection points
    local intersectionPoint1
    local intersectionPoint2
    if(this.GetEntity()) { // TODO
        local normalSetting = {
            ignoreClass = ["*"],
            priorityClass = [this.GetEntity().GetClassname()],
            ErrorCoefficient = 3000,
        }
        intersectionPoint1 = this.Trace(newStart1, newStart1 + dir * 8000, this.ignoreEnts).hit
        intersectionPoint2 = this.Trace(newStart1, newStart2 + dir * 8000, this.ignoreEnts).hit
    }
    else {
        intersectionPoint1 = this.CheapTrace(newStart1, newStart1 + dir * 8000)
        intersectionPoint2 = this.CheapTrace(newStart2, newStart2 + dir * 8000)
    }

    // Calculate two edge vectors from intersection point to hitpos
    local edge1 = intersectionPoint1 - intersectionPoint;
    local edge2 = intersectionPoint2 - intersectionPoint;

    // Calculate the cross product of the two edges to find the normal vector
    local normal = edge2.Cross(edge1)
    normal.Norm()

    this.surfaceNormal = normal

    return this.surfaceNormal
}