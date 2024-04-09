math["vector"] <- {}
local vector = math["vector"]

vector["isEqually"] <- function(vector, other) {
    vector = math.vector.round(vector)
    other = math.vector.round(other)
    return vector.x == other.x && 
            vector.y == other.y && 
            vector.z == other.z
}

vector["rotate"] <- function(vector, angle) {
    return math.Quaternion.fromEuler(angle).rotateVector(vector)
}

vector["unrotate"] <- function(vector, angle) {
    return math.Quaternion.fromEuler(angle).unrotateVector(vector)
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
    local tx = vector.Length()
    return vector * (element / tx)
}

/* Rounds the elements of a vector to the specified precision.
*
* @param {Vector} vec - The vector to round.
* @param {int} int - The precision (e.g., 1000 for rounding to three decimal places).
* @returns {Vector} - The rounded vector.
*/
vector["round"] <- function(vec, int = 1000) {
    vec.x = floor(vec.x * int + 0.5) / int
    vec.y = floor(vec.y * int + 0.5) / int
    vec.z = floor(vec.z * int + 0.5) / int
    return vec
}