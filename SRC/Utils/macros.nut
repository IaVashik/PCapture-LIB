::macros <- {}

/* Precaches a sound script for later use.
* 
* @param {string|array|arrayLib} sound_path - The path to the sound script.
*/
macros["Precache"] <- function(sound_path) {
    if(typeof sound_path == "string")
        return self.PrecacheSoundScript(sound_path)
    foreach(path in sound_path)
        self.PrecacheSoundScript(path)
}


macros["GetFromTable"] <- function(table, key, defaultValue = null) {
    if(key in table) 
        return table[key]
    return defaultValue
}


macros["GetDist"] <- function(vec1, vec2) {
    return (vec2 - vec1).Length()
}

/* Converts a string to a Vector object.
* 
* @param {string} str - The string representation of the vector, e.g., "x y z".
* @returns {Vector} - The converted vector.
*/
macros["StrToVec"] <- function(str) {
    local str_arr = split(str, " ")
    local vec = Vector(str_arr[0].tointeger(), str_arr[1].tointeger(), str_arr[2].tointeger())
    return vec
}

/* Gets the prefix of the entity name.
*
* @returns {string} - The prefix of the entity name.
*/
macros["GetPrefix"] <- function(name) {
    local parts = split(name, "-")
    if(parts.len() == 0)
        return name
    
    local lastPartLength = parts.pop().len()
    local prefix = name.slice(0, -lastPartLength)
    return prefix;
}


/* Gets the postfix of the entity name.
*
* @returns {string} - The postfix of the entity name.
*/
macros["GetPostfix"] <- function(name) {
    local parts = split(name, "-")
    if(parts.len() == 0)
        return name

    local lastPartLength = parts[0].len();
    local prefix = name.slice(lastPartLength);
    return prefix;
}