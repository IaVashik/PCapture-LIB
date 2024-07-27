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
    if(key in table && table[key]) 
        return table[key]
    return defaultValue
}

/* 
 * Gets a list of all keys in a table.
 *
 * @param {table} table - The table to retrieve the keys from.
 * @returns {List} - A list containing all the keys in the table.
*/ 
macros["GetKeys"] <- function(table) {
    local result = List()
    foreach(key, _ in table) {
        result.append(key)
    }
    return result
}

/*
 * Gets a list of all values in a table.
 *
 * @param {table} table - The table to retrieve the values from.
 * @returns {List} - A list containing all the values in the table.
*/ 
macros["GetValues"] <- function(table) {
    local result = List()
    foreach(value in table) {
        result.append(value)
    }
    return result
}

/*
 * Inverts a table, swapping keys and values.
 *
 * @param {table} table - The table to invert.
 * @returns {table} - A new table with keys and values swapped.
*/ 
macros["InvertTable"] <- function(table) {
    local result = {}
    foreach(key, value in table) {
        result[value] = key
    }
    return result
}

/*
 * Prints the keys and values of an iterable object to the console. 
 *
 * @param {iterable} iterable - The iterable object to print.
*/
macros["PrintIter"] <- function(iterable) {
    foreach(k, i in iterable) 
        macros.fprint("{}: {}", k, i)
}

/*
 * Generates a list of numbers within a specified range.
 *
 * @param {number} start - The starting value of the range.
 * @param {number} end - The ending value of the range.
 * @param {number} [step=1] - The increment between each value in the range.
 * @returns {List} - A list of numbers within the specified range.
*/ 
macros["Range"] <- function(start, end, step = 1) {
    local result = List()
    for (local i = start; i <= end; i += step) {
        result.append(i)
    }
    return result
}

/*
 * Generates an iterator that yields numbers within a specified range.
 *
 * @param {number} start - The starting value of the range.
 * @param {number} end - The ending value of the range.
 * @param {number} [step=1] - The increment between each value in the range.
 * @yields {number} - The next number in the range.
*/ 
macros["RangeIter"] <- function(start, end, step = 1) {
    for (local i = start; i <= end; i += step) {
        yield i
    }
    return null
}

/*
 * Prints a formatted message to the console.
 * 
 * @param {string} msg - The message string containing `{}` placeholders.
 * @param {any} vargs... - Additional arguments to substitute into the placeholders.
*/
macros["format"] <- function(msg, ...) {
    // If you are sure of what you are doing, you don't have to use it
    local subst_count = 0;
    for (local i = 0; i < msg.len() - 1; i++) {
        if (msg.slice(i, i+2) == "{}") {
            subst_count++; 
        }
    }

    if (subst_count != vargc)
        throw("Discrepancy between the number of arguments and substitutions")

    local args = array(vargc)
    for(local i = 0; i< vargc; i++) {
        args[i] = vargv[i]
    }

    if (msg.slice(0, 2) == "{}") {
        msg = args[0] + msg.slice(2); 
        args.remove(0); 
    }

    local parts = split(msg, "{}");
    local result = "";

    for (local i = 0; i < parts.len(); i++) {
        result += parts[i];
        if (i < args.len()) {
            local txt = args[i]
            result += txt;
        }
    }

    return result
}

/*
 * Prints a formatted message to the console.
 *
 * This function is similar to dev.format, but it automatically calls printl 
 * with the formatted message. 
 *
 * @param {string} msg - The message string containing `{}` placeholders. 
 * @param {any} vargs... - Additional arguments to substitute into the placeholders. 
*/
macros["fprint"] <- function(msg, ...) {
    local args = array(vargc + 2)
    args[0] = this
    args[1] = msg

    for(local i = 0; i< vargc; i++) {
        args[i + 2] = vargv[i]
    }

    printl(macros.format.acall(args))
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
    local vec = Vector(str_arr[0].tofloat(), str_arr[1].tofloat(), str_arr[2].tofloat())
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
 * Gets the duration of a sound by its name. 
 * 
 * @param {string} soundName - The name of the sound. 
 * @returns {number} - The duration of the sound in seconds.
*/
macros["GetSoundDuration"] <- function(soundName) {
    return self.GetSoundDuration(soundName, "")
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
    if(player.IsPlayer())
        return player.EyePosition() + player.EyeForwardVector() * distance
    
    return player.GetOrigin() + player.GetForwardVector() * distance // haha lmao
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


/*
 * Creates a function that animates a property of one or more entities.
 * 
 * @param {string} name - The name of the animation. This name is used to identify the animation internally. 
 * @param {function} propertySetterFunc - A function that takes an entity and a value, and sets a property on that entity. This function will be called repeatedly during the animation to update the property.
 * @returns {function} - A function that can be used to start the animation. This function takes the following arguments:
 *   * `entities` {array|pcapEntity} - An array of entities or a single entity to animate.
 *   * `startValue` {any} - The starting value for the property.
 *   * `endValue` {any} - The ending value for the property.
 *   * `time` {number} - The duration of the animation in seconds.
 *   * `animSetting` {table} (optional) - A table of additional animation settings. See the `AnimEvent` constructor for details.
*/
macros["BuildAnimateFunction"] <- function(name, propertySetterFunc) {
    return function(entities, startValue, endValue, time, animSetting = {}) : (name, propertySetterFunc) {
        local animSetting = AnimEvent(name, animSetting, entities, time) 
        local varg = {
            start = startValue,
            delta = endValue - startValue,
            lerpFunc = animSetting.lerpFunc
        }

        animate.applyAnimation(
            animSetting,
            function(step, steps, v) {return v.start + v.delta * v.lerpFunc(step / steps)},
            propertySetterFunc
            varg
        ) 

        animSetting.callOutputs() 
        return animSetting.delay
    }
}