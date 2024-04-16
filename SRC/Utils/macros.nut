::macros <- {}

/* 
 * Precaches a sound script or a list of sound scripts for later use.
 * 
 * @param {string|array|arrayLib} sound_path - The path to the sound script or a list of paths.
*/
macros["Precache"] <- function(soundPath) {
    if(typeof soundPath == "string")
        return self.PrecacheSoundScript(soundPath)
    foreach(path in soundPath)
        self.PrecacheSoundScript(path)
}


/* 
 * Gets a value from a table, returning a default value if the key is not found. 
 *
 * @param {table} table - The table to retrieve the value from. 
 * @param {any} key - The key of the value to get. 
 * @param {any} defaultValue - The default value to return if the key is not found. (optional) 
 * @returns {any} - The value associated with the key, or the default value if the key is not found. 
*/ 
macros["GetFromTable"] <- function(table, key, defaultValue = null) {
    if(key in table) 
        return table[key]
    return defaultValue
}

/*
 * Prints the keys and values of an iterable object to the console. 
 *
 * @param {iterable} iterable - The iterable object to print.
*/
macros["PrintIter"] <- function(iterable) {
    foreach(k, i in iterable) 
        dev.fprint("{}: {}", k, i)
}


/* 
 * Calculates the distance between two vectors.
 *
 * @param {Vector} vec1 - The first vector.
 * @param {Vector} vec2 - The second vector.
 * @returns {number} - The distance between the vectors.
*/
macros["GetDist"] <- function(vec1, vec2) {
    return (vec2 - vec1).Length()
}

/* 
 * Converts a string to a Vector object.
 * 
 * @param {string} str - The string representation of the vector, e.g., "x y z".
 * @returns {Vector} - The converted vector.
*/
macros["StrToVec"] <- function(str) {
    local str_arr = split(str, " ")
    local vec = Vector(str_arr[0].tointeger(), str_arr[1].tointeger(), str_arr[2].tointeger())
    return vec
}


/*
 * Converts a Vector object to a string representation.
 * 
 * @param {Vector} vec - The vector to convert. 
 * @returns {string} - The string representation of the vector, e.g., "x y z". 
*/
macros["VecToStr"] <- function(vec) {
    return vec.x + " " + vec.y + " " + vec.z 
}

/*
 * Checks if two values are equal, handling different data types.
 *
 * @param {any} val1 - The first value.
 * @param {any} val2 - The second value.
 * @returns {boolean} - True if the values are equal, false otherwise. 
*/
macros["isEqually"] <- function(val1, val2) {
    switch (typeof val1) {
        case "integer": 
            return val1 == val2 
        case "float": 
            return math.round(val1) == math.round(val2)
        case "Vector": 
            return math.vector.isEqually(val1, val2)
        case "instance": 
            return val1 == val2; 
        case "Quaternion": 
        case "Matrix": 
        case "pcapEntity": 
            return val1.isEqually(val2)  
    }
}

/*
 * Gets the prefix of an entity name. 
 *
 * @param {string} name - The entity name. 
 * @returns {string} - The prefix of the entity name, or the original name if no "-" is found. 
*/
macros["GetPrefix"] <- function(name) {
    local parts = split(name, "-")
    if(parts.len() == 0)
        return name
    
    local lastPartLength = parts.pop().len()
    local prefix = name.slice(0, -lastPartLength)
    return prefix;
}


/* 
 * Gets the postfix of an entity name. 
 *
 * @param {string} name - The entity name. 
 * @returns {string} - The postfix of the entity name, or the original name if no "-" is found. 
*/
macros["GetPostfix"] <- function(name) {
    local parts = split(name, "-")
    if(parts.len() == 0)
        return name

    local lastPartLength = parts[0].len();
    local prefix = name.slice(lastPartLength);
    return prefix;
}

/*
 * Calculates the end position of a ray cast from the player's eyes.
 * 
 * @param {CBaseEntity|pcapEntity} player - The player entity.
 * @param {number} distance - The distance of the ray cast.
 * @returns {Vector} - The end position of the ray cast. 
*/
macros["GetEyeEndpos"] <- function(player, distance) {
    if(typeof player != "pcapEntity") 
        player = entLib.FromEntity(player)

    return player.EyePosition() + player.EyeForwardVector() * distance
}

/*
 * Gets one vertex of the bounding box based on x, y, z bounds.
 * 
 * @param {Vector} x - The x bounds.
 * @param {Vector} y - The y bounds.  
 * @param {Vector} z - The z bounds.
 * @param {Vector} ang - The angle vector.
 * @returns {Vector} - The vertex.
*/
macros["GetVertex"] <- function(x, y, z, ang) {
    return math.vector.rotate(Vector(x.x, y.y, z.z), ang)
}

/*
 * Creates a triangle representation from three vertices. 
 *
 * @param {Vector} v1 - The first vertex of the triangle.
 * @param {Vector} v2 - The second vertex of the triangle.
 * @param {Vector} v3 - The third vertex of the triangle.
 * @returns {table} - A table containing the origin and vertices of the triangle.
*/
macros["GetTriangle"] <- function(v1, v2, v3) {
    return {
        origin = (v1 + v2 + v3) * 0.3333,
        vertices = [v1, v2, v3]
    }
}