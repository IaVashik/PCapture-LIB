math["vector"] <- {}
local vector = math["vector"]

vector["rotate"] <- function(vector, angle) {
    return math.Quaternion.new(angle).rotate(vector)
}

vector["unrotate"] <- function(vector, angle) {
    return math.Quaternion.new(angle).unrotate(vector)
}

vector["random"] <- function(min, max) {
    if(typeof min == "Vector" && typeof max == "Vector") 
        return Vector(RandomFloat(min.x, max.x), RandomFloat(min.y, max.y), RandomFloat(min.z, max.z))
    return Vector(RandomFloat(min, max), RandomFloat(min, max), RandomFloat(min, max))
}

vector["reflect"] <- function(dir, normal) {
    return dir - normal * (dir.Dot(normal) * 2)
}

vector["clamp"] <- function(vector, min = 0, max = 255) { // todo
    return Vector(this.clamp(vector.x, min, max), this.clamp(vector.y, min, max), this.clamp(vector.z, min, max)) 
}

vector["resize"] <- function(vector, element) {
    local tx = sqrt((vector.x * vector.x) + (vector.y * vector.y) + (vector.z * vector.z)) // todo lenght?
    return vector * (element / tx)
}