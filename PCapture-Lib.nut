/*+--------------------------------------------------------------------------------+
|                           PCapture Vscripts Library                               |
 +---------------------------------------------------------------------------------+
| Author:                                                                           |
|     One-of-a-Kind - laVashik                                                      |
 +---------------------------------------------------------------------------------+
| pcapture-lib.nut                                                                  |
|       The main file in the library. initializes required parts of the library     |
|    GitHud repo: https://github.com/IaVashik/PCapture-LIB                          |
+----------------------------------------------------------------------------------+ */

::LibDebugInfo <- false
::VSEventLogs <- false

local version = "PCapture-Lib 2.4 Stable"

// `Self` must be in any case, even if the script is run directly by the interpreter
if (!("self" in this)) {
    self <- Entities.FindByClassname(null, "worldspawn")
} else {
    getroottable()["self"] <- self
}

if("_lib_version_" in getroottable() && version.find("Debug") == null) {
    printl("\n")
    dev.warning("PCapture-Lib already initialized.")
    if(_lib_version_ != version) {
        dev.error("Attempting to initialize different versions of the PCapture-Lib library!")
        dev.fprint("Version \"{}\" != \"{}\"", _lib_version_, version)
    }
    return
}


/*+--------------------------------------------------------------------------------+
|                           PCapture Vscripts Library                              |
+----------------------------------------------------------------------------------+
| Author:                                                                          |
|     Squirrel Whisperer - laVashik :>                                             |
+----------------------------------------------------------------------------------+
|       A toolbox of versatile utilities for script execution, debugging, file     |
|       operations, and entity manipulation, empowering VScripts developers.       | 
+----------------------------------------------------------------------------------+ */ 

/*
 * Prints information about the calling function, including the function name, source file, and line number.
 *
 * @param {string} pattern - The format string for the message. 
 * @param {string} msg - The message to print. 
*/ 
 ::_printInfo <- function(pattern, msg) {
    if (developer() == 0)
        return

    local last_info
    for(local i = 0; getstackinfos(i); i++){
        last_info = i 
    }

    local info = getstackinfos(last_info)
    
    local funcName = getstackinfos(last_info).func
    if (funcName == "main" || funcName == "unknown")
        funcName = "file " + info.src
        
    local line = info.line 
    dev.fprint(pattern, funcName, line, msg)
}

/*
 * A collection of debugging utilities. 
*/
::dev <- {
    /*
     * Draws the bounding box of an entity for the specified time.
     * 
     * @param {CBaseEntity|pcapEntity} ent - The entity to draw the bounding box for.
     * @param {number} time - The duration of the display in seconds. 
    */
    DrawEntityBBox = function(ent, time) {
        DebugDrawBox(ent.GetOrigin(), ent.GetBoundingMins(), ent.GetBoundingMaxs(), 255, 165, 0, 9, time)
    },

    /*
     * Draws a box at the specified vector position for the specified time.
     * 
     * @param {Vector} vector - The position of the box.
     * @param {Vector} color - The color of the box.
     * @param {number} time - The duration of the display in seconds. (optional)
    */
    drawbox = function(vector, color, time = 0.05) {
        DebugDrawBox(vector, Vector(-1,-1,-1), Vector(1,1,1), color.x, color.y, color.z, 100, time)
    },


    /*
     * Logs a debug message to the console if debug logging is enabled. 
     *
     * @param {string} msg - The message to log. 
    */ 
    debug = function(msg) {
        if (LibDebugInfo)
            printl("~ " + msg)
    },


    /*
     * Logs a message to the console only if developer mode is enabled.
     * 
     * @param {string} msg - The message to log. 
    */
    log = function(msg) {
        if (developer() != 0)
            printl("• " + msg)
    },

    /*
     * Displays a warning message in a specific format.
     * 
     * @param {string} msg - The warning message. 
    */
    warning = function(msg) {
        cwar.append(msg)
        _printInfo("► Warning ({} [{}]): {}", msg)
    },

    /* 
     * Displays an error message in a specific format.
     * 
     * @param {string} msg - The error message. 
    */
    error = function(msg) {
        cerr.append(msg)
        _printInfo("▄▀ *ERROR*: [func = {}; line = {}] | {}", msg)
        SendToConsole("playvol resource/warning.wav 1")
    },


    /*
     * Prints a formatted message to the console.
     * 
     * @param {string} msg - The message string containing `{}` placeholders.
     * @param {any} vargs... - Additional arguments to substitute into the placeholders.
    */
    format = function(msg, ...) {

        // If you are sure of what you are doing, you don't have to use it
        local subst_count = 0;
        for (local i = 0; i < msg.len() - 1; i++) {
            if (msg.slice(i, i+2) == "{}") {
                subst_count++; 
            }
        }

        if (subst_count != vargc) {
            throw("Discrepancy between the number of arguments and substitutions")
        }


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
                try{
                    txt = txt.tostring()
                } catch(_) {}

                result += txt;
            }
        }

        return result
    },

    /*
     * Prints a formatted message to the console.
     *
     * This function is similar to dev.format, but it automatically calls printl 
     * with the formatted message. 
     *
     * @param {string} msg - The message string containing `{}` placeholders. 
     * @param {any} vargs... - Additional arguments to substitute into the placeholders. 
    */
    fprint = function(msg, ...) {
        local args = array(vargc + 2)
        args[0] = this
        args[1] = msg

        for(local i = 0; i< vargc; i++) {
            args[i + 2] = vargv[i]
        }

        printl(this.format.acall(args))
    }
}
/*
 * Represents a file for reading and writing.
*/
 ::File <- class {
    // The path to the file.  
    path = null;
    // The name of the file without the extension. 
    name = null;

    /*
     * Constructor for a File object.
     *
     * @param {string} path - The path to the file.
    */
    constructor(path) {
        path = split(path, "/").top() 
        this.name = path

        if(path.find(".log") == null) {
            path += ".log"
        } else {
            this.name = this.name.slice(0, -4)
        }
        
        this.path = path
        this._recreateCache()
    }

    /*
     * Appends text to the file.
     *
     * @param {string} text - The text to append. 
    */
    function write(text) {
        local cmd = "script " + name + ".append(\\\"" + text + "\\\");"
        this._write(cmd)
    }

    /*
     * Writes a command to the console to manipulate the file.
     *
     * @param {string} command - The command to execute. 
    */
    function _write(command) {
        SendToConsole("con_logfile cfg/" + this.path)
        SendToConsole("script printl(\"" + command + "\")")
        SendToConsole("con_logfile off")
    }

    /* 
     * Reads the lines of the file and returns them as an array.
     *
     * @returns {array} - An array of strings, where each string is a line from the file. 
    */
    function readlines() {
        this._recreateCache()
        this.updateInfo()

        if(this.name in getroottable()) 
            return getroottable()[this.name]
        return []
    }

    /* 
     * Reads the entire contents of the file and returns it as a string.
     * 
     * @returns {string} - The contents of the file as a string. 
    */
    function read() {
        local result = ""
        foreach(line in this.readlines()){
            result += line + "\n"
        }
        return result
    }

    /*
     * Recreates the cache array for the file if it doesn't exist.
    */
    function _recreateCache() {
        if(this.name in getroottable()) 
            return
        SendToConsole("script ::" + this.name + " <- []")
    }

    /*
     * Clears the contents of the file. 
    */
    function clear() {
        this._recreateCache()
        this._write("script " + name + ".clear()")
    }

    /*
     * Updates information about the file by executing it. 
    */
    function updateInfo() {
        SendToConsole("exec " + path)
    }
}
if("GetPlayerEx" in getroottable()) {
    return
}

/*
* Limits frametime to avoid zero values.
*
* @returns {number} Clamped frametime
*/
::_frametime <- FrameTime
/*
 * Returns the current frame time, ensuring it is never zero. 
 * 
 * This function overrides the standard FrameTime function to prevent issues that can arise from zero frame times. 
 * If the frame time is zero, it returns a small default value (0.016). 
 *
 * @returns {number} - The current frame time. 
*/
::FrameTime <- function() {
    local tick = _frametime()
    if(tick == 0)
        return 0.016
    return tick
}

::_uniquestring <- UniqueString
/*
 * Generates a unique string with the specified prefix. 
 * 
 * This function overrides the standard UniqueString function to include a prefix in the generated string. 
 *
 * @param {string} prefix - The prefix to use for the unique string. (optional, default="u") 
 * @returns {string} - The generated unique string. 
*/ 
::UniqueString <- function(prefix = "u") {
    return prefix + "_" + _uniquestring().slice(0, -1)
}

::_EntFireByHandle <- EntFireByHandle
/*
 * Wrapper for EntFireByHandle to handle PCapLib objects.
 *
 * This function overrides the standard EntFireByHandle function to handle pcapEntity objects and extract the underlying CBaseEntity objects. 
 * It also allows specifying an activator and caller entity. 
 *
 * @param {CBaseEntity|pcapEntity} target - The target entity to trigger the input on. 
 * @param {string} action - The name of the input to trigger. 
 * @param {string} value - The value to pass to the input. (optional)
 * @param {number} delay - The delay in seconds before triggering the input. (optional)
 * @param {CBaseEntity|pcapEntity} activator - The activator entity (the entity that triggered the input). (optional)
 * @param {CBaseEntity|pcapEntity} caller - The caller entity (the entity that called the function). (optional) 
*/
::EntFireByHandle <- function(target, action, value = "", delay = 0, activator = null, caller = null, eventName = null) {
    // Extract the underlying entity from the pcapEntity wrapper 
    if (typeof target == "pcapEntity") // todo create macros for this!
        target = target.CBaseEntity
    if (typeof activator == "pcapEntity")
        activator = activator.CBaseEntity
    if (typeof caller == "pcapEntity")
        caller = target.CBaseEntity

    if(!eventName) 
        return _EntFireByHandle(target, action, value, delay, activator, caller)
    ScheduleEvent.Add(eventName, _EntFireByHandle, delay, [target, action, value, 0, activator, caller])
}

::EntFireEx <- function(target, action, value = "", delay = 0, activator = null, eventName = null) {
    if(!eventName)
        return EntFire(target, action, value, delay, activator)
    ScheduleEvent.Add(eventName, EntFire, delay, [target, action, value, 0, activator])
}

::AllPlayers <- []

/*
* Retrieves a player entity with extended functionality.
*
* @param {int} index - The index of the player (0-based).
* @returns {pcapEntity} - An extended player entity with additional methods.
*/
::GetPlayerEx <- function(index = 0) {
    if(IsMultiplayer()) {
        if(index >= AllPlayers.len()) return
        return AllPlayers[index]
    }

    return entLib.FromEntity(GetPlayer())
}

/* 
 * Gets an array of all players in the game. 
 *
 * @returns {array} - An array of pcapEntity objects representing the players. 
*/
::GetPlayers <- function() { // -> array
    return AllPlayers
}


/* 
 * Attaches eye control entities to all players in the game. 
 *
 * This function creates logic_measure_movement and info_target entities for each player to track their eye position and angles. 
 * It is called automatically at the initialization of the library and periodically in multiplayer games. 
*/
::AttachEyeControlToPlayers <- function() {
    for(local player; player = entLib.FindByClassname("player", player);) {
        if(player.GetUserData("Eye")) continue

        local controlName = UniqueString("eyeControl")
        local eyeControlEntity = entLib.CreateByClassname("logic_measure_movement", {
            targetname = controlName, measuretype = 1}
        )

        local eyeName = UniqueString("eyePoint")
        local eyePointEntity = entLib.CreateByClassname("info_target", {targetname = eyeName})

        local playerName = player.GetName() == "" ? "!player" : player.GetName()

        EntFireByHandle(eyeControlEntity, "setmeasuretarget", playerName)
        EntFireByHandle(eyeControlEntity, "setmeasurereference", controlName);
        EntFireByHandle(eyeControlEntity, "SetTargetReference", controlName);
        EntFireByHandle(eyeControlEntity, "Settarget", eyeName);
        EntFireByHandle(eyeControlEntity, "Enable")

        player.SetUserData("Eye", eyePointEntity)
        AllPlayers.append(player)
    }
}
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

macros["BuildAnimateFunction"] <- function(name, propertySetterFunc) {
    return function(entities, startValue, endValue, time, animSetting = {}) : (name, propertySetterFunc) {
        local animSetting = AnimEvent(name, animSetting, entities, time) 
        local varg = {
            start = startPitch,
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
    }
}
::RunScriptCode <- {
    /* 
     * Creates a delay before executing the specified script.
     * 
     * @param {string|function} script - The script to execute. Can be a function or a string.
     * @param {number} runDelay - The delay in seconds.
     * @param {array|null} args - Optional arguments to pass to the script function. 
     * @param {entity|object} activator - The activator entity. (optional)
     * @param {CBaseEntity|pcapEntity} caller - The caller entity. (optional)
    */
    delay = function(script, runDelay, args = null, activator = null, caller = null) { 
        if (typeof script == "function")
            return ScheduleEvent.Add("global", script, runDelay, args, caller)

        EntFireByHandle(self, "runscriptcode", script, runDelay, activator, caller)
    },  

    /* 
     * Executes a function repeatedly with a specified delay for a given number of loops.
     * 
     * @param {string|function} func - The function to execute.
     * @param {number} runDelay - The delay between each execution in seconds.
     * @param {number} loopCount - The number of loops.
     * @param {string} outputs - The function to execute after all loops completed. (optional)
    */
    loopy = function(script, runDelay, loopCount, outputs = null) {
        if (loopCount > 0) {
            RunScriptCode.delay(script, runDelay)
            RunScriptCode.delay(RunScriptCode.loopy, runDelay, null, [script, runDelay, --loopCount, outputs], null)
        } else if (outputs)
            RunScriptCode.delay(outputs, 0)
    },

    /* 
     * Schedules the execution of a script recursively at a fixed interval.
     *
     * This function schedules the provided script to run repeatedly at a specified interval. After each execution,
     * the function schedules itself to run again, creating a loop that continues until you cancel the event
     *
     * @param {string|function} script - The script to be executed. Can be a function or a string containing code.
     * @param {number} interval - The time interval between consecutive executions in seconds. (optional, default=tick) 
     * @param {number} runDelay - The initial delay before the first execution in seconds. (optional, default=0) 
     * @param {string} eventName - The name of the event used for scheduling. (optional, default="global")
    */
    setInterval = function(script, interval  = FrameTime(), runDelay = 0, eventName = "global") {
        ScheduleEvent.AddInterval(eventName, script, interval, runDelay)
    },

    /* 
     * Execute a script from a string.
     * 
     * @param {string} str - The script string.
    */
    fromStr = function(str) {
        compilestring(str)()
    }
}
// Collides with everything.
const COLLISION_GROUP_NONE = 0

// Small objects, doesn't interfere with gameplay.
const COLLISION_GROUP_DEBRIS = 1

// Like DEBRIS, but ignores PUSHAWAY.
const COLLISION_GROUP_DEBRIS_TRIGGER = 2 

// Like DEBRIS, but doesn't collide with same group.
const COLLISION_GROUP_INTERACTIVE_DEBRIS = 3

// Interactive entities, ignores debris.
const COLLISION_GROUP_INTERACTIVE = 4

// Used by players, ignores PASSABLE_DOOR.
const COLLISION_GROUP_PLAYER = 5

// Breakable glass, ignores same group and NPC line-of-sight.
const COLLISION_GROUP_BREAKABLE_GLASS = 6

// Driveable vehicles, always collides with VEHICLE_CLIP.
const COLLISION_GROUP_VEHICLE = 7

// Player movement collision.
const COLLISION_GROUP_PLAYER_MOVEMENT = 8

// Used by NPCs, always collides with DOOR_BLOCKER.
const COLLISION_GROUP_NPC = 9

// Entities inside vehicles, no collisions. 
const COLLISION_GROUP_IN_VEHICLE = 10 

// Weapons, including dropped ones. 
const COLLISION_GROUP_WEAPON = 11 

// Only collides with VEHICLE.
const COLLISION_GROUP_VEHICLE_CLIP = 12

// Projectiles, ignore other projectiles.
const COLLISION_GROUP_PROJECTILE = 13

// Blocks NPCs, may collide with some projectiles.
const COLLISION_GROUP_DOOR_BLOCKER = 14

// Passable doors, allows players through.
const COLLISION_GROUP_PASSABLE_DOOR = 15 

// Dissolved entities, only collide with NONE.
const COLLISION_GROUP_DISSOLVING = 16

// Pushes props away from the player.
const COLLISION_GROUP_PUSHAWAY = 17

// NPCs potentially stuck in a player.
const COLLISION_GROUP_NPC_ACTOR = 18

// NPCs in scripted sequences with collisions disabled. 
const COLLISION_GROUP_NPC_SCRIPTED = 19



// No collision at all.
const SOLID_NONE = 0 

// Uses Quake Physics engine.
const SOLID_BSP = 1 

// Uses an axis-aligned bounding box (AABB).
const SOLID_VPHYSICS = 2

// Uses an oriented bounding box (OBB).
const SOLID_OBB = 3 

// Uses an OBB constrained to yaw rotation.
const SOLID_OBB_YAW = 4 

// Custom/test solid type.
const SOLID_CUSTOM = 5 

// Uses VPhysics engine for realistic physics. 
const SOLID_VPHYSICS = 6 

/*+--------------------------------------------------------------------------------+
|                           PCapture Vscripts Library                              |
+----------------------------------------------------------------------------------+
| Author:                                                                          |
|     Visionary Mathematician - laVashik :O                                        |
+----------------------------------------------------------------------------------+
|    The core mathematical module, providing essential functions and objects for   |
|    performing calculations, transformations, and interpolations in VScripts.     |
+----------------------------------------------------------------------------------+ */

::math <- {}

/*
 * Finds the minimum value among the given arguments.
 *
 * @param {...number} vargv - The numbers to compare.
 * @returns {number} - The minimum value.
*/
math["min"] <- function(...) {
    local min = vargv[0]
    for(local i = 0; i< vargc; i++) {
        if(min > vargv[i])
            min = vargv[i]
    }
    
    return min
}


/*
 * Finds the maximum value among the given arguments.
 *
 * @param {...number} vargv - The numbers to compare.
 * @returns {number} - The maximum value.
*/
math["max"] <- function(...) {
    local max = vargv[0]
    for(local i = 0; i< vargc; i++) {
        if(vargv[i] > max)
            max = vargv[i]
    }

    return max
}


/*
 * Clamps a number within the specified range.
 *
 * @param {number} number - The number to clamp.
 * @param {number} min - The minimum value.
 * @param {number} max - The maximum value (optional).
 * @returns {number} - The clamped value.
*/
math["clamp"] <- function(number, min, max = 99999) { 
    if ( number < min ) return min;
    if ( number > max ) return max;
    return number
}


/*
 * Rounds a number to the specified precision.
 *
 * @param {number} value - The number to round.
 * @param {int} precision - The precision (e.g., 1000 for rounding to three decimal places).
 * @returns {number} - The rounded value.
*/
math["round"] <- function(value, precision = 1000) {
    return floor(value * precision + 0.5) / precision
}


/*
 * Returns the sign of a number.
 *
 * @param {number} x - The number.
 * @returns {number} - The sign of the number (-1, 0, or 1).
*/
math["Sign"] <- function(x) {
    if (x > 0) {
        return 1;
    } else if (x < 0) {
        return -1;
    } else {
        return 0;
    }
}


/*
 * Copies the sign of one value to another.
 *
 * @param {number} value - The value to copy the sign to.
 * @param {number} sign - The sign to copy.
 * @returns {number} - The value with the copied sign.
*/
math["copysign"] <- function(value, sign) {
    if (sign < 0 || value < 0) {
        return -value;
    }
    return value
}


/*
 * Remaps a value from the range [A, B] to the range [C, D].
 *
 * If A is equal to B, the value will be clamped to C or D depending on its relationship to B.
 *
 * @param {number} value - The value to remap.
 * @param {number} A - The start of the input range.
 * @param {number} B - The end of the input range.
 * @param {number} C - The start of the output range.
 * @param {number} D - The end of the output range.
 * @returns {number} - The remapped value.
*/
math["RemapVal"] <- function( value, A, B, C, D )
{
    if ( A == B )
    {
        if ( value >= B )
            return D;
        return C;
    };
    return C + (D - C) * (value - A) / (B - A);
}   
math["vector"] <- {}
local vector = math["vector"]

/*
 * Checks if two vectors are equal based on their rounded components.
 *
 * @param {Vector} vector - The first vector.
 * @param {Vector} other - The second vector.
 * @returns {boolean} - True if the vectors are equal, false otherwise.
*/
vector["isEqually"] <- function(vector, other) {
    vector = math.vector.round(vector)
    other = math.vector.round(other)
    return vector.x == other.x && 
            vector.y == other.y && 
            vector.z == other.z
}


/*
 * Performs element-wise multiplication of two vectors.
 *
 * @param {Vector} vector - The first vector.
 * @param {Vector} other - The second vector.
 * @returns {Vector} - A new vector with the result of the element-wise multiplication.
*/
vector["mul"] <- function(vector, other) {
    return Vector(vector.x * other.x, vector.y * other.y, vector.z * other.z)
}

/*
 * Rotates a vector by a given angle.
 *
 * @param {Vector} vector - The vector to rotate.
 * @param {Vector} angle - The Euler angles in degrees (pitch, yaw, roll) representing the rotation.
 * @returns {Vector} - The rotated vector. 
*/
vector["rotate"] <- function(vector, angle) {
    return math.Quaternion.fromEuler(angle).rotateVector(vector)
}

/*
 * Un-rotates a vector by a given angle.
 *
 * @param {Vector} vector - The vector to un-rotate.
 * @param {Vector} angle - The Euler angles in degrees (pitch, yaw, roll) representing the rotation to reverse.
 * @returns {Vector} - The un-rotated vector.
*/
vector["unrotate"] <- function(vector, angle) {
    return math.Quaternion.fromEuler(angle).unrotateVector(vector)
}

/*
 * Generates a random vector within the specified range.
 *
 * If `min` and `max` are both vectors, each component of the resulting vector will be a random value between the corresponding components of `min` and `max`.
 * If `min` and `max` are numbers, all components of the resulting vector will be random values between `min` and `max`.
 *
 * @param {Vector|number} min - The minimum values for each component or a single minimum value for all components.
 * @param {Vector|number} max - The maximum values for each component or a single maximum value for all components.
 * @returns {Vector} - The generated random vector.
*/
vector["random"] <- function(min, max) {
    if(typeof min == "Vector" && typeof max == "Vector") 
        return Vector(RandomFloat(min.x, max.x), RandomFloat(min.y, max.y), RandomFloat(min.z, max.z))
    return Vector(RandomFloat(min, max), RandomFloat(min, max), RandomFloat(min, max))
}

/*
 * Reflects a direction vector off a surface with a given normal.
 *
 * @param {Vector} dir - The direction vector to reflect.
 * @param {Vector} normal - The normal vector of the surface.
 * @returns {Vector} - The reflected direction vector.
*/
vector["reflect"] <- function(dir, normal) {
    return dir - normal * (dir.Dot(normal) * 2)
}

/*
 * Clamps the components of a vector within the specified range.
 *
 * @param {Vector} vector - The vector to clamp.
 * @param {number} min - The minimum value for each component.
 * @param {number} max - The maximum value for each component.
 * @returns {Vector} - The clamped vector.
*/
vector["clamp"] <- function(vector, min = 0, max = 255) {
    return Vector(math.clamp(vector.x, min, max), math.clamp(vector.y, min, max), math.clamp(vector.z, min, max)) 
}

/*
 * Resizes a vector to a new length while maintaining its direction.
 *
 * @param {Vector} vector - The vector to resize.
 * @param {number} newLength - The desired new length of the vector.
 * @returns {Vector} - The resized vector with the specified length.
*/
vector["resize"] <- function(vector, newLength) {
    local currentLength = vector.Length()
    return vector * (newLength / currentLength)
}

/*
 * Rounds the elements of a vector to the specified precision.
 *
 * @param {Vector} vec - The vector to round.
 * @param {int} precision - The precision (e.g., 1000 for rounding to three decimal places).
 * @returns {Vector} - The rounded vector.
*/
vector["round"] <- function(vec, precision = 1000) {
    vec.x = floor(vec.x * precision + 0.5) / precision
    vec.y = floor(vec.y * precision + 0.5) / precision
    vec.z = floor(vec.z * precision + 0.5) / precision
    return vec
}

/* 
 * Returns a vector with the signs (-1, 0, or 1) of each component of the input vector.
 * 
 * @param {Vector} vec - The input vector.
 * @returns {Vector} - A new vector with the signs of the input vector's components.
*/
vector["sign"] <- function(vec) {
    return Vector(math.Sign(vec.x), math.Sign(vec.y), math.Sign(vec.z))
}

/* 
 * Calculates the absolute value of each component in a vector.
 *
 * @param {Vector} vector - The vector to calculate the absolute values for.
 * @returns {Vector} - A new vector with the absolute values of the original vector's components.
*/
vector["abs"] <- function(vector) {
    return Vector(::abs(vector.x), ::abs(vector.y), ::abs(vector.z)) 
}

math["lerp"] <- {}
local lerp = math["lerp"]


/*
 * Performs linear interpolation (lerp) between start and end based on the parameter t.
 *
 * @param {number} start - The starting value.
 * @param {number} end - The ending value.
 * @param {number} t - The interpolation parameter.
 * @returns {number} - The interpolated value.
*/
lerp["number"] <- function(start, end, t) {
    return start * (1 - t) + end * t;
}


/*
 * Performs linear interpolation (lerp) between two vectors.
 *
 * @param {Vector} start - The starting vector.
 * @param {Vector} end - The ending vector.
 * @param {number} t - The interpolation parameter.
 * @returns {Vector} - The interpolated vector.
*/
lerp["vector"] <- function(start, end, t) {
    return Vector(this.number(start.x, end.x, t), this.number(start.y, end.y, t), this.number(start.z, end.z, t));
}


/*
 * Performs linear interpolation (lerp) between two colors.
 *
 * @param {Vector|string} start - The starting color vector or string representation (e.g., "255 0 0").
 * @param {Vector|string} end - The ending color vector or string representation.
 * @param {number} t - The interpolation parameter.
 * @returns {string} - The interpolated color string representation (e.g., "128 64 0").
*/
lerp["color"] <- function(start, end, t) {
    if (type(start) == "string") {
        start = macros.StrToVec(start)
    }
    if (type(end) == "string") {
        end = macros.StrToVec(end)
    }

    return floor(this.number(start.x, end.x, t)) + " " + floor(this.number(start.y, end.y, t)) + " " + floor(this.number(start.z, end.z, t))
}

// SLERP for vector 
lerp["sVector"] <- function(start, end, t) {
    local q1 = math.Quaternion.fromEuler(start)
    local q2 = math.Quaternion.fromEuler(end)
    return q1.slerp(q2, t).toVector()
}

/*
 * Performs smooth interpolation between two values using a smoothstep function.
 *
 * @param {number} edge0 - The lower edge of the interpolation range.
 * @param {number} edge1 - The upper edge of the interpolation range.
 * @param {number} value - The interpolation parameter.
 * @returns {number} - The interpolated value.
*/
lerp["SmoothStep"] <- function(edge0, edge1, value) {
    local t = math.clamp((value - edge0) / (edge1 - edge0), 0.0, 1.0);
    return t * t * (3.0 - 2.0 * t)
}


/*
 * Performs linear interpolation between two values.
 *
 * @param {number} f1 - The start value.
 * @param {number} f2 - The end value.
 * @param {number} i1 - The start interpolation parameter.
 * @param {number} i2 - The end interpolation parameter.
 * @param {number} value - The interpolation parameter.
 * @returns {number} - The interpolated value.
*/
lerp["FLerp"] <- function( f1, f2, i1, i2, value ) {
    return f1 + (f2 - f1) * (value - i1) / (i2 - i1);
}


// More info here: https://gizma.com/easing/

lerp["InSine"] <- function(t) { 
    return 1 - cos((t * PI) / 2);
}

lerp["OutSine"] <- function(t) { 
    return sin((t * PI) / 2);
}

lerp["InOutSine"] <- function(t) { 
    return -(cos(PI * t) - 1) / 2;
}

lerp["InQuad"] <- function(t) { 
    return t * t; 
}

lerp["OutQuad"] <- function(t) { 
    return 1 - (1 - t) * (1 - t); 
}

lerp["InOutQuad"] <- function(t) { 
    return t < 0.5 ? 2 * t * t : 1 - pow(-2 * t + 2, 2) / 2;
}

lerp["InCubic"] <- function(t) { 
    return t * t * t;
}

lerp["OutCubic"] <- function(t) { 
    return 1 - pow(1 - t, 3);
}

lerp["InOutCubic"] <- function(t) { 
    return t < 0.5 ? 4 * t * t * t : 1 - pow(-2 * t + 2, 3) / 2;
}

lerp["InQuart"] <- function(t) {
    return t * t * t * t; 
}

lerp["OutQuart"] <- function(t) { 
    return 1 - pow(1 - t, 4);
}

lerp["InOutQuart"] <- function(t) { 
    return t < 0.5 ? 8 * t * t * t * t : 1 - pow(-2 * t + 2, 4) / 2;
}

lerp["InQuint"] <- function(t) { 
    return t * t * t * t * t;
}

lerp["OutQuint"] <- function(t) { 
    return 1 - pow(1 - t, 5);
}

lerp["InOutQuint"] <- function(t) { 
    return t < 0.5 ? 16 * t * t * t * t * t : 1 - pow(-2 * t + 2, 5) / 2;
}

lerp["InExpo"] <- function(t) { 
    return t == 0 ? 0 : pow(2, 10 * t - 10);
}

lerp["OutExpo"] <- function(t) { 
    return t == 1 ? 1 : 1 - pow(2, -10 * t);
}

lerp["InOutExpo"] <- function(t) { 
    return t == 0 ? 0 : t == 1 ? 1 : t < 0.5 ? pow(2, 20 * t - 10) / 2 : (2 - pow(2, -20 * t + 10)) / 2;
}

lerp["InCirc"] <- function(t) { 
    return 1 - sqrt(1 - pow(t, 2));
}

lerp["OutCirc"] <- function(t) { 
    return sqrt(1 - pow(t - 1, 2));
}

lerp["InOutCirc"] <- function(t) { 
    return t < 0.5 ? (1 - sqrt(1 - pow(2 * t, 2))) / 2 : (sqrt(1 - pow(-2 * t + 2, 2)) + 1) / 2;
}

lerp["InBack"] <- function(t) { 
    local c1 = 1.70158;
    local c3 = c1 + 1;
    return c3 * t * t * t - c1 * t * t;
}

lerp["OutBack"] <- function(t) { 
    local c1 = 1.70158;
    local c3 = c1 + 1;
    return 1 + c3 * pow(t - 1, 3) + c1 * pow(t - 1, 2);
}

lerp["InOutBack"] <- function(t) { 
    local c1 = 1.70158;
    local c2 = c1 * 1.525;
    return t < 0.5
       ? (pow(2 * t, 2) * ((c2 + 1) * 2 * t - c2)) / 2
       : (pow(2 * t - 2, 2) * ((c2 + 1) * (t * 2 - 2) + c2) + 2) / 2;
}

lerp["InElastic"] <- function(t) { 
    local c4 = (2 * PI) / 3;
    return t == 0
        ? 0
        : t == 1
        ? 1
        : -pow(2, 10 * t - 10) * sin((t * 10 - 10.75) * c4);
}

lerp["OutElastic"] <- function(t) { 
    local c4 = (2 * PI) / 3;
    return t == 0
    ? 0
    : t == 1
    ? 1
    : pow(2, -10 * t) * sin((t * 10 - 0.75) * c4) + 1;
}

lerp["InOutElastic"] <- function(t) { 
    local c5 = (2 * PI) / 4.5;
    return t == 0
    ? 0
    : t == 1
    ? 1
    : t < 0.5
    ? -(pow(2, 20 * t - 10) * sin((20 * t - 11.125) * c5)) / 2
    : (pow(2, -20 * t + 10) * sin((20 * t - 11.125) * c5)) / 2 + 1;
}

lerp["InBounce"] <- function(t) { 
    return 1 - math.lerp.OutBounce(1 - t); // todo
}

lerp["OutBounce"] <- function(t) { 
    local n1 = 7.5625;
    local d1 = 2.75;
    if (t < 1 / d1) {
    return n1 * t * t;
    } else if (t < 2 / d1) {
        return n1 * (t -= 1.5 / d1) * t + 0.75;
    } else if (t < 2.5 / d1) {
        return n1 * (t -= 2.25 / d1) * t + 0.9375;
    } else {
        return n1 * (t -= 2.625 / d1) * t + 0.984375;
    }
}

lerp["InOutBounce"] <- function(t) { 
    return t < 0.5
    ? (1 - math.lerp.OutBounce(1 - 2 * t)) / 2
    : (1 + math.lerp.OutBounce(2 * t - 1)) / 2;
}
math["Quaternion"] <- class {
    x = null;
    y = null;
    z = null;
    w = null;
    
    /*
     * Creates a new quaternion.
     *
     * @param {number} x - The x component.
     * @param {number} y - The y component.
     * @param {number} z - The z component.
     * @param {number} w - The w component.
    */
    constructor(x,y,z,w) {
        this.x = x
        this.y = y
        this.z = z
        this.w = w
    }

    /*
     * Creates a new quaternion from Euler angles.
     *
     * @param {Vector} angles - The Euler angles in degrees (pitch, yaw, roll).
     * @returns {Quaternion} - The new quaternion.
    */
    function fromEuler(angles) {
        // Convert angles to radians
        local pitch = angles.z * 0.5 / 180 * PI
        local yaw = angles.y * 0.5 / 180 * PI
        local roll = angles.x * 0.5 / 180 * PI

        // Calculate sine and cosine values
        local sRoll = sin(roll);
        local cRoll = cos(roll);
        local sPitch = sin(pitch);
        local cPitch = cos(pitch);
        local sYaw = sin(yaw);
        local cYaw = cos(yaw);

        // Calculate quaternion components
        return math.Quaternion(
            cYaw * cRoll * sPitch - sYaw * sRoll * cPitch,
            cYaw * sRoll * cPitch + sYaw * cRoll * sPitch,
            sYaw * cRoll * cPitch - cYaw * sRoll * sPitch,
            cYaw * cRoll * cPitch + sYaw * sRoll * sPitch
        )
    }

    /*
     * Creates a new quaternion from a vector.
     *
     * @param {Vector} vector - The vector.
     * @returns {Quaternion} - The new quaternion with the vector's components as x, y, z, and w set to 0.
    */
    function fromVector(vector) {
        return math.Quaternion(vector.x, vector.y, vector.z, 0)
    }


    /*
     * Rotates a vector by the quaternion.
     *
     * @param {Vector} vector - The vector to rotate.
     * @returns {Vector} - The rotated vector.
    */
    function rotateVector(vector) {
        // Convert vector to quaternion
        local vecQuaternion = this.fromVector(vector)
    
        // Find the inverse quaternion
        local inverse = math.Quaternion(
            -this.x,
            -this.y,
            -this.z,
            this.w
        )
    
        // Apply quaternion rotations to the vector
        local rotatedQuaternion = this * vecQuaternion * inverse;
    
        // Return the result as a rotated vector
        return Vector(rotatedQuaternion.x, rotatedQuaternion.y, rotatedQuaternion.z);
    }
    
    /*
     * Un-rotates a vector by the quaternion.
     *
     * @param {Vector} vector - The vector to un-rotate.
     * @returns {Vector} - The un-rotated vector.
    */
    function unrotateVector(vector) {
        local vecQuaternion = this.fromVector(vector)

        // Find the conjugate quaternion
        local conjugateQuaternion = math.Quaternion(
            -this.x,
            -this.y,
            -this.z,
            this.w
        );
        
        // Apply quaternion rotations to the vector with inverse rotation angles
        local unrotatedQuaternion = conjugateQuaternion * vecQuaternion * this;
    
        // Return the result as an un-rotated vector
        return Vector(unrotatedQuaternion.x, unrotatedQuaternion.y, unrotatedQuaternion.z);
    }

    /*
     * Performs spherical linear interpolation (slerp) between two quaternions.
     *
     * @param {Quaternion} targetQuaternion - The target quaternion to interpolate towards.
     * @param {Number} t - The interpolation parameter between 0 and 1.
     * @returns {Quaternion} - The interpolated quaternion.
    */
    function slerp(targetQuaternion, t) {
        // Normalize quaternions
        local quaternion1 = this.normalize()
        local quaternion2 = targetQuaternion.normalize()

        // Calculate angle between quaternions
        local cosTheta = quaternion1.x * quaternion2.x + quaternion1.y * quaternion2.y + quaternion1.z * quaternion2.z + quaternion1.w * quaternion2.w;

        // If angle is negative, invert the second quaternion
        if (cosTheta < 0) {
            quaternion2.x *= -1;
            quaternion2.y *= -1;
            quaternion2.z *= -1;
            quaternion2.w *= -1;
            cosTheta *= -1;
        }

        // Calculate interpolation values
        local theta = acos(cosTheta);
        local sinTheta = sin(theta);
        local weight1 = sin((1 - t) * theta) / sinTheta;
        local weight2 = sin(t * theta) / sinTheta;

        // Interpolate quaternions
        local resultQuaternion = math.Quaternion(
            weight1 * quaternion1.x + weight2 * quaternion2.x,
            weight1 * quaternion1.y + weight2 * quaternion2.y,
            weight1 * quaternion1.z + weight2 * quaternion2.z,
            weight1 * quaternion1.w + weight2 * quaternion2.w
        );

        return resultQuaternion.normalize()
    }

    /*
     * Normalizes the quaternion.
     *
     * @returns {Quaternion} - The normalized quaternion.
    */
    function normalize() {
        local magnitude = this.length()

        return math.Quaternion(
            this.x / magnitude,
            this.y / magnitude,
            this.z / magnitude,
            this.w / magnitude
        )
    }

    /*
    * Calculates the dot product of two quaternions.
    *
    * @param {Quaternion} other - The other quaternion.
    * @returns {number} - The dot product.
    */
    function dot(other) {
        return this.x * other.x + this.y * other.y + this.z * other.z + this.w * other.w;
    }

    /*
    * Calculates the length (magnitude) of the quaternion.
    *
    * @returns {number} - The length of the quaternion.
    */
    function length() {
        return sqrt(this.x * this.x + this.y * this.y + this.z * this.z + this.w * this.w);
    }

    /*
    * Calculates the inverse of the quaternion.
    *
    * @returns {Quaternion} - The inverse quaternion.
    */
    function inverse() {
        local lengthSquared = this.length() * this.length();
        return math.Quaternion(this.x / lengthSquared, -this.y / lengthSquared, -this.z / lengthSquared, -this.w / lengthSquared);
    }

    /*
    * Creates a quaternion from an axis and an angle.
    *
    * @param {Vector} axis - The axis of rotation (normalized vector).
    * @param {number} angle - The angle of rotation in radians.
    * @returns {Quaternion} - The quaternion.
    */
    function fromAxisAngle(axis, angle) {
        local halfAngle = angle * 0.5;
        local sinHalfAngle = sin(halfAngle);
        return math.Quaternion(axis.x * sinHalfAngle, axis.y * sinHalfAngle, axis.z * sinHalfAngle, cos(halfAngle));
    }

    /*
    * Converts the quaternion to an axis and an angle.
    *
    * @returns {table} - A table with keys "axis" (Vector) and "angle" (number).
    */
    function toAxisAngle() {
        local scale = sqrt(this.x * this.x + this.y * this.y + this.z * this.z);
        if (scale < 0.001) {
            return { axis = Vector(1, 0, 0), angle = 0 };
        }
        return { 
            axis = Vector(this.x / scale, this.y / scale, this.z / scale), 
            angle = 2 * acos(this.w) 
        };
    }


    /*
     * Converts the quaternion to a vector representing Euler angles.
     *
     * @returns {Vector} - The vector representing Euler angles in degrees.
    */
    function toVector() {
        local sinr_cosp = 2 * (this.w * this.x + this.y * this.z);
        local cosr_cosp = 1 - 2 * (this.x * this.x + this.y * this.y);
        local roll = atan2(sinr_cosp, cosr_cosp);

        local sinp = 2 * (this.w * this.y - this.z * this.x);
        local pitch;
        if (abs(sinp) >= 1) {
            pitch = math.copysign(PI / 2, sinp); // PI/2 or -PI/2
        } else {
            pitch = asin(sinp);
        }

        local siny_cosp = 2 * (this.w * this.z + this.x * this.y);
        local cosy_cosp = 1 - 2 * (this.y * this.y + this.z * this.z);
        local yaw = atan2(siny_cosp, cosy_cosp);

        // Convert angles to degrees
        local x = pitch * 180 / PI;
        local y = yaw * 180 / PI;
        local z = roll * 180 / PI;

        return Vector( x, y, z )
    }

    /* 
     * Checks if two quaternions are equal based on their components and length.
     *
     * @param {Quaternion} other - The other quaternion to compare.
     * @returns {boolean} - True if the quaternions are equal, false otherwise.
    */
    function isEqually(other) {
        return this.cmp(other) == 0
    }

    /*
     * Compares two quaternions based on their magnitudes.
     *
     * @param {Quaternion} other - The other quaternion to compare.
     * @returns {number} - 1 if this quaternion's magnitude is greater, -1 if less, 0 if equal.
    */
    function cmp(other) {
        if (typeof other != "Quaternion") {
            throw "Cannot compare quaternion with non-quaternion type";
        }
    
        local thisMagnitude = math.round(this.length(), 10000);
        local otherMagnitude = math.round(other.length(), 10000);

        if (thisMagnitude > otherMagnitude) {
            return 1;
        } else if (thisMagnitude < otherMagnitude) {
            return -1;
        } else {
            return 0; 
        }
    }

    function _cmp(other) return this.cmp(other)


    function _add(other) {
        return math.Quaternion(
            this.x + other.x,
            this.y + other.y,
            this.z + other.z,
            this.w + other.w
        )
    }


    function _sub(other) {
        return math.Quaternion(
            this.x - other.x,
            this.y - other.y,
            this.z - other.z,
            this.w - other.w
        )
    }
    
    /*
     * Multiplies two quaternions.
     *
     * @param {Quaternion} other - The other quaternion.
     * @returns {Quaternion} - The multiplication result.
    */
    function _mul(other) {
        if(typeof other == "Quaternion") {
            return math.Quaternion(
                this.w * other.x + this.x * other.w + this.y * other.z - this.z * other.y,
                this.w * other.y - this.x * other.z + this.y * other.w + this.z * other.x,
                this.w * other.z + this.x * other.y - this.y * other.x + this.z * other.w,
                this.w * other.w - this.x * other.x - this.y * other.y - this.z * other.z
            )
        }

        return math.Quaternion( 
            this.x * other,
            this.y * other,
            this.z * other,
            this.w * other
        )
    }

    function _tostring() {
        return "Quaternion: (" + x + ", " + y + ", " + z + ", " + w + ")"
    }

    function _typeof() {
        return "Quaternion"
    }
}
math["Matrix"] <- class {
    a = 1; b = 0; c = 0;
    d = 0; e = 1; f = 0;
    g = 0; h = 0; k = 1;

    /*
    * Creates a new matrix.
    *
    * @param {number} a - The value at row 1, column 1.
    * @param {number} b - The value at row 1, column 2.
    * @param {number} c - The value at row 1, column 3.
    * @param {number} d - The value at row 2, column 1.
    * @param {number} e - The value at row 2, column 2.
    * @param {number} f - The value at row 2, column 3.
    * @param {number} g - The value at row 3, column 1.
    * @param {number} h - The value at row 3, column 2.
    * @param {number} k - The value at row 3, column 3.
    */
    constructor(a = 1, b = 0, c = 0,
                d = 0, e = 1, f = 0,
                g = 0, h = 0, k = 1
        ) {
            this.a = a; this.b = b; this.c = c;
            this.d = d; this.e = e; this.f = f;
            this.g = g; this.h = h; this.k = k;
        }
    /*
    * Creates a rotation matrix from Euler angles.
    *
    * @param {Vector} angles - Euler angles in degrees (pitch, yaw, roll).
    * @returns {Matrix} - The rotation matrix.
    */
    function fromEuler(angles) {
        local sinX = sin(-angles.z / 180 * PI);
        local cosX = cos(-angles.z / 180 * PI);
        local sinY = sin(-angles.x / 180 * PI);
        local cosY = cos(-angles.x / 180 * PI);
        local sinZ = sin(-angles.y / 180 * PI);
        local cosZ = cos(-angles.y / 180 * PI);
        return math.Matrix(
            cosY * cosZ, -sinX * -sinY * cosZ + cosX * sinZ, cosX * -sinY * cosZ + sinX * sinZ,
            cosY * -sinZ, -sinX * -sinY * -sinZ + cosX * cosZ, cosX * -sinY * -sinZ + sinX * cosZ,
            sinY, -sinX * cosY, cosX * cosY
        );
    }

    /*
    * Rotates a point using the matrix.
    *
    * @param {Vector} point - The point to rotate.
    * @returns {Vector} - The rotated point.
    */
    function rotateVector(point) {
        return Vector(
            point.x * this.a + point.y * this.b + point.z * this.c,
            point.x * this.d + point.y * this.e + point.z * this.f,
            point.x * this.g + point.y * this.h + point.z * this.k
        );
    }

    /*
    * Unrotates a point using the matrix.
    *
    * @param {Vector} point - The point to unrotate.
    * @returns {Vector} - The unrotated point.
    */
    function unrotateVector(point) {
        return Vector(
            point.x * this.a + point.y * this.d + point.z * this.g,
            point.x * this.b + point.y * this.e + point.z * this.h,
            point.x * this.c + point.y * this.f + point.z * this.k
        );
    }

    /*
    * Transposes the matrix.
    *
    * @returns {Matrix} - The transposed matrix.
    */
    function transpose() {
        return math.Matrix(
            this.a, this.d, this.g,
            this.b, this.e, this.h,
            this.c, this.f, this.k
        );
    }

    /*
    * Calculates the inverse of the matrix.
    *
    * @returns {Matrix} - The inverse matrix.
    * @throws {Error} - If the matrix is singular (determinant is zero).
    */
    function inverse() {
        local det = this.determinant();
        if (det == 0) {
            throw "Matrix is singular (determinant is zero)"
        }
        local invDet = 1 / det;
        return math.Matrix(
            (this.e * this.k - this.f * this.h) * invDet,
            (this.c * this.h - this.b * this.k) * invDet,
            (this.b * this.f - this.c * this.e) * invDet,
            (this.f * this.g - this.d * this.k) * invDet,
            (this.a * this.k - this.c * this.g) * invDet,
            (this.c * this.d - this.a * this.f) * invDet,
            (this.d * this.h - this.e * this.g) * invDet,
            (this.b * this.g - this.a * this.h) * invDet,
            (this.a * this.e - this.b * this.d) * invDet
        );
    }

    /*
    * Calculates the determinant of the matrix.
    *
    * @returns {number} - The determinant of the matrix.
    */
    function determinant() {
        return this.a * (this.e * this.k - this.f * this.h) -
               this.b * (this.d * this.k - this.f * this.g) +
               this.c * (this.d * this.h - this.e * this.g);
    }

    /*
    * Scales the matrix by a given factor.
    *
    * @param {number} factor - The scaling factor.
    * @returns {Matrix} - The scaled matrix.
    */
    function scale(factor) {
        return math.Matrix(
            this.a * factor, this.b * factor, this.c * factor,
            this.d * factor, this.e * factor, this.f * factor,
            this.g * factor, this.h * factor, this.k * factor
        );
    }

    /*
    * Rotates the matrix around the X axis by a given angle.
    *
    * @param {number} angle - The angle of rotation in radians.
    * @returns {Matrix} - The rotated matrix.
    */
    function rotateX(angle) {
        local sinAngle = sin(angle);
        local cosAngle = cos(angle);
        return math.Matrix(
            1, 0, 0,
            0, cosAngle, -sinAngle,
            0, sinAngle, cosAngle
        ) * this;
    }

    /*
    * Multiplies two matrices.
    *
    * @param {Matrix} other - The other matrix.
    * @returns {Matrix} - The result of the multiplication.
    */
    function _mul(other) {
        return math.Matrix(
            this.a * other.a + this.b * other.d + this.c * other.g,
            this.a * other.b + this.b * other.e + this.c * other.h,
            this.a * other.c + this.b * other.f + this.c * other.k,
            this.d * other.a + this.e * other.d + this.f * other.g,
            this.d * other.b + this.e * other.e + this.f * other.h,
            this.d * other.c + this.e * other.f + this.f * other.k,
            this.g * other.a + this.h * other.d + this.k * other.g,
            this.g * other.b + this.h * other.e + this.k * other.h,
            this.g * other.c + this.h * other.f + this.k * other.k
        );
    }

    /*
    * Adds two matrices.
    *
    * @param {Matrix} other - The other matrix.
    * @returns {Matrix} - The result of the addition.
    */
    function _add(other) {
        return math.Matrix(
            this.a + other.a, this.b + other.b, this.c + other.c,
            this.d + other.d, this.e + other.e, this.f + other.f,
            this.g + other.g, this.h + other.h, this.k + other.k
        );
    }

    /*
    * Subtracts two matrices.
    *
    * @param {Matrix} other - The other matrix.
    * @returns {Matrix} - The result of the subtraction.
    */
    function _sub(other) {
        return math.Matrix(
            this.a - other.a, this.b - other.b, this.c - other.c,
            this.d - other.d, this.e - other.e, this.f - other.f,
            this.g - other.g, this.h - other.h, this.k - other.k
        );
    }

    /*
     * Checks if two matrices are equal based on their components and sum.
     *
     * @param {Matrix} other - The other matrix to compare.
     * @returns {boolean} - True if the matrices are equal, false otherwise.
    */
    function isEqually(other) {
        return this.cmp(other) == 0
    }

    /*
     * Compares two matrices based on the sum of their components.
     *
     * @param {Matrix} other - The other matrix to compare.
     * @returns {number} - 1 if this matrix's sum is greater, -1 if less, 0 if equal.
    */
    function cmp(other) {
        if (typeof other != "Matrix") {
            throw "Cannot compare matrix with non-matrix type";
        }
    
        local thisSum = a + b - c + d + e + f - g + h - k;
        local otherSum = other.a + other.b - other.c + other.d + other.e + other.f - other.g + other.h - other.k;
        
        if (thisSum > otherSum) {
            return 1;
        } else if (thisSum < otherSum) {
            return -1;
        } else {
            return 0;
        }
    }

    function _cmp(other) return this.cmp(other)

    function _tostring() {
        return "Matrix: {" + a + ", " + b + ", " + c + "\n\t " + d + ", " + e + ", " + f + "\n\t " + g + ", " + h + ", " + k + "}"
    }

    function _typeof() {
        return "Matrix"
    }
}

/*+--------------------------------------------------------------------------------+
|                           PCapture Vscripts Library                              |
+----------------------------------------------------------------------------------+
| Author:                                                                          |
|     Data Structure Maestro - laVashik ^v^                                        |
+----------------------------------------------------------------------------------+
|   The Improved Data Types module, offering enhanced versions of standard VScripts|
|   data structures like arrays, lists, and trees for efficient data management.   |
+----------------------------------------------------------------------------------+ */

::pcapEntityCache <- {}

::pcapEntity <- class {
    CBaseEntity = null;
    EntityScope = null;

    /* 
     * Constructor for the entity object.
     *
     * @param {CBaseEntity} entity - The entity object.
    */
    constructor(entity = null) { 
        if(typeof entity == "pcapEntity")
            entity = entity.CBaseEntity

        this.CBaseEntity = entity
        this.EntityScope = {}
        entity.ValidateScriptScope()
    }


    function SetAngles(x, y, z) {
        x = x >= 360 ? 0 : x
        y = y >= 360 ? 0 : y
        z = z >= 360 ? 0 : z
        this.CBaseEntity.SetAngles(x, y, z)
    }

    /*
     * Sets the angles of the entity.
     *
     * @param {Vector} angles - The angle vector.
    */
    function SetAbsAngles(angles) {
        this.CBaseEntity.SetAngles(angles.x, angles.y, angles.z)
    }


    // Destroys the entity. 
    function Destroy() {
        this.CBaseEntity.Destroy()
        this.CBaseEntity = null
    }


    /*
     * Kills the entity.
     *
     * @param {number} fireDelay - Delay in seconds before applying.
    */
    function Kill(fireDelay = 0) {
        EntFireByHandle(CBaseEntity, "kill", "", fireDelay)
        this.CBaseEntity = null
    }


    /*
     * Dissolves the entity using an env_entity_dissolver entity, creating a visual effect of the entity dissolving away.
     *
     * This method utilizes an env_entity_dissolver entity to create the dissolve effect. If the entity doesn't have a targetname, 
     * a unique targetname is assigned to it before initiating the dissolve process. 
     */
    function Dissolve() {
        if(this.GetName() == "")
            this.SetUniqueName("targetname")
        dissolver.SetKeyValue("target", this.GetName())
        EntFireByHandle(dissolver, "dissolve")

        this.SetUserData("Dissolved", true)
    }


    /*
     * Checks if the entity is valid.
     *
     * @returns {bool} - True if the entity is valid, false otherwise.
    */
    function IsValid() {
        return this.CBaseEntity && this.CBaseEntity.IsValid() && !this.GetUserData("Dissolved")
    }


    /*
     * Checks if this entity is the player entity.
     * 
     * @returns {bool} - True if this entity is the player, false otherwise.
    */
    function IsPlayer() {
        return this.CBaseEntity.GetClassname() == "player"
    }

    /*
     * Gets the eye position of the player entity.
     *
     * @returns {Vector|null} - The eye position as a Vector, or null if the entity is not a player.
     * 
     * This method retrieves the position from which the player's view is rendered. It is important to note that this method only works with player entities.
     * For non-player entities, it returns null. 
    */
     function EyePosition() {
        if(this.IsPlayer()) return this.CBaseEntity.EyePosition()
    }

    /*
     * Gets the eye angles of the player entity. 
     *
     * @returns {Vector|null} - The eye angles as a Vector representing pitch, yaw, and roll, or null if the entity is not a player.
     *
     * This method retrieves the orientation of the player's view. It is important to note that this method only works with player entities.
     * For non-player entities, it returns null. 
    */
    function EyeAngles() {
        if(this.IsPlayer()) return this.GetUserData("Eye").GetAngles()
    }

    /* 
     * Gets the forward vector from the player entity's eye position, indicating the direction the player is looking. 
     *
     * @returns {Vector|null} - The forward vector as a Vector, or null if the entity is not a player.
     *
     * This method retrieves the direction in which the player is facing. It is important to note that this method only works with player entities.
     * For non-player entities, it returns null.
    */
    function EyeForwardVector() {
        if(this.IsPlayer()) return this.GetUserData("Eye").GetForwardVector()
    }


    /*
     * Sets the key-value pair of the entity.  
     *
     * @param {string} key - The key of the key-value pair.
     * @param {int|float|Vector|string} value - The value of the key-value pair.
    */
    function SetKeyValue(key, value) {
        this.SetUserData(key, value)

        switch (typeof value) {
            case "integer":
                return this.CBaseEntity.__KeyValueFromInt(key, value);
            case "float":
                return this.CBaseEntity.__KeyValueFromFloat(key, value);
            case "Vector":
                return this.CBaseEntity.__KeyValueFromVector(key, value);
            case "string":
                return this.CBaseEntity.__KeyValueFromString(key, value);
        }
        
        return this.CBaseEntity.__KeyValueFromString(key, value.tostring());
    }


        /*
     * Connects an output of the entity to a target entity and input, allowing for parameter overrides, delays, and limited trigger counts.
     *
     * @param {string} outputName - The name of the output to connect.
     * @param {string|CBaseEntity|pcapEntity} target - The target entity or its targetname to connect the output to.
     * @param {string} input - The name of the input on the target entity to connect to.
     * @param {string} param - An optional parameter override for the input. (default: "")
     * @param {number} delay - An optional delay in seconds before triggering the input. (default: 0) 
     * @param {number} fires - The number of times the output should fire before becoming inactive. -1 indicates unlimited fires. (default: -1) 
     * 
     * This method provides a way to establish connections between entities, allowing them to trigger actions on each other based on outputs and inputs. 
    */
     function addOutput(outputName, target, input, param = "", delay = 0, fires = -1) {
        if(typeof target == "instance" || typeof target == "pcapEntity")
            target = target.GetName()
        this.SetKeyValue(outputName, target + "\x001B" + input + "\x001B" + param + "\x001B" + delay + "\x001B" + fires)
    }

    /* 
     * Connects an output of the entity to a script function or string, allowing for delays and limited trigger counts. 
     * 
     * @param {string} outputName - The name of the output to connect.
     * @param {string|function} script - The VScripts code or function name to execute when the output is triggered.
     * @param {number} delay - An optional delay in seconds before executing the script. (default: 0) 
     * @param {number} fires - The number of times the output should fire before becoming inactive. -1 indicates unlimited fires. (default: -1) 
     * 
     * This method provides a way to connect entity outputs directly to script code, allowing for custom actions to be performed when the output is triggered.
    */
    function ConnectOutputEx(outputName, script, delay = 0, fires = -1) {
        if(typeof script == "function") {
            local funcName = UniqueString("OutputFunc")
            getroottable()[funcName] <- script
            script = funcName + "()"
        }

        this.addOutput(outputName, "!self", "RunScriptCode", script, delay, fires)
    }


    /* 
     * Emits a sound with optional delay.
     *
     * @param {string} soundName - The name of the sound to play.
     * @param {number} timeDelay - Delay in seconds before playing the sound. (optional)
     * @param {string} eventName - The name of the event used for scheduling. (optional)
    */
    function EmitSoundEx(soundName, timeDelay = 0, eventName = this) {
        if(timeDelay == 0)
            return this.CBaseEntity.EmitSound(soundName)
            
        ScheduleEvent.Add(eventName, this.EmitSound, timeDelay, [soundName], this)
    }


    /*
     * Sets the targetname of the entity.
     *
     * @param {string} name - The targetname to be set.
    */
    function SetName(name) {
        this.SetKeyValue("targetname", name)
    }

    /*
     * Sets a unique targetname for the entity using the provided prefix.
     *
     * @param {string} prefix - The prefix to be used for the unique targetname. (optional, default="u")
    */
    function SetUniqueName(prefix = "u") {
        this.SetKeyValue("targetname", UniqueString(prefix))
    }


    /*
     * Sets the parent of the entity.
     *
     * @param {string|CBaseEntity|pcapEntity} parent - The parent entity object or its targetname.
     * @param {number} fireDelay - Delay in seconds before applying.
    */
    function SetParent(parentEnt, fireDelay = 0) {
        this.SetUserData("parent", parentEnt)
        if(typeof parentEnt != "string") {
            if(parentEnt.GetName() == "") {
                parentEnt.SetUniqueName("parent")
            }
            parentEnt = parentEnt.GetName()
        }
        
        EntFireByHandle(this.CBaseEntity, "SetParent", parentEnt, fireDelay)
    }

    /*
     * Gets the parent of the entity.
     *
     * @returns {pcapEntity|null} - The parent entity object or null if no parent is set.
    */
    function GetParent() {
        return this.GetUserData("parent")
    }


    /*
     * Sets the collision of the entity.
     *
     * @param {number} solidType - The type of collision.
     * @param {number} fireDelay - Delay in seconds before applying.
    */
    function SetCollision(solidType, fireDelay = 0) {
        EntFireByHandle(this.CBaseEntity, "SetSolidtype", solidType.tostring(), fireDelay, null, null)
        this.SetUserData("Solidtype", solidType)
    }


    /*
     * Sets the collision group of the entity.
     *
     * @param {number} collisionGroup - The collision group.
    */
    function SetCollisionGroup(collisionGroup) {
        this.SetKeyValue("CollisionGroup", collisionGroup)
        this.SetUserData("CollisionGroup", collisionGroup)
    }
    

    /* 
     * Starts playing the specified animation.
     *
     * @param {string} animationName - The name of the animation to play.
     * @param {number} fireDelay - Delay in seconds before starting the animation.
    */
    function SetAnimation(animationName, fireDelay = 0) {
        EntFireByHandle(this.CBaseEntity, "SetAnimation", animationName, fireDelay)
        this.SetUserData("animation", animationName)
    }


    /*
     * Sets the alpha (opacity) of the entity.
     *
     * @param {number} opacity - The alpha value (0-255).
     * @param {number} fireDelay - Delay in seconds before applying.
     * Note: Don't forget to set "rendermode" to 5 for alpha to work.
    */
    function SetAlpha(opacity, fireDelay = 0) {
        EntFireByHandle(this.CBaseEntity, "Alpha", opacity.tostring(), fireDelay, null, null)
        this.SetUserData("alpha", opacity)
    }


    /*
     * Sets the color of the entity.
     *
     * @param {string|Vector} colorValue - The color value as a string (e.g., "255 0 0") or a Vector.
     * @param {number} fireDelay - Delay in seconds before applying.
    */
    function SetColor(colorValue, fireDelay = 0) {
        if(typeof colorValue == "Vector") 
            colorValue = macros.VecToStr(colorValue)
        EntFireByHandle(this.CBaseEntity, "Color", colorValue, fireDelay, null, null)
        this.SetUserData("color", colorValue)
    }


    /*
     * Sets the skin of the entity.
     *
     * @param {number} skin - The skin number.
     * @param {number} fireDelay - Delay in seconds before applying.
    */
    function SetSkin(skin, fireDelay = 0) {
        EntFireByHandle(this.CBaseEntity, "skin", skin.tostring(), fireDelay, null, null)
        this.SetUserData("skin", skin)
    }


    /*
     * Sets whether the entity should be drawn or not. 
     *
     * @param {boolean} isEnabled - True to enable drawing, false to disable.
     * @param {number} fireDelay - Delay in seconds before applying.
    */
    function SetDrawEnabled(isEnabled, fireDelay = 0) {
        local action = isEnabled ? "EnableDraw" : "DisableDraw"
        EntFireByHandle(this.CBaseEntity, action, "", fireDelay)
        this.SetUserData("IsDraw", isEnabled)
    }

    /*
     * Checks if the entity is set to be drawn.
     * 
     * @returns {boolean} - True if the entity is set to be drawn, false otherwise.
    */
    function IsDrawEnabled() {
        return this.GetUserData("IsDraw")
    }

    /*
     * Sets whether the entity should be ignored during traces.
     * 
     * @param {boolean} isEnabled - True to ignore the entity during traces, false otherwise.
    */
    function SetTraceIgnore(isEnabled) {
        this.SetUserData("TracePlusIgnore", isEnabled)
    }

    /*
     * Sets the spawnflags for the entity.
     *
     * @param {number} flag - The spawnflags value to set.
    */
    function SetSpawnflags(flag) {
        this.SetKeyValue("CollisionGroup", flag)
        this.SetUserData("spawnflags", flag)
    }


    /*
     * Sets the scale of the entity's model.
     *
     * @param {number} scaleValue - The scale value.
     * @param {number} fireDelay - Delay in seconds before applying.
    */
    function SetModelScale(scaleValue, fireDelay = 0) {
        EntFireByHandle(this.CBaseEntity, "addoutput", "ModelScale " + scaleValue, fireDelay, null, null)
        this.SetUserData("ModelScale", scaleValue)
        EntFireByHandle(this, "SetBodyGroup", "1"); EntFireByHandle(this, "SetBodyGroup", "0", 0.02)
    }

    /*
     * Gets the current model scale of the entity.
     *
     * @returns {number} - The current model scale value.
    */
    function GetModelScale() {
        local res = this.GetUserData("ModelScale")
        return res ? res : 1
    }


    /*
     * Sets the center of the entity.
     *
     * @param {Vector} vector - The center vector.
    */
    function SetCenter(vector) {
        local offset = this.CBaseEntity.GetCenter() - this.CBaseEntity.GetOrigin()
        this.CBaseEntity.SetAbsOrigin( vector - offset )
    }

    /*
     * Sets the bounding box of the entity.
     *
     * @param {Vector|string} min - The minimum bounds vector or a string representation of the vector.
     * @param {Vector|string} max - The maximum bounds vector or a string representation of the vector.
    */
    function SetBBox(minBounds, maxBounds) {
        // Please specify the data type of `min` and `max` to improve the documentation accuracy.
        if (type(minBounds) == "string") {
            minBounds = macros.StrToVec(minBounds)
        }
        if (type(maxBounds) == "string") {
            maxBounds = macros.StrToVec(maxBounds)
        }

        this.CBaseEntity.SetSize(minBounds, maxBounds)
    }


    /*
     * Sets a context value for the entity.
     *
     * @param {string} name - The name of the context value.
     * @param {any} value - The value to set.
     * @param {number} fireDelay - Delay in seconds before applying.
    */
    function SetContext(name, value, fireDelay = 0) {
        EntFireByHandle(this.CBaseEntity, "AddContext", (name + ":" + value), fireDelay)
        this.SetUserData(name, value)
    }
    
    /* 
     * Stores an arbitrary value associated with the entity.
     *
     * @param {string} name - The name of the value.  
     * @param {any} value - The value to store.
    */
    function SetUserData(name, value) {
        this.EntityScope[name.tolower()] <- value
    }


    /*
     * Gets a stored user data value.
     *
     * @param {string} name - The name of the value to get.
     * @returns {any} - The stored value, or null if not found.
    */ 
    function GetUserData(name) {
        name = name.tolower()
        if(name in this.EntityScope)
            return this.EntityScope[name]
        return null
    }


    /*
     * Gets the bounding box of the entity.
     *
     * @returns {table} - The minimum bounds and maximum bounds of the entity.
    */
    function GetBBox() {
        local max = GetBoundingMaxs()
        local min = GetBoundingMins()
        return {min = min, max = max}
    }


    /* 
     * Returns the axis-aligned bounding box (AABB) of the entity.
     *
     * @returns {table} - The minimum bounds, maximum bounds, and center of the entity.
    */ 
    function GetAABB() {
        local max = CreateAABB(7)
        local min = CreateAABB(0)
        local center = CreateAABB(4)
        return {min = min, center = center, max = max}
    }


    /* 
     * Gets the index of the entity.
     *
     * @returns {int} - The index of the entity.
    */
    function GetIndex() {
        return this.CBaseEntity.entindex()
    }


    /*
     * Gets the value of the key-value pair of the entity.
     * Note: only works if you used the SetKeyValue function!
     *
     * @param {string} key - The key of the key-value pair.
     * @returns {any} - The value of the key-value pair.
    */
    function GetKeyValue(key) {
        local value = this.GetUserData(key)
        if(value != null)
            return value

        switch(key) {
            case "model":
                return this.GetModelName()
                break
            case "health":
                return this.GetHealth()
                break
            case "targetname":
                return this.GetName()
                break
        }

        return null
    }


    /*
     * Gets the spawnflags for the entity.
     * Note: only works if you used the SetKeyValue function!
     *
     * @returns {int|null} - The spawnflags value.
    */ 
    function GetSpawnflags() {
        return this.GetUserData("spawnflags")
    }


    /*
     * Gets the alpha/opacity value of the entity.
     * Note: only works if you used the SetKeyValue function!
     * 
     * @returns {int|null} - The alpha value.
    */
    function GetAlpha() {
        local alpha = this.GetUserData("alpha")
        return alpha != null ? alpha : 255
    }


    /*
     * Gets the color value of the entity.
     * Note: only works if you used the SetKeyValue function!
     *
     * @returns {string|null} - The color value.
    */
    function GetColor() {
        local color = this.GetUserData("color")
        return color ? color : "255 255 255"
    }


    /*
     * Gets the skin of the entity.
     * Note: only works if you used the SetKeyValue function!
     *
     * @returns {number|null} - The skin number.
    */
    function GetSkin() {
        local skin = this.GetUserData("skin")
        return skin ? skin : 0
    }


    /*
     * Gets the prefix of the entity name.
     *
     * @returns {string} - The prefix of the entity name.
    */
    function GetNamePrefix() {
        return macros.GetPrefix(this.GetName())
    }


    /*
     * Gets the postfix of the entity name.
     *
     * @returns {string} - The postfix of the entity name.
    */
    function GetNamePostfix() {
        return macros.GetPostfix(this.GetName())
    }

    /*
     * Retrieves the partner instance of the entity, prioritizing the actual partner entity if available, and falling back to user-stored partner data if necessary.
     *
     * @returns {Entity|null} - The partner entity, or null if no partner is found.
     * 
     * This method first attempts to retrieve the actual partner entity using the `GetPartnerInstance` method of the underlying CBaseEntity.
     * If no partner entity is found, it then checks for a partner stored in the entity's user data under the key "partner". This can be useful in situations where the partner relationship is not directly established through entity properties but is managed through custom logic. 
    */
    function GetPartnerInstance() {
        if(this.CBaseEntity instanceof CLinkedPortalDoor)
            return entLib.FromEntity(this.CBaseEntity.GetPartnerInstance())
        return this.GetUserData("partner")
    }


    /*
     * Gets the oriented bounding box of the entity.
     *
     * @param {number} stat - 0 for min bounds, 7 for max bounds, 4 for center bounds. 
     * @returns {Vector} - The bounds vector.
    */
    function CreateAABB(stat) { 
        local angles = this.GetAngles()
        if(stat == 4) 
            angles = Vector(45, 45, 45)

        local all_vertex = this.getBBoxPoints()
        local x = array(8) // AVLTree() // todo FUCKING AVL!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        local y = array(8)
        local z = array(8)

        foreach(idx, vec in all_vertex) {
            x[idx] = vec.x
            y[idx] = vec.y
            z[idx] = vec.z
        }

        x.sort(); y.sort(); z.sort()
 
        if(stat == 4) // centered
            return ( Vector(x[7], y[7], z[7]) - Vector(x[0], y[0], z[0]) ) * 0.5
        return Vector(x[stat], y[stat], z[stat])
    }


    /*
     * Gets the 8 vertices of the axis-aligned bounding box.
     *
     * @returns {Array<Vector>} - The 8 vertices of the bounding box.  
    */
    function getBBoxPoints() {
        local max = this.GetBoundingMaxs();
        local min = this.GetBoundingMins();
        local angles = this.GetAngles()
    
        local getVertex = macros.GetVertex
        return [
            getVertex(max, min, min, angles), // 0 - Right-Bottom-Front
            getVertex(max, max, min, angles), // 1 - Right-Top-Front
            getVertex(min, max, min, angles), // 2 - Left-Top-Front
            getVertex(min, min, min, angles)  // 3 - Left-Bottom-Front 
            getVertex(min, min, max, angles), // 4 - Left-Bottom-Back
            getVertex(min, max, max, angles), // 5 - Left-Top-Back
            getVertex(max, max, max, angles), // 6 - Right-Top-Back
            getVertex(max, min, max, angles), // 7 - Right-Bottom-Back
        ]
    }

    /*
     * Gets the faces of the entity's bounding box as an array of triangle vertices.
     *
     * @returns {array} - An array of 12 Vector triplets, where each triplet represents the three vertices of a triangle face.
     * 
    */
     function getBBoxFaces() {
        local vertices = this.getBBoxPoints()
        return [
            /* Bottom face triangles */ 
            macros.GetTriangle(vertices[0], vertices[3], vertices[4]), // Face 0: Right-Bottom-Front, Left-Bottom-Front, Left-Bottom-Back
            macros.GetTriangle(vertices[0], vertices[4], vertices[7]), // Face 1: Right-Bottom-Front, Left-Bottom-Back, Right-Bottom-Back

            /* Top face triangles */ 
            macros.GetTriangle(vertices[1], vertices[2], vertices[5]), // Face 2: Right-Top-Front, Left-Top-Front, Left-Top-Back
            macros.GetTriangle(vertices[1], vertices[5], vertices[6]), // Face 3: Right-Top-Front, Left-Top-Back, Right-Top-Back

            /* Left face triangles */ 
            macros.GetTriangle(vertices[3], vertices[2], vertices[5]), // Face 4: Left-Bottom-Front, Left-Top-Front, Left-Top-Back 
            macros.GetTriangle(vertices[3], vertices[5], vertices[4]), // Face 5: Left-Bottom-Front, Left-Top-Back, Left-Bottom-Back

            /* Right face triangles */ 
            macros.GetTriangle(vertices[0], vertices[1], vertices[6]), // Face 6: Right-Bottom-Front, Right-Top-Front, Right-Top-Back
            macros.GetTriangle(vertices[0], vertices[6], vertices[7]), // Face 7: Right-Bottom-Front, Right-Top-Back, Right-Bottom-Back

            /* Front face triangles */ 
            macros.GetTriangle(vertices[0], vertices[1], vertices[2]), // Face 8: Right-Bottom-Front, Right-Top-Front, Left-Top-Front 
            macros.GetTriangle(vertices[0], vertices[2], vertices[3]), // Face 9: Right-Bottom-Front, Left-Top-Front, Left-Bottom-Front

            /* Back face triangles */
            macros.GetTriangle(vertices[7], vertices[6], vertices[5]), // Face 10: Right-Bottom-Back, Right-Top-Back, Left-Top-Back 
            macros.GetTriangle(vertices[7], vertices[5], vertices[4])  // Face 11: Right-Bottom-Back, Left-Top-Back, Left-Bottom-Back 
        ]
    }

    /*
     * Checks if this entity is equal to another entity based on their entity indices.
     *
     * @param {pcapEntity} other - The other entity to compare.
     * @returns {boolean} - True if the entities are equal, false otherwise.
    */
    function isEqually(other) return this.entindex() == other.entindex()

    /*
     * Converts the entity object to a string.
     *
     * @returns {string} - The string representation of the entity.
    */
    function _tostring() return "pcapEntity: " + this.CBaseEntity + ""

    /*
     * Returns the type of the entity object.
     *
     * @returns {string} - The type of the entity object.
    */
    function _typeof() return "pcapEntity"
}

function pcapEntity::ConnectOutput(output, funcName) this.CBaseEntity.ConnectOutput(output, funcName)
function pcapEntity::DisconnectOutput(output, funcName) this.CBaseEntity.DisconnectOutput(output, funcName)
function pcapEntity::EmitSound(sound_name) this.CBaseEntity.EmitSound(sound_name)
function pcapEntity::PrecacheSoundScript(sound_name) this.CBaseEntity.PrecacheSoundScript(sound_name)
function pcapEntity::IsSequenceFinished() return this.CBaseEntity.IsSequenceFinished()
function pcapEntity::SpawnEntity() this.CBaseEntity.SpawnEntity()

function pcapEntity::GetAngles() return this.CBaseEntity.GetAngles()
function pcapEntity::GetScriptScope() return this.CBaseEntity.GetScriptScope()
function pcapEntity::GetAngularVelocity() return this.CBaseEntity.GetAngularVelocity()
function pcapEntity::GetBoundingMaxs() return this.CBaseEntity.GetBoundingMaxs()
function pcapEntity::GetBoundingMins() return this.CBaseEntity.GetBoundingMins()
function pcapEntity::GetCenter() return this.CBaseEntity.GetCenter()
function pcapEntity::GetClassname() return this.CBaseEntity.GetClassname()
function pcapEntity::GetForwardVector() return this.CBaseEntity.GetForwardVector()
function pcapEntity::GetHealth() return this.CBaseEntity.GetHealth()
function pcapEntity::GetLeftVector() return this.CBaseEntity.GetLeftVector()
function pcapEntity::GetMaxHealth() return this.CBaseEntity.GetMaxHealth()
function pcapEntity::GetModelKeyValues() return this.CBaseEntity.GetModelKeyValues()
function pcapEntity::GetModelName() return this.CBaseEntity.GetModelName()
function pcapEntity::GetName() return this.CBaseEntity.GetName()
function pcapEntity::GetOrigin() return this.CBaseEntity.GetOrigin()
function pcapEntity::GetScriptId() return this.CBaseEntity.GetScriptId()
function pcapEntity::GetUpVector() return this.CBaseEntity.GetUpVector()
function pcapEntity::GetPartnername() return this.CBaseEntity.GetPartnername()
function pcapEntity::ValidateScriptScope() return this.CBaseEntity.ValidateScriptScope()
function pcapEntity::EyePosition() return this.CBaseEntity.EyePosition()
function pcapEntity::entindex() return this.CBaseEntity.entindex()

function pcapEntity::SetAbsOrigin(vector) this.CBaseEntity.SetAbsOrigin(vector)
function pcapEntity::SetForwardVector(vector) this.CBaseEntity.SetForwardVector(vector)
function pcapEntity::SetHealth(health) this.CBaseEntity.SetHealth(health)
function pcapEntity::SetMaxHealth(health) this.CBaseEntity.SetMaxHealth(health)
function pcapEntity::SetModel(model_name) this.CBaseEntity.SetModel(model_name)
function pcapEntity::SetOrigin(vector) this.CBaseEntity.SetOrigin(vector)
::entLib <- class {
    /*
     * Creates an entity of the specified classname with the provided keyvalues.
     *
     * @param {string} classname - The classname of the entity.
     * @param {table} keyvalues - The key-value pairs for the entity.
     * @returns {pcapEntity} - The created entity object.
    */
    function CreateByClassname(classname, keyvalues = {}) {
        local new_entity = entLib.FromEntity(Entities.CreateByClassname(classname))
        foreach(key, value in keyvalues) {
            new_entity.SetKeyValue(key, value)
        }

        pcapEntityCache[new_entity.CBaseEntity] <- new_entity

        return new_entity
    }


    /*
     * Creates a prop entity with the specified parameters.
     * 
     * @param {string} classname - The classname of the prop.
     * @param {Vector} origin - The initial origin (position) of the prop.
     * @param {string} modelname - The model name of the prop.
     * @param {number} activity - The initial activity of the prop. (optional, default=1)
     * @param {table} keyvalues - Additional key-value pairs for the prop. (optional)
     * @returns {pcapEntity} - The created prop entity object.
    */
    function CreateProp(classname, origin, modelname, activity = 1, keyvalues = {}) {
        local new_entity = entLib.FromEntity(CreateProp(classname, origin, modelname, activity))
        foreach(key, value in keyvalues) {
            new_entity.SetKeyValue(key, value)
        }
        
        pcapEntityCache[new_entity.CBaseEntity] <- new_entity

        return new_entity
    }
    

    /*
     * Wraps a CBaseEntity object in a pcapEntity object.
     *
     * @param {CBaseEntity} CBaseEntity - The CBaseEntity object to wrap.
     * @returns {pcapEntity} - The wrapped entity object.
    */
    function FromEntity(CBaseEntity) {
        if(typeof CBaseEntity == "pcapEntity")
            return CBaseEntity
        return entLib.__init(CBaseEntity)
    }

    
    /*
     * Finds an entity with the specified classname.
     *
     * @param {string} classname - The classname to search for.
     * @param {CBaseEntity|pcapEntity} start_ent - The starting entity to search within. (optional)
     * @returns {pcapEntity|null} - The found entity object, or null if not found.
    */
    function FindByClassname(classname, start_ent = null) {
        if(start_ent && typeof start_ent == "pcapEntity")
            start_ent = start_ent.CBaseEntity
        local new_entity = Entities.FindByClassname(start_ent, classname)
        return entLib.__init(new_entity)
    }


    /*
     * Finds an entity with the specified classname within a given radius from the origin.
     *
     * @param {string} classname - The classname to search for.
     * @param {Vector} origin - The origin position.
     * @param {number} radius - The search radius.
     * @param {CBaseEntity|pcapEntity} start_ent - The starting entity to search within. (optional)
     * @returns {pcapEntity|null} - The found entity object, or null if not found.
    */
    function FindByClassnameWithin(classname, origin, radius, start_ent = null) {
        if(start_ent && typeof start_ent == "pcapEntity")
            start_ent = start_ent.CBaseEntity
        local new_entity = Entities.FindByClassnameWithin(start_ent, classname, origin, radius)
        return entLib.__init(new_entity)
    }
    
    
    /* 
     * Finds an entity with the specified targetname within the given starting entity.
     *
     * @param {string} targetname - The targetname to search for.
     * @param {CBaseEntity|pcapEntity} start_ent - The starting entity to search within. (optional)
     * @returns {pcapEntity|null} - The found entity object, or null if not found.
    */
    function FindByName(targetname, start_ent = null) {
        if(start_ent && typeof start_ent == "pcapEntity")
            start_ent = start_ent.CBaseEntity
        local new_entity = Entities.FindByName(start_ent, targetname)
        return entLib.__init(new_entity)
    }


    /*
     * Finds an entity with the specified targetname within a given radius from the origin.
     *
     * @param {string} targetname - The targetname to search for.
     * @param {Vector} origin - The origin position.
     * @param {number} radius - The search radius.
     * @param {CBaseEntity|pcapEntity} start_ent - The starting entity to search within. (optional)
     * @returns {pcapEntity|null} - The found entity object, or null if not found.
    */
    function FindByNameWithin(targetname, origin, radius, start_ent = null) {
        if(start_ent && typeof start_ent == "pcapEntity")
            start_ent = start_ent.CBaseEntity
        local new_entity = Entities.FindByNameWithin(start_ent, targetname, origin, radius)
        return entLib.__init(new_entity)
    }


    /* 
     * Finds an entity with the specified model within the given starting entity.
     *
     * @param {string} model - The model to search for.
     * @param {CBaseEntity|pcapEntity} start_ent - The starting entity to search within. (optional)
     * @returns {pcapEntity|null} - The found entity object, or null if not found.
    */
    function FindByModel(model, start_ent = null) {
        if(start_ent && typeof start_ent == "pcapEntity")
            start_ent = start_ent.CBaseEntity
        local new_entity = Entities.FindByModel(start_ent, model)
        return entLib.__init(new_entity)
    }


    /*
     * Finds an entity with the specified model within a given radius from the origin.
     *
     * @param {string} model - The model to search for.
     * @param {Vector} origin - The origin position.
     * @param {number} radius - The search radius.
     * @param {CBaseEntity|pcapEntity} start_ent - The starting entity to search within. (optional)
     * @returns {pcapEntity|null} - The found entity object, or null if not found.
    */
    function FindByModelWithin(model, origin, radius, start_ent = null) {
        if(start_ent && typeof start_ent == "pcapEntity")
            start_ent = start_ent.CBaseEntity
        local new_entity = null
        for(local ent; ent = Entities.FindByClassnameWithin(ent, "*", origin, radius);) {
            if(ent.GetModelName() == model && ent != start_ent) {
                new_entity = ent;
                break;
            }
        }

        return entLib.__init(new_entity)
    }


    /*
     * Finds entities within a sphere defined by the origin and radius.
     *
     * @param {Vector} origin - The origin position of the sphere.
     * @param {number} radius - The radius of the sphere.
     * @param {CBaseEntity|pcapEntity} start_ent - The starting entity to search within. (optional)
     * @returns {pcapEntity|null} - The found entity object, or null if not found.
    */
    function FindInSphere(origin, radius, start_ent = null) {
        if(start_ent && typeof start_ent == "pcapEntity")
            start_ent = start_ent.CBaseEntity
        local new_entity = Entities.FindInSphere(start_ent, origin, radius)
        return entLib.__init(new_entity)
    }



    /* 
     * Initializes an entity object.
     *
     * @param {CBaseEntity} entity - The entity object.
     * @returns {pcapEntity} - A new entity object.
    */
    function __init(CBaseEntity) {
        if(!CBaseEntity || !CBaseEntity.IsValid())
            return null

        if(CBaseEntity in pcapEntityCache) {
            return pcapEntityCache[CBaseEntity]
        } else {
            local pcapEnt = pcapEntity(CBaseEntity)
            pcapEntityCache[CBaseEntity] <- pcapEnt
            return pcapEnt
        }
    }
}

/*
* Enhanced arrays module.
*/
::arrayLib <- class {
    // The internal array. 
    arr = null
    length = 0;
    
    // The internal table representation. 
    table = null;
    tableIsValid = false;
    
    /*
    * Constructor.
    *
    * @param {array} array - The initial array.
    */
    constructor(array = []) {
        if(typeof array == "arrayLib")
            array = array.arr
        this.arr = array
        this.table = {}
    }

    /*
    * Create a new arrayLib instance from arguments.
    *
    * @param {...any} vargv - The values for the array.
    * @returns {arrayLib} - The new arrayLib instance. 
    */
    function new(...) {
        local arr = array(vargc)
        for(local i = 0; i< vargc; i++) {
            arr[i] = vargv[i]
        }
        return arrayLib(arr)
    }

    /*
    * Append a value to the array.
    *
    * @param {any} val - The value to append.
    * @returns {arrayLib} - The arrayLib instance for chaining.
    */
    function append(val) {
        this._pushToTable(val)
        arr.append(val);
        return this
    }

    /*
    * Apply a function to each element and modify the array in-place.
    *
    * @param {Function} func - The function to apply.
    * @returns {arrayLib} - The arrayLib instance for chaining.
    */
    function apply(func) {
        foreach(idx, value in arr) {
            arr[idx] = func(value)
        }
        this.totable(true)
        return this
    }

    /*
    * Clear the array and table.
    *
    * @returns {arrayLib} - The arrayLib instance for chaining.
    */
    function clear() {
        this.arr.clear()
        this.table.clear()
        this.tableIsValid = false
        return this
    }

    /*
    * Extend the array with another array.
    *
    * @param {array|arrayLib} other - The array to extend from.
    * @returns {arrayLib} - The arrayLib instance for chaining.
    */
    function extend(other) {
        if(typeof other == "arrayLib") {
            other = other.arr
        }

        arr.extend(other);
        this.totable(true)
         
        return this
    }

    /*
    * Filter the array by a predicate function.
    *
    * @param {Function} func(index, value, newArray) - The predicate function. 
    * @returns {arrayLib} - The filtered array.
    */
    function filter(func) {
        local newArray = arrayLib([])
        foreach(idx, val in arr) {
            if(func(idx, val, newArray))
                newArray.append(val)
        }
        return newArray
    }

    /*
    * Check if the array contains a value.
    *
    * @param {any} match - The value to find.
    * @returns {boolean} - Whether the value is found.
    */
    function contains(match) { 
        if(!this.tableIsValid) this.totable()
        return match in this.table
    }

    /*
    * Search for a value in the array.
    *
    * @param {any|Function} match - The value or predicate to search for.
    * @returns {int|null} - The index of the match or null.
    */
    function search(match) {
        if(typeof match == "function") {
            foreach(idx, val in arr) {
                if(match(val))
                    return idx
            }
        }
        else {
            foreach(idx, val in arr) {
                if(val == match)
                    return idx
            }
        }

        return null
    }

    /*
    * Insert a value into the array.
    *
    * @param {int} idx - The index to insert at.
    * @param {any} val - The value to insert.
    */
    function insert(idx, val) {
        this._pushToTable(val)
        return arr.insert(idx, val)
    }

    /*
    * Get the array length.
    *
    * @returns {int} - The array length.
    */
    function len() {
        return this.arr.len()
    }

    /*
    * Map the array to a new array via a function.
    *
    * @param {Function} func - The mapping function.
    * @returns {arrayLib} - The mapped array.
    */
    function map(func) {
        local newArray = array(this.len())
        foreach(idx, value in arr) {
            newArray[idx] = func(value)
        }
        return arrayLib(newArray)
    }

    /*
    * Pop a value off the end of the array.
    *
    * @returns {any} - The popped value.
    */
    function pop() {
        local pop = arr.pop()
        this._deleteFromTable(pop)
        return pop
    }

    /*
    * Append a value to the array.
    *
    * @param {any} val - The value to append.
    */
    function push(val) {
        this.append(val)
    }

    // function reduce(func) {

    // }

    /*
    * Remove an element by index.
    *
    * @param {int} idx - The index to remove.
    */
    function remove(idx) {
        this._deleteFromTable(arr[idx])
        arr.remove(idx);
    }

    /*
    * Resize the array.
    *
    * @param {int} size - The new size.
    * @param {any} fill - The fill value for new slots.
    */
    function resize(size, fill = null) {
        arr.resize(size, fill);
        this.totable(true)
    }

    /*
    * Reverse the array in-place.
    *
    * @returns {arrayLib} - The reversed array.
    */
    function reverse() {
        arr.reverse();
        return this
    }

    /*
    * Slice a portion of the array.
    *
    * @param {int} start - The start index.
    * @param {int} end - The end index.
    * @returns {arrayLib} - The sliced array.
    */
    function slice(start, end = null) {
        return arrayLib(arr.slice(start, end || this.len()))
    }

    /*
    * Sort the array.
    *
    * @param {Function} func - Optional compare function.
    * @returns {arrayLib} - The sorted array.
    */
    function sort(func = null) {
        func ? arr.sort(func) : arr.sort()
        return this
    }

    /*
    * Get the last element.
    *
    * @returns {any} - The last element.
    */
    function top() {
        return arr.top();
    }

    /*
    * Join the array into a string.
    *
    * @param {string} joinstr - The separator string.
    * @returns {string} - The joined string.
    */
    function join(joinstr = "") {
        if(this.len() == 0) return ""
        
        local string = ""
        foreach(elem in this.arr) {
            string += elem + joinstr
        }
        return joinstr.len() != 0 ? string.slice(0, joinstr.len() * -1) : string
    }

    /*
    * Retrieve the element at the specified index in the array.
    *
    * @param {integer} idx - The index of the element to retrieve.
    * @param {any} defaultVal - Optional default value to return if the index is out of bounds. Defaults to null.
    * @returns {any} - The element at the specified index or the default value if the index is out of bounds.
    */
    function get(idx, defaultVal = null) {
        if(this.len() > idx)
            return this.arr[idx]
        return defaultVal
    }

    /*
    * Convert the array to a table.
    *
    * @param {boolean} reacreate - Whether to recreate the table.
    * @returns {table} - The table representation.
    */
    function totable(reacreate = false) {
        if(this.table.len() > 0 && !reacreate) return this.table

        tableIsValid = true
        this.table.clear()
        foreach(element in arr) {
            if(element) this.table[element] <- null
        }
        return this.table
    }

    function tolist() {
        local list = List()
        foreach(idx, value in this.arr) {
            list.append(value)
        }
        return list
    }

    /*
    * Delete a value from the internal table.
    *
    * @param {any} val - The value to delete.
    */
    function _deleteFromTable(val) {
        if(val in this.table)
            this.table.rawdelete(val)
    }

    /*
    * Add a value to the internal table.
    *
    * @param {any} val - The value to add.
    */
    function _pushToTable(val) {
        if(this.table.len() != 0)
            this.table[val] <- null
    }


    function _cloned() {
        return arrayLib(clone this.arr)
    }

    /*
    * Convert the array to a string.
    *
    * @returns {string} - The string representation.
    */
    function _tostring() return format("Array: [%s]", this.join(", "))
    
    /*
    * Get the type name.
    *
    * @returns {"arrayLib"}
    */
    function _typeof () return "arrayLib";
    
    /*
    * Get an element by index.
    *
    * @param {int} idx - The index.
    * @returns {any} - The element.
    */
    function _get(idx) return arr[idx];
    
    /*
    * Set an element by index.
    *
    * @param {int} idx - The index.
    * @param {any} val - The new value.
    */
    function _set(idx, val) return arr[idx] = val;


    function _nexti(previdx) {
        if(this.len() == 0) return null
        if (previdx == null) return 0;
		return previdx < this.len() - 1 ? previdx + 1 : null;
	}

    function cmp(other) { // lmao, why? :O
        local thisSum = 0;
        local otherSum = 0;
        foreach (val in this) { thisSum += val; }
        foreach (val in other) { otherSum += val; }

    
        if (thisSum > otherSum) {
            return 1;
        } else if (thisSum < otherSum) {
            return -1;
        } else {
            return 0; 
        }
    }
}
::ListNode <- class {
    value = null;
    prev_ref = null;
    next_ref = null;

    /*
     * Constructor for a list node.
     *
     * @param {any} value - The value to store in the node.
    */
    constructor(value) {
        this.value = value;
    }

    function _tostring() {
        return this.value.tostring();
    }
}

::List <- class {
    length = 0;
    first_node = null;
    last_node = null;

    /*
     * Constructor for a list.
     *
     * @param {...any} vargv - The initial values to add to the list.
    */
    constructor(...) {
        this.first_node = ListNode(0);
        this.last_node = this.first_node;
        
        for(local i = 0; i< vargc; i++) {
            this.append(vargv[i])
        }
    }

    /*
     * Creates a new list from an array.
     * 
     * @param {array} array - The array to create the list from.
     * @returns {List} - The new list containing the elements from the array.
    */
    function fromArray(array) {
        local list = List()
        foreach(val in array) 
            list.append(val)
        return list
    }

    /*
     * Gets the length of the list.
     *
     * @returns {number} - The number of elements in the list.
    */
    function len() {
        return this.length;
    }

    /*
     * Appends a value to the end of the list.
     * 
     * @param {any} value - The value to append.
    */
    function append(value) {
        local next_node = ListNode(value);
        local current_node = this.last_node;

        current_node.next_ref = next_node;
        next_node.prev_ref = current_node;
        
        this.last_node = next_node;
        this.length++;
    }

    /*
     * Inserts a value at a specific index in the list.
     * 
     * @param {number} index - The index to insert the value at.
     * @param {any} value - The value to insert.
    */
    function insert(idx, value) {
        if(this.length == 0 || idx >= this.length) 
            return this.append(value)
    
        local node = this.getNode(idx)
        local newNode = ListNode(value)

        newNode.next_ref = node
        newNode.prev_ref = node.prev_ref
        
        node.prev_ref.next_ref = newNode 
        node.prev_ref = newNode

        this.length++
    }

    /*
     * Gets the node at a specific index in the list.
     * 
     * @param {number} index - The index of the node to retrieve.
     * @returns {ListNode} - The node at the specified index.
     * @throws {Error} - If the index is out of bounds.
    */
    function getNode(idx) {
        if (idx >= this.length) {
            throw("the index '" + idx + "' does not exist!");
        }

        local node = this.first_node.next_ref;
        for (local i = 0; i < idx; i++) {
            node = node.next_ref;
        }
        return node;
    }

    /*
     * Gets the value at a specific index in the list.
     * 
     * @param {number} index - The index of the value to retrieve.
     * @param {any} defaultValue - The value to return if the index is out of bounds. (optional)
     * @returns {any} - The value at the specified index or the default value if the index is out of bounds.
    */
    function get(idx, defaultValue = null) {
        if (idx >= this.length)
            return defaultValue

        return this.getNode(idx).value
    }

    /*
     * Removes the node at a specific index from the list.
     * 
     * @param {number} index - The index of the node to remove.
    */
    function remove(idx) {
        local node = this.getNode(idx);
        local next = node.next_ref;
        local prev = node.prev_ref;

        if (prev) {
            prev.next_ref = next; 
        } else {
            this.first_node.next_ref = next;
        }
    
        if (next) {
            next.prev_ref = prev;
        } else { 
            this.last_node = prev; 
        } 

        this.length--;
    }

    /*
     * Removes the last element from the list and returns its value.
     * 
     * @returns {any} - The value of the removed element.
    */
    function pop() {
        local current = this.last_node;
        this.last_node = current.prev_ref;
        this.last_node.next_ref = null;
        this.length--
        return current.value;
    }

    /*
     * Gets the value of the last element in the list.
     * 
     * @returns {any} - The value of the last element.
    */
    function top() {
        if(this.length == 0) throw("top() on a empty list")
        return this.last_node.value
    }

    function first() {
        if(this.length == 0) throw("first() on a empty list")
        return this.first_node.next_ref.value
    }

    /*
     * Reverses the order of the elements in the list in-place.
    */
    function reverse() {
        local prev_node = null;
        local current_node = this.first_node.next_ref;

        while (current_node) {
            local next_node = current_node.next_ref;

            current_node.next_ref = prev_node;
            current_node.prev_ref = next_node;

            prev_node = current_node;
            current_node = next_node;
        }

        local temp = this.first_node.next_ref;
        this.first_node.next_ref = prev_node;
        this.last_node = temp;
    }

    function sort() {
        this.first_node.next_ref = _mergeSort(this.first_node.next_ref)
        
        // Update prev_ref and next_ref links after sorting
        local current = this.first_node.next_ref;
        local previous = null;
        while (current) {
            current.prev_ref = previous;
            if (previous) {
                previous.next_ref = current; 
            }
            previous = current; 
            current = current.next_ref; 
        } 

        // Update last_node to point to the last node after sorting 
        this.last_node = previous; 
        
        return this
    }

    function _mergeSort(head) {
        if (head == null || head.next_ref == null) {
            return head  // Список с одним или нулём элементов уже отсортирован
        }
    
        /* Разделение списка на две части. */
        local middle = _findMiddleNode(head)
        local nextToMiddle = middle.next_ref 
        middle.next_ref = null 
    
        /* Рекурсивная сортировка двух половин. */ 
        local left = _mergeSort(head)
        local right = _mergeSort(nextToMiddle) 
    
        /* Слияние отсортированных половин. */
        return _merge(left, right) 
    }
    
    
    function _findMiddleNode(head) {
        local slow = head
        local fast = head.next_ref
        while (fast != null && fast.next_ref != null) {
            slow = slow.next_ref
            fast = fast.next_ref.next_ref 
        }
        return slow 
    }
    
    
    function _merge(left, right) {
        local dummyHead = ListNode(null)
        local current = dummyHead
    
        while (left != null && right != null) {
            if (left.value <= right.value) {
                current.next_ref = left
                left = left.next_ref 
            } else {
                current.next_ref = right
                right = right.next_ref 
            } 
            current = current.next_ref
        } 
    
        /* Добавление оставшихся элементов. */
        current.next_ref = left != null ? left : right
    
        return dummyHead.next_ref 
    }


    /*
     * Removes all elements from the list.
    */
    function clear() {
        this.first_node.next_ref = null;
        this.last_node = this.first_node;
        this.length = 0;
    }

    /*
     * Joins the elements of the list into a string, separated by the specified delimiter.
     * 
     * @param {string} joinstr - The delimiter to use between elements. (optional, default="")
     * @returns {string} - The joined string.
    */
    function join(joinstr = "") {
        if(this.length == 0) return ""
        
        local string = ""
        foreach(elem in this) {
            string += elem + joinstr
        }
        return joinstr.len() != 0 ? string.slice(0, joinstr.len() * -1) : string
    }

    /*
    * Apply a function to each element and modify the list in-place.
    *
    * @param {Function} func - The function to apply.
    * @returns {List} - The List instance for chaining.
    */
    function apply(func) {
        foreach(idx, value in this) {
            this[idx] = func(value)
        }
        return this
    }

    /*
     * Extends the list by appending all elements from another iterable.
     * 
     * @param {iterable} other - The iterable to append elements from.
     * @returns {List} - The List instance for chaining.
    */
    function extend(other) {
        foreach(val in other) 
            this.append(val)
        return this
    }

    /*
     * Searches for a value or a matching element in the list.
     * 
     * @param {any|Function} match - The value to search for or a predicate function.
     * @returns {number|null} - The index of the match or null if not found.
    */
    function search(match) {
        if(typeof match == "function") {
            foreach(idx, val in this) {
                if(match(val))
                    return idx
            }
        }
        else {
            foreach(idx, val in this) {
                if(val == match)
                    return idx
            }
        }

        return null
    }

    // function binarySearch(value) {
    //     this.sort() // Сортировка списка перед поиском

    //     local low = 0
    //     local high = this.length - 1
    //     local mid

    //     while (low <= high) {
    //         mid = floor((low + high) / 2)
    //         if (this[mid] < value) {
    //             low = mid + 1
    //         } else if (this[mid] > value) {
    //             high = mid - 1 
    //         } else {
    //             return mid  // Элемент найден 
    //         }
    //     }

    //     return null  // Элемент не найден 
    // }

    /*
     * Creates a new list by applying a function to each element of this list.
     * 
     * @param {Function} func - The function to apply to each element.
     * @returns {List} - The new list with the mapped values.
    */
    function map(func) {
        local newList = List()
        foreach(value in this) {
            newList.append(func(value))
        }
        return newList
    }

    /*
     * Converts the list to an array.
     * 
     * @returns {array} - An array containing the elements of the list.
    */
    function toarray() {
        local array = arrayLib(array(this.length))
        foreach(idx, value in this) {
            array[idx] = value
        }
        return array
    }

    // Metamethods
    function _tostring() return format("List: [%s]", this.join(", "))
    function _typeof () return "List";
    function _get(idx) return this.getNode(idx).value;
    function _set(idx, val) return this.getNode(idx).value = val

    function _nexti(previdx) {
        if(this.len() == 0) return null
        if (previdx == null) return 0;
        return previdx < this.len() - 1 ? previdx + 1 : null;
    }

    function _cmp(other) { // lmao, why? :O
        local thisSum = 0;
        local otherSum = 0;
        foreach (val in this) { thisSum += val.value; }
        foreach (val in other) { otherSum += val.value; }

        if (thisSum > otherSum) {
            return 1;
        } else if (thisSum < otherSum) {
            return -1;
        } else {
            return 0; 
        }
    }
}
/*
 * A node in an AVL tree.
*/
 ::treeNode <- class {
    // The value stored in the node. 
    value = null;
    // The left child node. 
    l = null;
    // The right child node. 
    r = null; 
    // The height of the node. 
    h = 1; 

    /*
     * Constructor for a tree node.
     *
     * @param {any} value - The value to store in the node.
    */
    constructor(value) {
        this.value = value;
    }

    function _tostring() return format("treeNode(%i)", this.value);
    
    function _typeof() return "treeNode"
}

/*
 * An AVL tree implementation.
 *
 * An AVL tree is a self-balancing binary search tree where the heights of the two child subtrees of any node differ by at most one.
*/
::AVLTree <- class {
    // The root node of the tree. 
    root = null;
    // The number of nodes in the tree. 
    size = 0;
    // A cache of the inorder traversal of the tree. 
    inorderCache = null;

    /*
     * Constructor for an AVL tree.
     *
     * @param {...any} vargv - The initial values to add to the tree.
    */
    constructor(...) {
        for (local i = 0; i < vargc; i++) {
            this.insert(vargv[i]);
        }
    }

    /*
     * Creates a new AVL tree from an array.
     * 
     * @param {array} array - The array to create the tree from.
     * @returns {AVLTree} - The new tree containing the elements from the array.
    */
    function fromArray(array) {
        local tree = AVLTree()
        foreach(val in array) 
            tree.insert(val)
        return tree
    }

    // --- Basic Methods ---

    /*
     * Gets the number of nodes in the tree.
     *
     * @returns {number} - The number of nodes in the tree.
    */
    function len() {
        return this.size;
    }

    /*
     * Converts the tree to an array using inorder traversal.
     *
     * @returns {arrayLib} - An array containing the tree nodes in ascending order.
    */
    function toArray() { 
        if(this.inorderCache == null) 
            this.inorderCache = this.inorderTraversal()

        return this.inorderCache
    }

    /*
     * Converts the tree to a list using inorder traversal.
     *
     * @returns {List} - A list containing the tree nodes in ascending order.
    */
    function tolist() {
        local result = List();
        this._inorder(this.root, result);
        return result;
    }

    function _tostring() {
        local values = this.toArray()
        return format("AVLTree: {%s}", values.join(", "));
    }

    function _typeof() {
        return "AVLTree";
    }

    function _get(idx) {
        local values = this.toArray()
        if (idx < 0 || idx >= values.len()) {
            throw Error("the index '" + idx + "' does not exist");
        }
        return values[idx];
    }

    function _nexti(previdx) {
        local len = this.len();
        if (len == 0) return null;
        if (previdx == null) return 0;
        return previdx < len - 1 ? previdx + 1 : null;
    }

    // --- Insertion Methods --- 

    /*
     * Inserts a new node with the given key into the tree.
     *
     * @param {any} key - The key of the node to insert.
    */
    function insert(key) {
        this.root = this._insert(this.root, key);
        this.size++
        this.inorderCache = null;
    }

    /*
     * Recursive helper function for inserting a node into the tree.
     *
     * @param {treeNode|null} node - The current node being examined.
     * @param {any} key - The key of the node to insert.
     * @returns {treeNode} - The root node of the subtree after insertion.
    */
    function _insert(node, key) {
        if (node == null) {
            return treeNode(key);
        } else if (key < node.value) {
            node.l = _insert(node.l, key);
        } else {
            node.r = _insert(node.r, key);
        }
    
        // Update height
        node.h = 1 + math.max(_getHeight(node.l), _getHeight(node.r));

        // Update the balance factor and balance the tree
        local balanceFactor = _balanceFactor(node);

        // Left Left Case
        if (balanceFactor > 1 && key < node.l.value) {
            return _rRotate(node);
        }

        // Right Right Case
        if (balanceFactor < -1 && key > node.r.value) {
            return _lRotate(node);
        }

        // Left Right Case
        if (balanceFactor > 1 && key > node.l.value) {
            node.l = _lRotate(node.l);
            return _rRotate(node);
        }

        // Right Left Case
        if (balanceFactor < -1 && key < node.r.value) {
            node.r = _rRotate(node.r);
            return _lRotate(node);
        }

        return node;
    }

    // --- Balancing Methods ---

    /*
     * Performs a left rotation on the given node.
     *
     * @param {treeNode} x - The node to rotate.
     * @returns {treeNode} - The new root node of the subtree after rotation.
    */
    function _lRotate(x) {
        local y = x.r;
        local T2 = y.l;

        y.l = x;
        x.r = T2;

        x.h = 1 + math.max(_getHeight(x.l), _getHeight(x.r));
        y.h = 1 + math.max(_getHeight(y.l), _getHeight(y.r));

        return y;
    }

    /*
     * Performs a right rotation on the given node.
     *
     * @param {treeNode} x - The node to rotate.
     * @returns {treeNode} - The new root node of the subtree after rotation.
    */
    function _rRotate(x) {
        local y = x.l;
        local T3 = y.r;

        y.r = x;
        x.l = T3;

        x.h = 1 + math.max(_getHeight(x.l), _getHeight(x.r));
        y.h = 1 + math.max(_getHeight(y.l), _getHeight(y.r));

        return y;
    }

    // --- Height & Balance Methods ---

    /*
     * Gets the height of a node.
     *
     * @param {treeNode|null} node - The node to get the height of.
     * @returns {number} - The height of the node, or 0 if the node is null. 
    */
    function _getHeight(node) {
        if (node == null) {
            return 0;
        }
        return node.h;
    }

    /*
     * Gets the balance factor of a node.
     *
     * The balance factor is the difference in height between the left and right subtrees of the node.
     *
     * @param {treeNode|null} node - The node to get the balance factor of.
     * @returns {number} - The balance factor of the node.
    */
    function _balanceFactor(node) {
        if (node == null) {
            return 0;
        }
        return _getHeight(node.l) - _getHeight(node.r);
    }

    // --- Search Methods ---

    /*
     * Searches for a node with the given value in the tree.
     *
     * @param {any} value - The value to search for.
     * @returns {treeNode|null} - The node with the matching value, or null if not found.
    */
    function search(value) {
        return this._search(this.root, value);
    }

    /*
     * Recursive helper function for searching for a node in the tree.
     *
     * @param {treeNode|null} node - The current node being examined.
     * @param {any} value - The value to search for.
     * @returns {treeNode|null} - The node with the matching value, or null if not found. 
    */
    function _search(node, value) {
        if (!node || node.value == value) {
            return node;
        }

        if (value < node.value) {
            return this._search(node.l, value);
        } else {
            return this._search(node.r, value);
        }
    }

    // --- Removal Methods  ---

    /*
     * Removes the node with the given value from the tree.
     *
     * @param {any} value - The value of the node to remove.
    */
    function remove(value) {
        this.root = this._remove(this.root, value);
        this.size--
        this.inorderCache = null
    }

    /*
     * Recursive helper function for removing a node from the tree.
     *
     * @param {treeNode|null} node - The current node being examined.
     * @param {any} value - The value of the node to remove. 
     * @returns {treeNode|null} - The root node of the subtree after removal.
    */
    function _remove(node, value) {
        if (!node) {
            return null;
        }

        if (value < node.value) {
            node.l = this._remove(node.l, value);
        } else if (value > node.value) {
            node.r = this._remove(node.r, value);
        } else {
            // Node found, handle deletion based on number of children
            if (!node.l || !node.r) {
                local temp = node.l ? node.l : node.r;
                node = temp; // Replace node with its child
            } else {
                // Node has two children, find inorder successor
                local temp = this.min(node.r);
                node.value = temp.value;
                node.r = this._remove(node.r, temp.value);
            }
        }

        if (!node) {
            return node;
        }

        // Balance the tree
        node.h = 1 + math.max(_getHeight(node.l), _getHeight(node.r));

        local balanceFactor = _balanceFactor(node);

        // Balance the tree
        // Left Left Case
        if (balanceFactor > 1 && _balanceFactor(node.l) >= 0) {
            return _rRotate(node);
        }

        // Left Right Case
        if (balanceFactor > 1 && _balanceFactor(node.l) < 0) {
            node.l = _lRotate(node.l);
            return _rRotate(node);
        }

        // Right Right Case
        if (balanceFactor < -1 && _balanceFactor(node.r) <= 0) {
            return _lRotate(node);
        }

        // Right Left Case
        if (balanceFactor < -1 && _balanceFactor(node.r) > 0) {
            node.r = _rRotate(node.r);
            return _lRotate(node);
        }

        return node;
    }

    // --- Min/Max Methods ---

    /*
     * Gets the minimum value in the tree.
     *
     * @returns {any} - The minimum value in the tree.
    */
    function GetMin() return this.min(this.root).value
    
    /*
     * Gets the maximum value in the tree.
     *
     * @returns {any} - The maximum value in the tree.
    */
    function GetMax() return this.max(this.root).value

    function min(node) {
        local current = node;
        while (current && current.l) {
            current = current.l;
        }
        return current;
    }

    function max(node) {
        local current = node;
        while (current && current.r) {
            current = current.r;
        }
        return current;
    }

    // --- Traversal Methods ---

    /*
     * Performs an inorder traversal of the tree and returns the nodes in ascending order.
     *
     * @returns {arrayLib} - An array containing the tree nodes in ascending order.
    */
    function inorderTraversal() {
        local result = arrayLib.new();
        this._inorder(this.root, result);
        return result;
    }

    /*
     * Recursive helper function for inorder traversal.
     *
     * @param {treeNode|null} node - The current node being visited.
     * @param {arrayLib} result - The array to store the traversed nodes. 
    */
    function _inorder(node, result) {
        if (node) {
            this._inorder(node.l, result);
            result.append(node.value);
            this._inorder(node.r, result);
        }
    }

    // Print the tree
    function printTree() return this._print(this.root, "", true)

    function _print(currPtr, indent, last) {
        if(currPtr != null) {
            print(indent)
            if(last) {
                print("R----")
                indent += "     "
            }
            else {
                print("L----")
                indent += "|    "
            }
            printl(currPtr.value)
            this._print(currPtr.l, indent, false)
            this._print(currPtr.r, indent, true)
        }
    }
}


/*+--------------------------------------------------------------------------------+
|                           PCapture Vscripts Library                              |
+----------------------------------------------------------------------------------+
| Author:                                                                          |
|     Ray Tracing Virtuoso - laVashik ˙▿˙                                          |
+----------------------------------------------------------------------------------+
|       The TracePlus module, taking ray tracing to the next level with advanced   |
|       features like portal support and precise collision detection algorithms.   |
+----------------------------------------------------------------------------------+ */

::TracePlus <- {
    Result = {},
    Portals = {},
    FromEyes = {},

    Settings = null,
    defaultSettings = null,

    Cheap = null,
    Bbox = null,
}

const MAX_PORTAL_CAST_DEPTH = 7

local results = TracePlus["Result"]

results["Cheap"] <- class {
    traceHandler = null;
    hitpos = null;

    surfaceNormal = null;
    portalEntryInfo = null;

    /*
     * Constructor for a CheapTraceResult object.
     *
     * @param {table} traceHandler - The trace handler object containing trace information.
     * @param {Vector} hitpos - The hit position of the trace.
    */
    constructor(traceHandler, hitpos) {
        this.traceHandler = traceHandler
        this.hitpos = hitpos
    }

    /*
     * Gets the start position of the trace.
     *
     * @returns {Vector} - The start position.
    */
    function GetStartPos() {
        return this.traceHandler.startpos
    }

    /*
     * Gets the end position of the trace.
     *
     * @returns {Vector} - The end position.
    */
    function GetEndPos() {
        return this.traceHandler.endpos
    }

    /*
     * Gets the hit position of the trace.
     *
     * @returns {Vector} - The hit position. 
    */
    function GetHitpos() {
        return this.hitpos
    }

    /*
     * Gets the fraction of the trace distance where the hit occurred.
     *
     * @returns {number} - The hit fraction.
    */
    function GetFraction() {
        return this.traceHandler.fraction
    }

    /*
     * Checks if the trace hit anything.
     *
     * @returns {boolean} - True if the trace hit something, false otherwise.
    */
    function DidHit() {
        return this.traceHandler.fraction != 1
    }

    /*
     * Gets the direction vector of the trace.
     *
     * @returns {Vector} - The direction vector.
    */
    function GetDir() {
        return (this.GetEndPos() - this.GetStartPos())
    }

    /*
     * Gets the portal entry information for the trace.
     * 
     * @returns {CheapTraceResult|null} - The portal entry information, or null if not available.
    */
    function GetPortalEntryInfo() {
        return this.portalEntryInfo
    }

    /*
     * Gets an array of all portal entry information for the trace, including nested portals.
     * 
     * @returns {arrayLib} - An array of CheapTraceResult objects representing portal entries.
    */
    function GetAggregatedPortalEntryInfo() {
        local arr = arrayLib([])
        arr.append(trace)
        for(local trace = this; trace = trace.portalEntryInfo;) {
            arr.append(trace)
        }
        return arr
    }

    /*
     * Gets the impact normal of the surface hit by the trace.
     *
     * @returns {Vector} - The impact normal vector.
    */
    function GetImpactNormal() {
        // If the surface normal is already calculated, return it
        if(this.surfaceNormal)
            return this.surfaceNormal
        
        this.surfaceNormal = CalculateImpactNormal(this.GetStartPos(), this.hitpos, this)
        return this.surfaceNormal 
    } 

    function _typeof() return "TraceResult"
    function _tostring() {
        return "TraceResult | startpos: " + GetStartPos() + ", endpos: " + GetEndPos() + ", fraction: " + GetFraction() + ", hitpos: " + GetHitpos()
    }
}



// Don't forget, the class extension is broken in VScripts
// Valvo's, I hate u :<
results["Bbox"] <- class {
    traceHandler = null;
    hitpos = null;
    hitent = null;

    surfaceNormal = null;
    portalEntryInfo = null;

    /*
     * Constructor for a BboxTraceResult object.
     *
     * @param {table} traceHandler - The trace handler object containing trace information.
     * @param {Vector} hitpos - The hit position of the trace.
     * @param {CBaseEntity} hitent - The entity hit by the trace.
    */
    constructor(traceHandler, hitpos, hitent) {
        this.traceHandler = traceHandler
        this.hitpos = hitpos
        this.hitent = hitent
    }

    /*
     * Gets the start position of the trace.
     *
     * @returns {Vector} - The start position.
    */
    function GetStartPos() {
        return this.traceHandler.startpos
    }

    /*
     * Gets the end position of the trace.
     *
     * @returns {Vector} - The end position.
    */
    function GetEndPos() {
        return this.traceHandler.endpos
    }

    /*
     * Gets the hit position of the trace.
     *
     * @returns {Vector} - The hit position. 
    */
    function GetHitpos() {
        return this.hitpos
    }

    /*
     * Gets the entity hit by the trace.
     *
     * @returns {pcapEntity|null} - The hit entity, or null if no entity was hit.
    */
    function GetEntity() {
        if(this.hitent && this.hitent.IsValid())
            return entLib.FromEntity(this.hitent)
    }

    /*
     * Gets the classname of the entity hit by the trace.
     *
     * @returns {string|null} - The classname of the hit entity, or null if no entity was hit.
    */
    function GetEntityClassname() {
        return this.hitent ? this.GetEntity().GetClassname() : null 
    }

    /*
     * Gets the list of entities that were ignored during the trace. 
     *
     * @returns {array|CBaseEntity|null} - The list of ignored entities, or null if no entities were ignored.
    */
    function GetIngoreEntities() {
        return this.traceHandler.ignoreEntities
    }

    /*
     * Gets the settings used for the trace.
     *
     * @returns {TraceSettings} - The trace settings object. 
    */
    function GetTraceSettings() {
        return this.traceHandler.settings
    }

    /*
     * Gets the note associated with the trace.
     *
     * @returns {string|null} - The trace note, or null if no note was provided.
    */
    function GetNote() {
        return this.traceHandler.note
    }

    /*
     * Checks if the trace hit anything.
     *
     * @returns {boolean} - True if the trace hit something, false otherwise.
    */
    function DidHit() {
        return this.GetFraction() != 1
    }

    /*
     * Checks if the trace hit the world geometry (not an entity). 
     *
     * @returns {boolean} - True if the trace hit the world, false otherwise.
    */
    function DidHitWorld() {
        return !this.hitent && DidHit()
    }

    /*
     * Gets the fraction of the trace distance where the hit occurred.
     *
     * @returns {number} - The hit fraction. 
    */
    function GetFraction() {
        return macros.GetDist(this.GetStartPos(), this.GetHitpos()) / macros.GetDist(this.GetStartPos(), this.GetEndPos())
    }

    /*
     * Gets the direction vector of the trace.
     *
     * @returns {Vector} - The direction vector.
    */
    function GetDir() {
        return (this.GetEndPos() - this.GetStartPos())
    }

    /*
     * Gets the portal entry information for the trace. 
     * 
     * @returns {BboxTraceResult|null} - The portal entry information, or null if not available.
    */
    function GetPortalEntryInfo() {
        return this.portalEntryInfo
    }

    /*
     * Gets an array of all portal entry information for the trace, including nested portals.
     * 
     * @returns {arrayLib} - An array of BboxTraceResult objects representing portal entries.
    */
    function GetAggregatedPortalEntryInfo() {
        local arr = arrayLib([])
        arr.append(this)
        for(local trace = this; trace = trace.portalEntryInfo;) {
            arr.append(trace)
        }
        return arr.reverse()
    }

    /*
     * Gets the impact normal of the surface hit by the trace.
     *
     * @returns {Vector} - The impact normal vector.
    */
    function GetImpactNormal() {
        // If the surface normal is already calculated, return it
        if(this.surfaceNormal)
            return this.surfaceNormal

        local hitEnt = this.GetEntity()
        if(hitEnt) {
            this.surfaceNormal = CalculateImpactNormalFromBbox(this.GetStartPos(), this.hitpos, hitEnt)
        } else {
            this.surfaceNormal = CalculateImpactNormal(this.GetStartPos(), this.hitpos, this)
        }

        return this.surfaceNormal
    } 

    function _typeof() return "BboxTraceResult"
    function _tostring() {
        return "TraceResult | startpos: " + GetStartPos() + ", endpos: " + GetEndPos() + ", hitpos: " + GetHitpos() + ", entity: " + GetEntity()
    }
}
/*
 * Settings for ray traces.
*/
 TracePlus["Settings"] <- class {
    // An array of entity classnames to ignore during traces. 
    ignoreClasses = arrayLib.new("viewmodel", "weapon_", "beam",
        "trigger_", "phys_", "env_", "point_", "info_", "vgui_", "logic_",
        "clone", "prop_portal", "portal_base2D"
    );
    // An array of entity classnames to prioritize during traces.  
    priorityClasses = arrayLib.new();
    // An array of entity model names to ignore during traces. 
    ignoredModels = arrayLib.new();

    // The maximum allowed distance between a trace's start and hit positions. 
    errorTolerance = 500; 

    // A custom function to determine if a ray should hit an entity. 
    shouldRayHitEntity = null;
    // A custom function to determine if an entity should be ignored during a trace. 
    shouldIgnoreEntity = null;


    /*
     * Constructor for TraceSettings.
     *
     * @param {arrayLib} ignoreClasses - An array of entity classnames to ignore.
     * @param {arrayLib} priorityClasses - An array of entity classnames to prioritize. 
     * @param {arrayLib} ignoredModels - An array of entity model names to ignore.
     * @param {number} errorTolerance - The maximum allowed distance between trace start and hit positions.
     * @param {function} shouldRayHitEntity - A custom function to determine if a ray should hit an entity.
     * @param {function} shouldIgnoreEntity - A custom function to determine if an entity should be ignored. 
    */
    constructor(ignoreClasses, priorityClasses, ignoredModels, errorTolerance, shouldRayHitEntity, shouldIgnoreEntity) {
        this.ignoreClasses = ignoreClasses
        this.priorityClasses = priorityClasses
        this.ignoredModels = ignoredModels
        this.errorTolerance = errorTolerance
        this.shouldRayHitEntity = shouldRayHitEntity
        this.shouldIgnoreEntity = shouldIgnoreEntity
    }

    /*
     * Creates a new TraceSettings object with default values or from a table of settings. 
     * 
     * @param {table} settingsTable - A table containing settings to override the defaults. (optional)
     * @returns {TraceSettings} - A new TraceSettings object.
    */
    function new(settingsTable = {}) {
        // Get the ignoreClasses setting from the settings table or use the default. 
        local ignoreClasses = arrayLib(macros.GetFromTable(settingsTable, "ignoreClasses", clone(TracePlus.Settings.ignoreClasses)))
        // Get the priorityClasses setting from the settings table or use the default. 
        local priorityClasses = arrayLib(macros.GetFromTable(settingsTable, "priorityClasses", clone(TracePlus.Settings.priorityClasses)))
        // Get the ignoredModels setting from the settings table or use the default. 
        local ignoredModels = arrayLib(macros.GetFromTable(settingsTable, "ignoredModels", clone(TracePlus.Settings.ignoredModels)))
        
        // Get the errorTolerance setting from the settings table or use the default. 
        local errorTolerance = macros.GetFromTable(settingsTable, "errorTolerance", TracePlus.Settings.errorTolerance)
        // Get the shouldRayHitEntity setting from the settings table or use the default.  
        local shouldRayHitEntity = macros.GetFromTable(settingsTable, "shouldRayHitEntity", null)
        // Get the shouldIgnoreEntity setting from the settings table or use the default. 
        local shouldIgnoreEntity = macros.GetFromTable(settingsTable, "shouldIgnoreEntity", null)
        
        // Create and return a new TraceSettings object with the specified or default settings. 
        return TracePlus.Settings(
            ignoreClasses, priorityClasses, ignoredModels, 
            errorTolerance, shouldRayHitEntity, shouldIgnoreEntity
        )
    }


    /*
     * Sets the list of entity classnames to ignore during traces.
     *
     * @param {array|arrayLib} ignoreClassesArray - An array or arrayLib containing entity classnames to ignore. 
    */
    function SetIgnoredClasses(ignoreClassesArray) {
        this.ignoreClasses = arrayLib(ignoreClassesArray)
    }

    /*
     * Sets the list of entity classnames to prioritize during traces.
     *
     * @param {array|arrayLib} priorityClassesArray - An array or arrayLib containing entity classnames to prioritize. 
    */
    function SetPriorityClasses(priorityClassesArray) {
        this.priorityClasses = arrayLib(priorityClassesArray)
    }

    /*
     * Sets the list of entity model names to ignore during traces.
     *
     * @param {array|arrayLib} ignoredModelsArray - An array or arrayLib containing entity model names to ignore. 
    */
    function SetIgnoredModels(ignoredModelsArray) {
        this.ignoredModels = arrayLib(ignoredModelsArray)
    }

    /*
     * Sets the maximum allowed distance between trace start and hit positions. 
     *
     * @param {number} tolerance - The maximum allowed distance in units. 
    */
    function SetErrorTolerance(tolerance) {
        this.errorTolerance = tolerance
    }


    /*
     * Appends an entity classname to the list of ignored classes. 
     *
     * @param {string} className - The classname to append. 
    */
    function AppendIgnoredClass(className) {
        this.ignoreClasses.append(className)
    }

    /*
     * Appends an entity classname to the list of priority classes. 
     *
     * @param {string} className - The classname to append. 
    */
    function AppendPriorityClasses(className) {
        this.priorityClasses.append(className)
    }

    /*
     * Appends an entity model name to the list of ignored models. 
     *
     * @param {string} modelName - The model name to append. 
    */
    function AppendIgnoredModel(modelName) {
        this.ignoredModels.append(modelName)
    }



    /* 
     * Gets the list of entity classnames to ignore during traces. 
     *
     * @returns {arrayLib} - An arrayLib containing the ignored classnames. 
    */
    function GetIgnoreClasses() {
        return this.ignoreClasses
    }

    /*
     * Gets the list of entity classnames to prioritize during traces. 
     *
     * @returns {arrayLib} - An arrayLib containing the priority classnames. 
    */
    function GetPriorityClasses() {
        return this.priorityClasses
    }

    /*
     * Gets the list of entity model names to ignore during traces. 
     *
     * @returns {arrayLib} - An arrayLib containing the ignored model names. 
    */
    function GetIgnoredModels() {
        return this.ignoredModels
    }

    /*
     * Gets the maximum allowed distance between trace start and hit positions. 
     *
     * @returns {number} - The maximum allowed distance in units. 
    */
    function GetErrorTolerance() {
        return this.errorTolerance
    }


    /*
     * Sets a custom function to determine if a ray should hit an entity. 
     *
     * @param {function} filterFunction - The filter function to set. 
    */
    function SetCollisionFilter(filterFunction) { // aka. SetHitFilter
        this.shouldRayHitEntity = filterFunction
    }

    /*
     * Sets a custom function to determine if an entity should be ignored during a trace. 
     *
     * @param {function} filterFunction - The filter function to set. 
    */
    function SetIgnoreFilter(filterFunction) {
        this.shouldIgnoreEntity = filterFunction
    }

    /*
     * Gets the custom collision filter function. 
     *
     * @returns {function|null} - The collision filter function, or null if not set. 
    */
    function GetCollisionFilter() {
        return this.shouldRayHitEntity
    }

    /*
     * Gets the custom ignore filter function. 
     *
     * @returns {function|null} - The ignore filter function, or null if not set. 
    */
    function GetIgnoreFilter() {
        return this.shouldIgnoreEntity
    }

    /*
     * Applies the custom collision filter function to an entity. 
     *
     * @param {CBaseEntity|pcapEntity} entity - The entity to check.
     * @param {string|null} note - An optional note associated with the trace.
     * @returns {boolean} - True if the ray should hit the entity, false otherwise. 
    */
    function ApplyCollisionFilter(entity, note) {
        return this.shouldRayHitEntity ? this.shouldRayHitEntity(entity, note) : false
    }

    /*
     * Applies the custom ignore filter function to an entity. 
     *
     * @param {CBaseEntity|pcapEntity} entity - The entity to check.
     * @param {string|null} note - An optional note associated with the trace.
     * @returns {boolean} - True if the entity should be ignored, false otherwise. 
    */
    function ApplyIgnoreFilter(entity, note) {
        return this.shouldIgnoreEntity ? this.shouldIgnoreEntity(entity, note) : false
    }

    /*
     * Updates the list of entities to ignore during a trace, including the player entity.
     *
     * @param {array|CBaseEntity|null} ignoreEntities - The current list of entities to ignore.
     * @param {CBaseEntity|pcapEntity} newEnt - The new entity to add to the ignore list.
     * @returns {array} - The updated list of entities to ignore. 
    */
    function UpdateIgnoreEntities(ignoreEntities, newEnt) {
        // Check if any entities should be ignored during the trace 
        if (ignoreEntities) {
            // If ignoreEntities is an array, append the player entity to it 
            if (typeof ignoreEntities == "array" || typeof ignoreEntities == "arrayLib") {
                ignoreEntities.append(newEnt)
            }
            // If ignoreEntities is a single entity, create a new array with both the player and ignoreEntities 
            else {
                ignoreEntities = [newEnt, ignoreEntities]
            }
        }
        // If no ignoreEntities is provided, ignore the player only 
        else {
            ignoreEntities = newEnt
        }

        return ignoreEntities
    }

    function _typeof() return "TraceSettings"
    function _cloned() {
        return Settings(
            clone this.ignoreClasses, clone this.priorityClasses, clone this.ignoredModels, 
            this.errorTolerance, this.shouldRayHitEntity, this.shouldIgnoreEntity
        )
    }
}
TracePlus.defaultSettings = TracePlus.Settings.new()

// Haha, pseudo-constuctor-class
/*
 * Performs a cheap (fast but less accurate) trace.
 *
 * @param {Vector} startpos - The start position of the trace.
 * @param {Vector} endpos - The end position of the trace. 
 * @returns {CheapTraceResult} - The trace result object.
*/
 TracePlus["Cheap"] <- function(startpos, endpos) {
    local SCOPE = {}

    SCOPE.startpos <- startpos
    SCOPE.endpos <- endpos
    // SCOPE.type <- "CheapTrace"

    SCOPE.fraction <- TraceLine(startpos, endpos, null)
    local hitpos = startpos + (endpos - startpos) * SCOPE.fraction

    return TracePlus.Result.Cheap(SCOPE, hitpos)
}


/* 
 * Performs a cheap trace from the player's eyes. 
 *
 * @param {number} distance - The distance of the trace. 
 * @param {CBaseEntity|pcapEntity} player - The player entity.
 * @returns {CheapTraceResult} - The trace result object.
*/
TracePlus["FromEyes"]["Cheap"] <- function(distance, player) {
    // Calculate the start and end positions of the trace
    local startpos = player.EyePosition()
    local endpos = macros.GetEyeEndpos(player, distance)

    return TracePlus.Cheap(startpos, endpos)
}
/*
 * Performs a bbox cast (trace with bounding box) from the specified start and end positions. 
 *
 * @param {Vector} startPos - The start position of the trace.
 * @param {Vector} endPos - The end position of the trace.
 * @param {array|CBaseEntity|null} ignoreEntities - A list of entities or a single entity to ignore during the trace. (optional)
 * @param {TraceSettings} settings - The settings to use for the trace. (optional, defaults to TracePlus.defaultSettings) 
 * @param {string|null} note - An optional note associated with the trace. 
 * @returns {BboxTraceResult} - The trace result object. 
*/
 TracePlus["Bbox"] <- function(startPos, endPos, ignoreEntities = null, settings = TracePlus.defaultSettings, note = null) {
    local SCOPE = {} // TODO potential place for improvement
    
    SCOPE.startpos <- startPos;
    SCOPE.endpos <- endPos;
    SCOPE.ignoreEntities <- ignoreEntities 
    SCOPE.settings <- settings
    SCOPE.note <- note
    // SCOPE.type <- "BboxCast"

    local result = TraceLineAnalyzer(startPos, endPos, ignoreEntities, settings, note)
    
    return TracePlus.Result.Bbox(SCOPE, result.GetHitpos(), result.GetEntity())
}

/*
 * Performs a bbox cast from the player's eyes. 
 *
 * @param {number} distance - The distance of the trace. 
 * @param {CBaseEntity|pcapEntity} player - The player entity.
 * @param {array|CBaseEntity|null} ignoreEntities - A list of entities or a single entity to ignore during the trace. (optional)
 * @param {TraceSettings} settings - The settings to use for the trace. (optional, defaults to TracePlus.defaultSettings) 
 * @returns {BboxTraceResult} - The trace result object. 
*/
TracePlus["FromEyes"]["Bbox"] <- function(distance, player, ignoreEntities = null, settings = TracePlus.defaultSettings) {
    // Calculate the start and end positions of the trace
    local startPos = player.EyePosition()
    local endPos = macros.GetEyeEndpos(player, distance)

    ignoreEntities = TracePlus.Settings.UpdateIgnoreEntities(ignoreEntities, player)

    // Perform the bboxcast trace and return the trace result
    return TracePlus.Bbox(startPos, endPos, ignoreEntities, settings)
}
/*
 * Applies portal transformations to a trace, calculating a new start and end position for the trace after passing through the portal. 
 *
 * @param {Vector} startPos - The original start position of the trace. 
 * @param {Vector} hitPos - The hit position of the trace on the portal. 
 * @param {pcapEntity} portal - The portal entity. 
 * @param {pcapEntity} partnerPortal - The partner portal entity. 
 * @returns {table} - A table containing the new startPos and endPos for the trace after passing through the portal. 
*/ 
 local applyPortal = function(startPos, hitPos, portal, partnerPortal) {
    local portalAngles = portal.GetAngles();
    local partnerAngles = partnerPortal.GetAngles();
    local offset = math.vector.unrotate(hitPos - portal.GetOrigin(), portalAngles);
    local dir = math.vector.unrotate(hitPos - startPos, portalAngles);

    offset = Vector(offset.x * -1, offset.y * -1, offset.z)
    dir = Vector(dir.x * -1, dir.y * -1, dir.z)

    dir = math.vector.rotate(dir, partnerAngles)
    dir.Norm()

    local newStart = partnerPortal.GetOrigin() + math.vector.rotate(offset, partnerAngles)
    return {
        startPos = newStart,
        endPos = newStart + dir * 4096
    }
}


/*
 * Performs a cheap trace with portal support. 
 * 
 * @param {Vector} startPos - The start position of the trace.
 * @param {Vector} endPos - The end position of the trace.  
 * @returns {CheapTraceResult} - The trace result object, including information about portal entries.
*/
TracePlus["PortalCheap"] <- function(startPos, endPos) : (applyPortal) {
    local previousTraceData 
    // Portal castings
    for (local i = 0; i < MAX_PORTAL_CAST_DEPTH; i++) {
        local traceData = TracePlus.Cheap(startPos, endPos)
        traceData.portalEntryInfo = previousTraceData

        local hitPos = traceData.GetHitpos()

        // Find a nearby portal entity. 
        local portal = entLib.FindByClassnameWithin("prop_portal", hitPos, 1) 
        if(!portal)
            portal = entLib.FindByClassnameWithin("linked_portal_door", hitPos, 1)
        if(!portal)
            return traceData

        local normal = traceData.GetImpactNormal()
        if(normal.Dot(portal.GetForwardVector()) < 0.8)
            return traceData
        
        local partnerPortal = portal.GetPartnerInstance()
        if (partnerPortal == null) {
            return traceData 
        }

        // Calculate new start and end positions for the trace after passing through the portal. 
        local ray = applyPortal(startPos, hitPos, portal, partnerPortal);
        // Adjust the start position slightly to prevent the trace from getting stuck.  
        startPos = ray.startPos + partnerPortal.GetForwardVector() 
        endPos = ray.endPos
        previousTraceData = traceData
    }
    return previousTraceData
}

/*
 * Performs a cheap trace with portal support from the player's eyes. 
 *
 * @param {number} distance - The distance of the trace. 
 * @param {CBaseEntity|pcapEntity} player - The player entity.
 * @returns {CheapTraceResult} - The trace result object.
*/
 TracePlus["FromEyes"]["PortalCheap"] <- function(distance, player) {
    // Calculate the start and end positions of the trace
    local startpos = player.EyePosition()
    local endpos = macros.GetEyeEndpos(player, distance)

    return TracePlus.PortalCheap(startpos, endpos)
}


/*
 * Performs a bbox cast with portal support. 
 * 
 * @param {Vector} startPos - The start position of the trace.
 * @param {Vector} endPos - The end position of the trace.
 * @param {array|CBaseEntity|null} ignoreEntities - A list of entities or a single entity to ignore during the trace. (optional) 
 * @param {TraceSettings} settings - The settings to use for the trace. (optional, defaults to TracePlus.defaultSettings) 
 * @param {string|null} note - An optional note associated with the trace. 
 * @returns {BboxTraceResult} - The trace result object, including information about portal entries.
*/
TracePlus["PortalBbox"] <- function(startPos, endPos, ignoreEntities = null, settings = TracePlus.defaultSettings, note = null) : (applyPortal) {
    local previousTraceData 
    // Portal castings
    for (local i = 0; i < MAX_PORTAL_CAST_DEPTH; i++) {
        local traceData = TracePlus.Bbox(startPos, endPos, ignoreEntities, settings, note)
        traceData.portalEntryInfo = previousTraceData 

        local hitPos = traceData.GetHitpos()
        local portal = traceData.GetEntity()

        if(!portal || portal.GetClassname() != "linked_portal_door")
            portal = entLib.FindByClassnameWithin("prop_portal", hitPos, 1) // todo: i should optimize it...
        if(!portal) 
            return traceData 
        
        local partnerPortal = portal.GetPartnerInstance()
        if (partnerPortal == null) 
            return traceData 

        if(portal.GetClassname() == "prop_portal") {
            local normal = traceData.GetImpactNormal()
            if(normal.Dot(portal.GetForwardVector()) < 0.8)
                return traceData
        }
        
        ignoreEntities = TracePlus.Settings.UpdateIgnoreEntities(ignoreEntities, partnerPortal)

        // Calculate new start and end positions for the trace after passing through the portal.  
        local ray = applyPortal(startPos, hitPos, portal, partnerPortal);
        // Adjust the start position slightly to prevent the trace from getting stuck. 
        startPos = ray.startPos + partnerPortal.GetForwardVector() 
        endPos = ray.endPos
        previousTraceData = traceData 
    }
    return previousTraceData 
}

/* 
 * Performs a bbox cast with portal support from the player's eyes. 
 *
 * @param {number} distance - The distance of the trace. 
 * @param {CBaseEntity|pcapEntity} player - The player entity.
 * @param {array|CBaseEntity|null} ignoreEntities - A list of entities or a single entity to ignore during the trace. (optional)
 * @param {TraceSettings} settings - The settings to use for the trace. (optional, defaults to TracePlus.defaultSettings) 
 * @returns {BboxTraceResult} - The trace result object. 
*/
 TracePlus["FromEyes"]["PortalBbox"] <- function(distance, player, ignoreEntities = null, settings = TracePlus.defaultSettings) {
    // Calculate the start and end positions of the trace
    local startPos = player.EyePosition()
    local endPos = macros.GetEyeEndpos(player, distance)
    ignoreEntities = TracePlus.Settings.UpdateIgnoreEntities(ignoreEntities, player)

    // Perform the bboxcast trace and return the trace result
    return TracePlus.PortalBbox(startPos, endPos, ignoreEntities, settings)
}



/* 
 * Finds and sets partner portals for linked portal doors and prop portals. 
 * 
 * This function iterates through all entities of class "linked_portal_door" and "prop_portal" and attempts to find their corresponding partner portals. 
 * For linked portal doors, it retrieves the partner instance using GetPartnerInstance() and stores it as user data in both portals. 
 * For prop portals, it assumes the partner portal is the other prop_portal entity in the map and stores it as user data. 
 *
 * Additionally, for linked portal doors, the function extracts bounding box information from the model name (assuming a specific naming convention) 
 * and sets the bounding box of the portal accordingly. 
 * 
 * This function is called automatically at the initialization of the TracePlus module to ensure portal information is available for portal traces. 
 * 
*/
 ::FindPartnersForPortals <- function() {
    // Iterate through all linked_portal_door entities.  
    for(local portal; portal = entLib.FindByClassname("linked_portal_door", portal);) {
        // Skip if the portal already has a partner set. 
        if(portal.GetPartnerInstance())
            continue
    
        // Get the partner portal entity using GetPartnerInstance().  
        local partner = portal.GetPartnerInstance()
        // Store the partner portal as user data in both portals.  
        portal.SetUserData("partner", partner)
    
        // Skip if the portal model name is empty (no bounding box information available).  
        if(portal.GetModelName() == "")
            continue
        
        // Extract bounding box dimensions from the model name (assuming a specific format). 
        local wpInfo = split(portal.GetModelName(), " ")
        // Rotate the bounding box dimensions based on the portal's angles.  
        local wpBBox = math.vector.rotate(Vector(5, wpInfo[0].tointeger(), wpInfo[1].tointeger()), portal.GetAngles())
        wpBBox = math.vector.abs(wpBBox)
        // Set the bounding box of the portal using the calculated dimensions.  
        portal.SetBBox(wpBBox * -1, wpBBox) 
    }
    
    // Iterate through all prop_portal entities.  
    for(local portal; portal = entLib.FindByClassname("prop_portal", portal);) { 
        // Skip if the portal already has a partner set. 
        if(portal.GetPartnerInstance())
            continue
    
        // Determine the model name of the partner portal based on the current portal's model. 
        local mdl = "models/portals/portal1.mdl"
        if(portal.GetModelName().find("portal2") == null) 
            mdl = "models/portals/portal2.mdl"
        
        // Find the partner portal entity based on the determined model name.  
        local partner = entLib.FindByModel(mdl)
        // Store the partner portal as user data in the current portal.  
        portal.SetUserData("partner", partner) 
    }
}

FindPartnersForPortals()

// Expensive/Precise TraceLine logic
/*
 * A class for performing precise trace line analysis. 
 * 
 * This class provides methods for tracing lines with more precision and considering entity priorities and ignore settings. 
*/
 ::TraceLineAnalyzer <- class {
    settings = null;
    hitpos = null;
    hitent = null;

    /*
     * Constructor for TraceLineAnalyzer.
     *
     * @param {Vector} startpos - The start position of the trace.
     * @param {Vector} endpos - The end position of the trace.
     * @param {array|CBaseEntity|null} ignoreEntities - A list of entities or a single entity to ignore during the trace. 
     * @param {TraceSettings} settings - The settings to use for the trace. 
     * @param {string|null} note - An optional note associated with the trace. 
    */ 
    constructor(startpos, endpos, ignoreEntities, settings, note) {
        if(typeof settings != "TraceSettings") throw("Invalid trace settings provided. Expected an instance of TracePlus.Settings")
        this.settings = settings
        
        local result = this.Trace(startpos, endpos, ignoreEntities, note)
        this.hitpos = result[0]
        this.hitent = result[1]
    }

    /*
     * Gets the hit position of the trace. 
     *
     * @returns {Vector} - The hit position. 
    */
    function GetHitpos() {
        return this.hitpos
    }

    /* 
     * Gets the entity hit by the trace. 
     *
     * @returns {CBaseEntity|null} - The hit entity, or null if no entity was hit.
    */
    function GetEntity() {
        return this.hitent
    }

    /* 
     * Performs a precise trace line analysis. 
     *
     * This method subdivides the trace into smaller segments and checks for entity collisions along the way, 
     * considering entity priorities and ignore settings.
     * 
     * @param {Vector} startPos - The start position of the trace.
     * @param {Vector} endPos - The end position of the trace.
     * @param {array|CBaseEntity|null} ignoreEntities - A list of entities or a single entity to ignore during the trace. 
     * @param {string|null} note - An optional note associated with the trace. 
     * @returns {array} - An array containing the hit position and the hit entity (or null). 
    */
    function Trace(startPos, endPos, ignoreEntities, note) array(hitPos, hitEnt) 
    /* 
     * Checks if an entity is a priority entity based on the trace settings.
     *
     * @param {string} entityClass - The classname of the entity. 
     * @returns {boolean} - True if the entity is a priority entity, false otherwise. 
    */
    function _isPriorityEntity() bool
    /* 
     * Checks if an entity should be ignored based on the trace settings. 
     *
     * @param {string} entityClass - The classname of the entity. 
     * @returns {boolean} - True if the entity should be ignored, false otherwise. 
    */
    function _isIgnoredEntity() bool
    /* 
     * Checks if the trace should consider a hit with the given entity.
     * 
     * @param {CBaseEntity} ent - The entity to check.
     * @param {array|CBaseEntity|null} ignoreEntities - A list of entities or a single entity to ignore during the trace. 
     * @param {string|null} note - An optional note associated with the trace. 
     * @returns {boolean} - True if the trace should consider the hit, false otherwise. 
    */
    function shouldHitEntity() bool
}


/*
 * Performs a precise trace line analysis. 
 *
 * This method subdivides the trace into smaller segments and checks for entity collisions along the way, 
 * considering entity priorities and ignore settings.
 * 
 * @param {Vector} startPos - The start position of the trace.
 * @param {Vector} endPos - The end position of the trace.
 * @param {array|CBaseEntity|null} ignoreEntities - A list of entities or a single entity to ignore during the trace. 
 * @param {string|null} note - An optional note associated with the trace. 
 * @returns {array} - An array containing the hit position and the hit entity (or null). 
*/
function TraceLineAnalyzer::Trace(startPos, endPos, ignoreEntities, note) {
    // Get the hit position from the fast trace
    local hitPos = TracePlus.Cheap(startPos, endPos).GetHitpos()
    // Calculate the distance between start and hit positions
    local dist = hitPos - startPos
    // Calculate a distance coefficient for more precise tracing based on distance and error coefficient
    local dist_coeff = abs(dist.Length() / settings.GetErrorTolerance()) + 1
    // Calculate the number of steps based on distance and distance coefficient
    local step = dist.Length() / 14 / dist_coeff

    // Iterate through each step
    for (local i = 0.0; i < step; i++) {
        // Calculate the ray position for the current step
        local rayPart = startPos + dist * (i / step)
        // Find the entity at the ray point
        // TODO!!! separate code! "*"
        for (local ent;ent = entLib.FindByClassnameWithin("*", rayPart, 5 * dist_coeff, ent);) { // todo potential place for improvement
            if (ent && this.shouldHitEntity(ent, ignoreEntities, note)) {
                return [rayPart, ent] // no tuple? :>
            }
        }
    }

    return [hitPos, null]
}

// Check if an entity should be ignored based on the provided settings
/*
* Check if entity is a priority class.
*
* @param {string} entityClass - Entity class name.
* @returns {boolean} True if priority.
*/
function TraceLineAnalyzer::_isPriorityEntity(entityClass) {
    if(settings.GetPriorityClasses().len() == 0) 
        return false
    return settings.GetPriorityClasses().search(function(val):(entityClass) {
        return entityClass.find(val) >= 0
    }) != null
}

/* 
* Check if entity is an ignored class.
*
* @param {string} entityClass - Entity class name.
* @returns {boolean} True if ignored.
*/
function TraceLineAnalyzer::_isIgnoredEntity(entityClass) {
    if(settings.GetIgnoreClasses().len() == 0) 
        return false
    return settings.GetIgnoreClasses().search(function(val):(entityClass) {
        return entityClass.find(val) >= 0
    }) != null
}

/* 
* Check if the entity model is in the list of ignored models.
*
* @param {string} entityModel - The model name of the entity.
* @returns {boolean} True if the model is ignored, false otherwise. 
*/
function TraceLineAnalyzer::_isIgnoredModels(entityModel) {
    if(settings.GetIgnoredModels().len() == 0 || entityModel == "") 
        return false
    return settings.GetIgnoredModels().search(function(val):(entityModel) {
        return entityModel.find(val) >= 0
    }) != null
}

/*
* Check if entity should be ignored.
*
* @param {Entity} ent - Entity to check.
* @param {Entity|array} ignoreEntities - Entities being ignored. 
* @returns {boolean} True if should ignore.
*/
function TraceLineAnalyzer::shouldHitEntity(ent, ignoreEntities, note) { // todo rename
    // todo
    if(settings.ApplyIgnoreFilter(ent, note))
        return false

    if(settings.ApplyCollisionFilter(ent, note))
        return true

    if(ent.GetUserData("TracePlusIgnore"))
        return false


    if(ignoreEntities) {
        // Processing for arrays
        local type = typeof ignoreEntities 
        if (type == "array" || type == "arrayLib") {
            foreach (mask in ignoreEntities) {
                if(ent.isEqually(mask)) return false
            }
        } 
        
        else if(ent.isEqually(ignoreEntities)) return false
    }

    local classname = ent.GetClassname()
    if (_isIgnoredEntity(classname) && !_isPriorityEntity(classname)) {
        return false
    }
    
    if(_isIgnoredModels(ent.GetModelName())) {
        return false
    }

    return true
}
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

/*+--------------------------------------------------------------------------------+
|                           PCapture Vscripts Library                              |
+----------------------------------------------------------------------------------+
| Author:                                                                          |
|     Animation Alchemist - laVashik ¬_¬                                           |
+----------------------------------------------------------------------------------+ 
|       The Animations module, simplifying the creation of smooth and dynamic      |
|       animations for alpha, color, and object movement in your VScripts.         |
+----------------------------------------------------------------------------------+ */

::animate <- {}

::AnimEvent <- class {
    animName = null;
    eventName = null
    delay = 0
    globalDelay = 0
    outputs = null
    entities = []
    lerpFunc = null;
    scope = null;

    /*
     * Constructor for an AnimEvent object. 
     *
     * @param {string} name - TODO
     * @param {table} settings - A table containing animation settings.
     * @param {array} entities - An array of entities to animate.
     * @param {number} time - The duration of the animation in seconds.
    */
    constructor(name, table, ents, time = 0) {
        this.animName = name
        this.entities = _GetEntities(ents)
        this.delay = time
        
        this.eventName = macros.GetFromTable(table, "eventName", UniqueString(name + "_anim")) //! todo mega bruh! Mb use link id, hash or str?
        this.globalDelay = macros.GetFromTable(table, "globalDelay", 0)
        this.outputs = macros.GetFromTable(table, "outputs", null)
        this.scope = macros.GetFromTable(table, "scope", this)
        this.lerpFunc = macros.GetFromTable(table, "lerp", function(t) return t)
    } 

    /* 
     * Calls the outputs associated with the animation event. 
    */
    function callOutputs() {
        if (this.outputs)
            ScheduleEvent.Add(this.eventName, this.outputs, this.delay + this.globalDelay, null, this.scope)
    }

    function _GetEntities(entities) { // meh :>
        if (typeof entities == "string") {
            if(entities.find("*") == null)
                return [entLib.FindByName(entities)]
            else {
                local ents = List()
                for(local ent; ent = entLib.FindByName(entities, ent);)
                    ents.append(ent)
                return ents
            }
        }
                
        if (typeof entities != "pcapEntity")
            return [entLib.FromEntity(entities)]
        
        return [entities]
    } 
}

/*
 * Applies an animation over a specified duration, calculating and setting new values for a property at each frame.
 * 
 * @param {AnimEvent} animSetting - The AnimEvent object containing animation settings and entities.
 * @param {function} valueCalculator - A function that calculates the new value for the property at each frame.
 * @param {function} propertySetter - A function that sets the new value for the property on each entity. 
*/
animate["applyAnimation"] <- function(animSetting, valueCalculator, propertySetter, vars = null, transitionFrames = 0) {
    if(transitionFrames == 0)
        transitionFrames = animSetting.delay / FrameTime();
    transitionFrames = ceil(transitionFrames) 
    local actionsList = List() //* hm....

    for (local step = 0; step <= transitionFrames; step++) {
        local elapsed = (FrameTime() * step) + animSetting.globalDelay

        local newValue = valueCalculator(step, transitionFrames, vars)
        
        foreach(ent in animSetting.entities) {
            local action = ScheduleAction(this, propertySetter, elapsed, [ent, newValue])
            actionsList.append(action)
        }
    }

    ScheduleEvent.AddActions(animSetting.eventName, actionsList, true)
    animSetting.delay = FrameTime() * transitionFrames

    dev.debug("Created " + animSetting.animName + " animation ("+animSetting.eventName+") for " + actionsList.len() + " actions")
}

/*
 * Creates an animation that transitions the alpha (opacity) of entities over time.
 *
 * @param {array|CBaseEntity|pcapEntity} entities - The entities to animate.
 * @param {number} startOpacity - The starting opacity value (0-255). 
 * @param {number} endOpacity - The ending opacity value (0-255). 
 * @param {number} time - The duration of the animation in seconds. 
 * @param {table} animSetting - A table containing additional animation settings. (optional) 
 * @returns {number} The duration of the animation in seconds. 
*/
animate["AlphaTransition"] <- function(entities, startOpacity, endOpacity, time, animSetting = {}) {
    local animSetting = AnimEvent("alpha", animSetting, entities, time)
    local vars = {
        startOpacity = startOpacity,
        opacityDelta = endOpacity - startOpacity,
        lerpFunc = animSetting.lerpFunc
    }

    animate.applyAnimation(
        animSetting, 
        function(step, steps, v) {return v.startOpacity + v.opacityDelta * v.lerpFunc(step / steps)},
        function(ent, newAlpha) {ent.SetAlpha(newAlpha)},
        vars
    )
    
    animSetting.callOutputs()
    return animSetting.delay
}
/*
 * Creates an animation that transitions the color of entities over time.
 *
 * @param {array|CBaseEntity|pcapEntity} entities - The entities to animate.
 * @param {string|Vector} startColor - The starting color as a string (e.g., "255 0 0") or a Vector. 
 * @param {string|Vector} endColor - The ending color as a string or a Vector. 
 * @param {number} time - The duration of the animation in seconds. 
 * @param {table} animSetting - A table containing additional animation settings. (optional) 
 * @returns {number} The duration of the animation in seconds. 
*/
 animate["ColorTransition"] <- function(entities, startColor, endColor, time, animSetting = {}) {
    local animSetting = AnimEvent("color", animSetting, entities, time)
    local vars = {
        startColor = startColor,
        endColor = endColor,
        lerpFunc = animSetting.lerpFunc
    }

    animate.applyAnimation(
        animSetting, 
        function(step, transitionFrames, v) {return math.lerp.color(v.startColor, v.endColor, v.lerpFunc(step / transitionFrames))},
        function(ent, newColor) {ent.SetColor(newColor)},
        vars
    )
    
    animSetting.callOutputs()
    return animSetting.delay
}
/*
 * Creates an animation that transitions the position of entities over time.
 *
 * @param {array|CBaseEntity|pcapEntity} entities - The entities to animate.
 * @param {Vector} startPos - The starting position. 
 * @param {Vector} endPos - The ending position. 
 * @param {number} time - The duration of the animation in seconds. 
 * @param {table} animSetting - A table containing additional animation settings. (optional) 
 * @returns {number} The duration of the animation in seconds. 
*/
animate["PositionTransitionByTime"] <- function(entities, startPos, endPos, time, animSetting = {}) {
    local animSetting = AnimEvent("position", animSetting, entities, time)
    local vars = {
        startPos = startPos,
        dist = endPos - startPos,
        lerpFunc = animSetting.lerpFunc
    }

    animate.applyAnimation(
        animSetting, 
        function(step, steps, v) {return v.startPos + v.dist * v.lerpFunc(step / steps)},
        function(ent, newPosition) {ent.SetOrigin(newPosition)},
        vars
    )
    
    animSetting.callOutputs()
    return animSetting.delay
}


/*
 * Creates an animation that transitions the position of entities over time based on a specified speed. 
 *
 * @param {array|CBaseEntity|pcapEntity} entities - The entities to animate.
 * @param {Vector} startPos - The starting position.
 * @param {Vector} endPos - The ending position.
 * @param {number} speed - The speed of the animation in units per tick.
 * @param {table} animSetting - A table containing additional animation settings. (optional)
 * 
 * The animation will calculate the time it takes to travel from the start position to the end position based on the specified speed. 
 * It will then use this time to create a smooth transition of the entities' positions over that duration.
 * @returns {number} The duration of the animation in seconds. 
*/
animate["PositionTransitionBySpeed"] <- function(entities, startPos, endPos, speed, animSetting = {}) {
    local animSetting = AnimEvent("position", animSetting, entities)
    local vars = {
        startPos = startPos,
        dist = endPos - startPos,
        lerpFunc = animSetting.lerpFunc
    }
    
    animate.applyAnimation(
        animSetting, 
        function(step, steps, v) {return v.startPos + v.dist * v.lerpFunc(step / steps)},
        function(ent, newPosition) {ent.SetOrigin(newPosition)},
        vars,
        vars.dist.Length() / speed.tofloat() // steps
    )
    
    animSetting.callOutputs()
    return animSetting.delay
} 
/*
 * Creates an animation that transitions the angles of entities over time.
 *
 * @param {array|CBaseEntity|pcapEntity} entities - The entities to animate.
 * @param {Vector} startAngles - The starting angles. 
 * @param {Vector} endAngles - The ending angles. 
 * @param {number} time - The duration of the animation in seconds. 
 * @param {table} animSetting - A table containing additional animation settings. (optional) 
 * @returns {number} The duration of the animation in seconds. 
*/
 animate["AnglesTransitionByTime"] <- function(entities, startAngles, endAngles, time, animSetting = {}) {
    local animSetting = AnimEvent("angles", animSetting, entities, time)
    local vars = {
        startAngles = startAngles,
        endAngles = endAngles,
        lerpFunc = animSetting.lerpFunc
    }

    animate.applyAnimation(
        animSetting, 
        function(step, transitionFrames, v){return math.lerp.sVector(v.startAngles, v.endAngles, v.lerpFunc(step / transitionFrames))},
        function(ent, newAngle) {ent.SetAbsAngles(newAngle)},
        vars
    )
    
    animSetting.callOutputs()
    return animSetting.delay
}

/*+--------------------------------------------------------------------------------+
|                           PCapture Vscripts Library                              |
+----------------------------------------------------------------------------------+
| Author:                                                                          |
|     Event Orchestrator - laVashik ・人・                                          |
+----------------------------------------------------------------------------------+
|   The Events module, offering an advanced event scheduling and management system | 
|   for creating complex, timed events with precision and control.                 |
+----------------------------------------------------------------------------------+ */ 


::ScheduleEvent <- {
    // Object to store scheduled events 
    eventsList = {global = List()},
    // Var to track if event loop is running
    executorRunning = false,
    
    Add = null,
    AddActions = null,
    AddInterval = null,

    Cancel = null,
    CancelByAction = null,
    CancelAll = null,
    
    GetEvent = null,
    
    IsValid = null,
}

ScheduleEvent["_startThink"] <- function() {
    if(!ScheduleEvent.executorRunning) {
        ScheduleEvent.executorRunning = true
        ExecuteScheduledEvents()
    }
}

/*
 * Represents a scheduled action.
 *
 * This class encapsulates information about an action that is scheduled to be executed at a specific time.
*/
 ::ScheduleAction <- class {
    //  The entity that created the event. * 
    caller = null;
    // The action to execute when the scheduled time arrives.  
    action = null;
    // The time at which the action is scheduled to be executed. 
    executionTime = null;
    // Optional arguments to pass to the action function.  
    args = null;

    /*
     * Constructor for a ScheduleAction object.
     *
     * @param {pcapEntity} caller - The entity that created the event.
     * @param {string|function} action - The action to execute when the event is triggered.
     * @param {number} delay - The time at which the event is scheduled to be executed.
     * @param {array|null} args - Optional arguments to pass to the action function. 
    */
    constructor(caller, action, delay, args = null) {
        this.caller = caller

        this.action = action
        this.executionTime = delay + Time()

        this.args = args
    }

    /* 
     * Executes the scheduled action. 
     *
     * If the action is a string, it is compiled into a function before execution.
     * If arguments are provided, they are passed to the action function. 
     *
     * @returns {any} - The result of the action function. 
    */
    function run() {
        if(type(action) == "string")
            action = compilestring(action)

        if(args == null) {
            return action.call(caller)
        }
        
        if(typeof args != "array" && typeof args != "arrayLib" && typeof args != "List") {
            throw("Invalid arguments for ScheduleEvent! The argument must be itterable, not (" + args + ")")
        }

        local actionArgs = [caller]
        actionArgs.extend(this.args)
        return action.acall(actionArgs)
    }

    function GetInfo() return "[Caller] " + caller + "\n[Action] " + action + "\n[executionTime] " + executionTime
    function _typeof() return "ScheduleAction"
    function _tostring() return "ScheduleAction: (" + this.executionTime + ")"
    function _cmp(other) {    
        if (this.executionTime > other.executionTime) {
            return 1;
        } else if (this.executionTime < other.executionTime) {
            return -1;
        } else {
            return 0; 
        }
    }
}
/*
 * Adds a single action to a scheduled event with the specified name.
 *
 * @param {string} eventName - The name of the event to add the action to. If the event does not exist, it is created.
 * @param {string|function} action - The action to execute when the scheduled time arrives. This can be a string containing VScripts code or a function object.
 * @param {number} timeDelay - The delay in seconds before executing the action.
 * @param {array|null} args - An optional array of arguments to pass to the action function.
 * @param {object} scope - The scope in which to execute the action (default is `this`). 
*/
ScheduleEvent["Add"] <- function(eventName, action, timeDelay, args = null, scope = this) {
    if ( !(eventName in ScheduleEvent.eventsList) ) {
        ScheduleEvent.eventsList[eventName] <- List()
        dev.debug("Created new Event - " + eventName)
    }

    local newScheduledEvent = ScheduleAction(scope, action, timeDelay, args)
    local currentActionList = ScheduleEvent.eventsList[eventName]


    if(currentActionList.len() == 0 || currentActionList.top() <= newScheduledEvent) {
        currentActionList.append(newScheduledEvent)
        return ScheduleEvent._startThink()
    } 
    
    //* --- A binary tree.
    local low = 0
    local high = currentActionList.len() - 1
    local mid

    while (low <= high) {
        mid = (low + high) / 2
        if (currentActionList[mid] < newScheduledEvent) {
            low = mid + 1
        }
        else if (currentActionList[mid] > newScheduledEvent) {
            high = mid - 1
        }
        else {
            low = mid
            break
        }
    }
    
    currentActionList.insert(low, newScheduledEvent)
    ScheduleEvent._startThink()
}

/*
 * Adds an action to a scheduled event that will be executed repeatedly at a fixed interval. 
 *
 * @param {string} eventName - The name of the event to add the interval to. If the event does not exist, it is created.
 * @param {string|function} action - The action to execute at each interval.
 * @param {number} interval - The time interval in seconds between executions of the action.
 * @param {number} initialDelay - The initial delay in seconds before the first execution of the action (default is 0). 
 * @param {array|null} args - An optional array of arguments to pass to the action function. 
 * @param {object} scope - The scope in which to execute the action (default is `this`). 
*/ 
ScheduleEvent["AddInterval"] <- function(eventName, action, interval, initialDelay = 0, args = null, scope = this) {
    local actions = [ // TODO
        ScheduleAction(scope, action, initialDelay, args),
        ScheduleAction(scope, ScheduleEvent.AddInterval, initialDelay + interval, [eventName, action, interval, 0, args, scope])
    ]   

    ScheduleEvent.AddActions(eventName, actions, true)
    // ScheduleEvent.eventsList[eventName] <- actions // tood :d
}

/*
 * Adds multiple actions to a scheduled event, ensuring they are sorted by execution time.
 *
 * @param {string} eventName - The name of the event to add the actions to. If the event does not exist, it is created.
 * @param {array|List} actions - An array or List of `ScheduleAction` objects to add to the event.
 * @param {boolean} noSort - If true, the actions will not be sorted by execution time (default is false).
 * 
 * **Caution:** Use the `noSort` parameter with care. Incorrect usage may lead to unexpected behavior or break the event scheduling logic. 
*/ 
ScheduleEvent["AddActions"] <- function(eventName, actions, noSort = false) { 
    if (eventName in ScheduleEvent.eventsList ) {
        ScheduleEvent.eventsList[eventName].extend(actions)
        ScheduleEvent.eventsList[eventName].sort()
        // dev.debug("Added " + actions.len() + " actions to Event " + eventName)
        return ScheduleEvent._startThink()
    } 

    if(!noSort) actions.sort()

    if(typeof actions == "List") {
        ScheduleEvent.eventsList[eventName] <- actions
    } else {
        ScheduleEvent.eventsList[eventName] <- List.fromArray(actions)
    }

    dev.debug("Created new Event - " + eventName)
    ScheduleEvent._startThink()
}


/*
 * Cancels a scheduled event with the given name, optionally after a delay.
 *
 * @param {string} eventName - The name of the event to cancel.
 * @param {number} delay - An optional delay in seconds before canceling the event.
*/  
ScheduleEvent["Cancel"] <- function(eventName, delay = 0) {
    if(eventName == "global")
        return dev.warning("The global event cannot be closed!")
    if(!(eventName in ScheduleEvent.eventsList))
        return dev.error("There is no event named " + eventName)
    if(delay > 0)
        return ScheduleEvent.Add("global", format("ScheduleEvent.Cancel(\"%s\")", eventName), delay)
    
    ScheduleEvent.eventsList.rawdelete(eventName)
        
    // Debug info
    if(LibDebugInfo || 1) {
        local test = ""
        foreach(k, i in ScheduleEvent.eventsList)
            test += k + ", "

        test = test.slice(0, -2)
        dev.debug(format("Event \"%s\" closed. Actial events: [%s]", eventName.tostring(), test))
    }
}

ScheduleEvent["TryCancel"] <- function(eventName, delay = 0) {
    if(delay > 0) 
        return ScheduleEvent.Add("global", format("ScheduleEvent.TryCancel(\"%s\")", eventName), delay)
    if(ScheduleEvent.IsValid(eventName)) ScheduleEvent.Cancel(eventName)
}


/*
 * Cancels all scheduled actions that match the given action, optionally after a delay.
 *
 * @param {string|function} action - The action to cancel.
 * @param {number} delay - An optional delay in seconds before canceling the actions. 
*/
ScheduleEvent["CancelByAction"] <- function(action, delay = 0) {
    if(delay > 0)
        return ScheduleEvent.Add("global", format("ScheduleEvent.Cancel(\"%s\")", eventName), delay)
    
    foreach(name, events in ScheduleEvent.eventsList) {
        foreach(eventAction in events) {
            if(eventAction.action == action) {
                events.remove(eventAction)
                dev.debug(eventAction + " was deleted from " + name)
            }
        }
    }
}

/*
 * Cancels all scheduled events and actions, effectively clearing the event scheduler.
*/
ScheduleEvent["CancelAll"] <- function() {
    ScheduleEvent.eventsList = {global = List()}
    dev.debug("All scheduled events have been canceled!")
}


/*
 * Gets info about a scheduled event.
 * 
 * @param {string} eventName - Name of event to get info for.
 * @returns {List|null} - The event info object or null if not found.
*/
ScheduleEvent["GetEvent"] <- function(eventName) {
    return eventName in ScheduleEvent.eventsList ? ScheduleEvent.eventsList[eventName] : null
}


/*
 * Checks if event is valid
 * 
 * @param {string} eventName - Name of event to get info for.
 * @returns {bool} - Object exists or not.
*/
ScheduleEvent["IsValid"] <- function(eventName) {
    return eventName in ScheduleEvent.eventsList && ScheduleEvent.eventsList[eventName].len() != 0
}
/*
 * Executes scheduled events when their time is up. 
 * 
 * This function iterates over all scheduled events and checks if their scheduled execution time has arrived. 
 * If so, it executes the event's action and removes it from the list of scheduled events. 
 * The function then schedules itself to run again after a short delay to continue processing events.
*/
 ::ExecuteScheduledEvents <- function() {
    // If there are no events scheduled, stop the event loop. 
    if(ScheduleEvent.eventsList.len() == 1 && ScheduleEvent.eventsList.global.len() == 0) {
        return ScheduleEvent.executorRunning = false
    }

    // Iterate over each event name and its corresponding event list. 
    foreach(eventName, eventInfo in ScheduleEvent.eventsList) {
        local event 
        // Process events until the list is empty or the next event's time hasn't arrived yet.  
        while(eventInfo.len() > 0 && Time() >= (event = eventInfo.first()).executionTime) {
            try {
                event.run() 
            }
            catch(exception) { // todo??
                SendToConsole("playvol resource/warning.wav 1")
                // printl("\nSCHEDULED EVENT\n[Name] " + eventName + "\n" + event.GetInfo() + "\n" + "[Exception] " + exception)

                if(type(event.action) == "function" || type(event.action) == "native function") {
                    local info = ""
                    foreach(key, val in event.action.getinfos()) {
                        if(type(val) == "array") val = arrayLib(val)
                        info += "[" + key.toupper() + "] " + val + "\n"
                    }
                    printl("\nFUNCTION INFO\n" + info)
                }
            }
            eventInfo.remove(0)
        }
        if(eventName != "global" && eventInfo.len() == 0) {
            ScheduleEvent.eventsList.rawdelete(eventName)
            // dev.debug("I delete " + eventName) // todo dev code
        }
    }
    EntFireByHandle(self, "runscriptcode", "ExecuteScheduledEvents()", FrameTime(), null, null)
}

/*+--------------------------------------------------------------------------------+
|                           PCapture Vscripts Library                              |
+----------------------------------------------------------------------------------+
| Author:                                                                          |
|     Game Event Guru - laVashik >_<                                               |
+----------------------------------------------------------------------------------+
|   The Game Events module, empowering you to create and handle custom game events |
|   with triggers, filters, and actions, surpassing the limitations of standard    |
|   VScripts game events.                                                          |
+----------------------------------------------------------------------------------+ */

::AllGameEvents <- {}

/*
 * Logs a VScript event message to the console if event logging is enabled. 
 *
 * @param {string} msg - The event message to log. 
*/
dev["VSEvent"] <- function(msg) if(VSEventLogs) printl("VScript Event Fired: " + msg)

// TODO add support real game event

/* 
 * Listens for and handles custom game events.
*/
 ::EventListener <- {
    /*
     * Notifies the listener of a triggered event.
     *
     * @param {string} eventName - The name of the triggered event.
     * @param {any} ... - Optional arguments associated with the event. 
     * @returns {any|null} - The result of the event's action, or null if the event is not found or the filter fails. 
    */
    function Notify(eventName, ...) {
        if(eventName in AllGameEvents == false)
            return dev.warning("Unknown GameEvent {" + eventName + "}")

        local varg = array(vargc)
        for(local i = 0; i< vargc; i++) {
            varg[i] = vargv[i]
        }

        return AllGameEvents[eventName].Trigger(varg)
        
    }
    
    /* 
     * Gets a GameEvent object by name. 
     * 
     * @param {string} EventName - The name of the event to retrieve. 
     * @returns {GameEvent|null} - The GameEvent object, or null if the event is not found. 
    */
    function GetEvent(EventName) {
        return eventName in AllGameEvents ? AllGameEvents[eventName] : null
    }
}
/*
 * Represents a custom game event. 
 * 
 * This class allows you to create and manage custom game events with triggers, filters, and actions. 
*/
 ::GameEvent <- class {
    // The name of the event.  
    eventName = null; 
    // The number of times the event can be triggered before it becomes inactive (-1 for unlimited triggers). 
    triggerCount = null; 
    // The actions to be performed when the event is triggered. 
    actions = null; 
    // A filter function to check conditions before triggering the event.  
    filterFunction = null; 

    // Constructor for initializing the GameEvent
    /*
     * Constructor for a GameEvent object.
     *
     * @param {string} eventName - The name of the event.
     * @param {number} triggerCount - The number of times the event can be triggered (-1 for unlimited). (optional, default=-1) 
     * @param {function} actionsList - The action to be performed when the event is triggered. (optional) 
    */
    constructor(eventName, triggerCount = -1, actionsList = null) {
        this.eventName = eventName
        this.triggerCount = triggerCount
        this.actions = List()
        
        if(actionsList) this.actions.append(actionsList)
        
        AllGameEvents[eventName] <- this
    }

    /* 
     * Sets the action function for the event. 
     *
     * @param {function} actionFunction - The function to execute when the event is triggered. 
    */
    function SetAction(filterFunc) return null

    // Method to add a filter function to the event
    /* 
     * Sets the filter function for the event. 
     *
     * The filter function should return true if the event should be triggered, false otherwise. 
     *
     * @param {function} filterFunction - The function to use for filtering trigger conditions. 
    */
    function SetFilter(filterFunc) return null
    
    // Method to trigger the event if conditions are met
    /* 
     * Triggers the event if the trigger count allows and the filter function (if set) returns true. 
     *
     * @param {any} args - Optional arguments to pass to the actions function. 
    */
    function Trigger(args = null) return null
    
    // Method to forcibly trigger the event regardless of the filter function and remaining triggers
    /*
     * Forces the event to trigger, ignoring the filter function and trigger count. 
     * 
     * @param {any} args - Optional arguments to pass to the actions function. 
    */
    function ForceTrigger(args = null) return null
}



/*
 * Sets the action function for the event. 
 *
 * @param {function} actionFunction - The function to execute when the event is triggered. 
*/
function GameEvent::SetAction(filterFunc) {
    this.actions.append(filterFunc)
}


/* 
 * Sets the filter function for the event. 
 *
 * The filter function should return true if the event should be triggered, false otherwise. 
 *
 * @param {function} filterFunction - The function to use for filtering trigger conditions. 
*/
function GameEvent::SetFilter(filterFunc) {
    this.filterFunction = filterFunc
}


/* 
 * Triggers the event if the trigger count allows and the filter function (if set) returns true. 
 *
 * @param {any} args - Optional arguments to pass to the actions function. 
*/
function GameEvent::Trigger(args = []) {
    if (this.actions != 0 && this.triggerCount != 0 && (this.filterFunction == null || this.filterFunction(args))) {
        if (this.triggerCount > 0) {
            // Decrement the trigger count if it is not unlimited
            this.triggerCount-- 
        }

        dev.VSEvent(this.eventName)
        return this.ForceTrigger(args)
    }
}


/*
 * Forces the event to trigger, ignoring the filter function and trigger count. 
 * 
 * @param {any} args - Optional arguments to pass to the actions function. 
*/
function GameEvent::ForceTrigger(args = []) {
    args.insert(0, this)
    foreach(action in this.actions) {
        action.acall(args)
    }
}

/*+--------------------------------------------------------------------------------+
|                           PCapture Vscripts Library                              |
+----------------------------------------------------------------------------------+
| Author:                                                                          |
|     Interface Illusionist - laVashik :|                                          |
+----------------------------------------------------------------------------------+
|    The HUD module, providing tools to craft immersive and informative on-screen  | 
|    elements like text displays and interactive hints.                            |
+----------------------------------------------------------------------------------+ */ 

::HUD <- {}

/*
 * A class for displaying on-screen text using the "game_text" entity.
*/
 HUD["ScreenText"] <- class {
    // The underlying pcapEntity object representing the "game_text" entity. 
    CPcapEntity = null;
    
    /*
     * Constructor for a ScreenText object.
     *
     * @param {Vector} position - The position of the text on the screen. 
     * @param {string} message - The text message to display. 
     * @param {number} holdtime - The duration in seconds to display the text. (optional, default=10)
     * @param {string} targetname - The targetname of the "game_text" entity. (optional) 
    */
    constructor(position, message, holdtime = 10, targetname = "") {
        this.CPcapEntity = entLib.CreateByClassname("game_text", {
            // Set initial properties for the text display entity
            channel = 2,
            color = "170 170 170",
            color2 = "0 0 0",
            effect = 0,
            fadein = 0,
            fadeout = 0,
            fxtime = 0,
            holdtime = holdtime,
            x = position.x,
            y = position.y,
            spawnflags = 0,
            message = message,
            targetname = targetname
        })
    }

    // Displays the on-screen text. 
    function Enable() null
    // Hides the on-screen text. 
    function Disable() null
    // Updates and redisplays the on-screen text. 
    function Update() null

    // Changes the message of the text display 
    function SetText(message) null 
    // Sets the channel of the text display.  
    function SetChannel(value) null
    // Sets the primary color of the text display as a string.  
    function SetColor(string_color) null
    // Sets the secondary color of the text display as a string.  
    function SetColor2(string_color) null
    // Sets the effect of the text display.  
    function SetEffect(value) null
    // Sets the fade-in time of the text display. 
    function SetFadeIn(value) null
    // Sets the fade-out time of the text display. 
    function SetFadeOut(value) null
    // Sets the hold time (duration) of the text display.  
    function SetHoldTime(time) null
    // Sets the position of the text display.  
    function SetPos(Vector) null
}


/*
 * Displays the on-screen text. 
*/
function HUD::ScreenText::Enable() {
    EntFireByHandle(this.CPcapEntity, "Display")
}

/*
 * Hides the on-screen text. 
*/
function HUD::ScreenText::Disable() {
    EntFireByHandle(this.CPcapEntity, "Disable")
}

/*
 * Updates and redisplays the on-screen text. 
*/
function HUD::ScreenText::Update() {
    this.CPcapEntity.Enable()
}

/*
 * Changes the message of the text display and redisplays it.
 * 
 * @param {string} message - The new text message to display. 
*/
function HUD::ScreenText::SetText(message) {
    this.CPcapEntity.SetKeyValue("message", message)
}

/*
 * Sets the channel of the text display. 
 *
 * @param {number} channel - The channel to set.
*/
function HUD::ScreenText::SetChannel(channel) {
    this.CPcapEntity.SetKeyValue("channel", channel)
}

/*
 * Sets the primary color of the text display as a string. 
 *
 * @param {string} color - The color string, e.g., "255 0 0". 
*/
function HUD::ScreenText::SetColor(color) {
    this.CPcapEntity.SetKeyValue("color", color)
}

/*
 * Sets the secondary color of the text display as a string. 
 *
 * @param {string} color - The color string, e.g., "255 0 0". 
*/
function HUD::ScreenText::SetColor2(color) {
    this.CPcapEntity.SetKeyValue("color2", color)
}

/* 
 * Sets the effect of the text display. 
 *
 * @param {number} index - The index of the effect to set. 
*/
function HUD::ScreenText::SetEffect(idx) {
    this.CPcapEntity.SetKeyValue("effect", idx)
}

/*
 * Sets the fade-in time of the text display.
 *
 * @param {number} value - The fade-in time in seconds.  
*/ 
function HUD::ScreenText::SetFadeIn(value) {
    this.CPcapEntity.SetKeyValue("fadein", value)
}

/*
 * Sets the fade-out time of the text display.
 *
 * @param {number} value - The fade-out time in seconds.  
*/ 
function HUD::ScreenText::SetFadeOut(value) {
    this.CPcapEntity.SetKeyValue("fadeout", value)
}

/*
 * Sets the hold time (duration) of the text display. 
 *
 * @param {number} time - The hold time in seconds.  
*/
function HUD::ScreenText::SetHoldTime(time) {
    this.CPcapEntity.SetKeyValue("holdtime", time)
}

/*
 * Sets the position of the text display. 
 *
 * @param {Vector} position - The new position of the text. 
*/
function HUD::ScreenText::SetPos(position) {
    this.CPcapEntity.SetKeyValue("x", position.x)
    this.CPcapEntity.SetKeyValue("y", position.y)
}
/*
 * A class for displaying hints using the "env_instructor_hint" entity. 
*/
 HUD["HintInstructor"] <- class {
    // The underlying pcapEntity object representing the "env_instructor_hint" entity.  
    CPcapEntity = null;

    /*
     * Constructor for a HintInstructor object. 
     *
     * @param {string} message - The hint message to display.
     * @param {number} holdtime - The duration in seconds to display the hint. (optional, default=5) 
     * @param {string} icon - The icon to display with the hint. (optional, default="icon_tip") 
     * @param {number} showOnHud - Whether to display the hint on the HUD or at the target entity's position (1 for HUD, 0 for target entity). (optional, default=1) 
     * @param {string} targetname - The targetname of the "env_instructor_hint" entity. (optional, default="hint") 
    */
    constructor(message, holdtime = 5, icon = "icon_tip", showOnHud = 1, targetname = "hint") {
        this.CPcapEntity = entLib.CreateByClassname("env_instructor_hint", {
            // The text of your hint. 100 character limit.
            hint_caption = message,
            // Either show at the position of the Target Entity, or show the hint directly on the HUD at a fixed position.
            hint_static = showOnHud,
            hint_allow_nodraw_target = showOnHud,
            // The color of the caption text.
            hint_color = "255, 255, 255",
            // The icon to use when the hint is within the player's view.
            hint_icon_onscreen = icon,
            hint_icon_offscreen = icon,
            // The automatic timeout for the hint. 0 will persist until stopped with EndHint.
            hint_timeout = holdtime,
            hint_forcecaption = 1,
            hint_nooffscreen = 0,
            hint_range = 0, 
            targetname = targetname
        })
    }

    // Displays the hint.  
    function Enable() null
    // Hides the hint. 
    function Disable() null
    // Updates and redisplays the hint.  
    function Update() null
    
    // Changes the message of the hint. 
    function SetText(message) null 
    // Sets the bind to display with the hint icon.  
    function SetBind(bind) null
    // Sets the positioning of the hint (on HUD or at target entity).  
    function SetPositioning(value, ent) null
    // Sets the color of the hint text as a string. 
    function SetColor(string_color) null
    // Sets the icon to display when the hint is on-screen.  
    function SetIconOnScreen(icon) null
    // Sets the icon to display when the hint is off-screen.  
    function SetIconOffScreen(bind) null
    // Sets the hold time (duration) of the hint.  
    function SetHoldTime(time) null
    // Sets the distance at which the hint is visible.  
    function SetDistance(value) null
    // Sets the visual effects for the hint.  
    function SetEffects(sizePulsing, alphaPulsing, shaking) null
}

// Implementation of 'enable' to display the on-screen text
/*
 * Displays the hint. 
*/
function HUD::HintInstructor::Enable() {
    EntFireByHandle(this.CPcapEntity, "ShowHint")
}

// Implementation of 'disable' to hide the on-screen text
/*
 * Hides the hint. 
*/
function HUD::HintInstructor::Disable() {
    EntFireByHandle(this.CPcapEntity, "EndHint")
}

/*
 * Updates and redisplays the hint. 
*/
function HUD::HintInstructor::Update() {
    this.CPcapEntity.Enable()
}

/*
 * Changes the message of the hint and redisplays it. 
 * 
 * @param {string} message - The new hint message to display. 
*/
function HUD::HintInstructor::SetText(message) {
    this.CPcapEntity.SetKeyValue("hint_caption", message)
}
 
/* 
 * Sets the bind to display with the hint icon and updates the icon to "use_binding". 
 *
 * @param {string} bind - The bind name to display. 
*/
function HUD::HintInstructor::SetBind(bind) {
    this.CPcapEntity.SetKeyValue("hint_binding", bind)
    this.CPcapEntity.SetKeyValue("hint_icon_onscreen", "use_binding")
}

/*
 * Sets the positioning of the hint (on HUD or at target entity). 
 *
 * @param {number} value - 1 to display the hint on the HUD, 0 to display it at the target entity's position.
 * @param {CBaseEntity|pcapEntity|null} entity - The target entity to position the hint at (only used if value is 0). (optional) 
*/
function HUD::HintInstructor::SetPositioning(value, ent = null) { // showOnHud
    this.CPcapEntity.SetKeyValue("hint_static", value)
    this.CPcapEntity.SetKeyValue("hint_target", ent)
}

/* 
 * Sets the color of the hint text as a string. 
 *
 * @param {string} color - The color string, e.g., "255 0 0". 
*/
function HUD::HintInstructor::SetColor(color) {
    this.CPcapEntity.SetKeyValue("hint_color", color)
}

/* 
 * Sets the icon to display when the hint is on-screen. 
 *
 * @param {string} icon - The icon name to display. 
*/
function HUD::HintInstructor::SetIconOnScreen(icon) {
    this.CPcapEntity.SetKeyValue("hint_icon_onscreen", icon)
}

/* 
 * Sets the icon to display when the hint is off-screen. 
 *
 * @param {string} icon - The icon name to display. 
*/
function HUD::HintInstructor::SetIconOffScreen(icon) {
    this.CPcapEntity.SetKeyValue("hint_icon_offscreen", icon)
}   

/* 
 * Sets the hold time (duration) of the hint. 
 *
 * @param {number} time - The hold time in seconds. 
*/
function HUD::HintInstructor::SetHoldTime(time) {
    this.CPcapEntity.SetKeyValue("hint_timeout", time)
}

/*
 * Sets the distance at which the hint is visible.
 *
 * @param {number} distance - The distance in units.  
*/
function HUD::HintInstructor::SetDistance(value) {
    this.CPcapEntity.SetKeyValue("hint_range", value)
}

/*
 * Sets the visual effects for the hint. 
 *
 * @param {number} sizePulsing - The size pulsing option (0 for no pulsing, 1 for pulsing). 
 * @param {number} alphaPulsing - The alpha pulsing option (0 for no pulsing, 1 for pulsing).
 * @param {number} shaking - The shaking option (0 for no shaking, 1 for shaking).  
*/
function HUD::HintInstructor::SetEffects(sizePulsing, alphaPulsing, shaking) {
    this.CPcapEntity.SetKeyValue("hint_pulseoption", sizePulsing)
    this.CPcapEntity.SetKeyValue("hint_alphaoption", alphaPulsing)
    this.CPcapEntity.SetKeyValue("hint_shakeoption", shaking)
}



::cwar <- List() // todo
::cerr <- List()

// dissolve entity for pcapEnts
if(("dissolver" in getroottable()) == false) {
    ::dissolver <- entLib.CreateByClassname("env_entity_dissolver", {targetname = "@dissolver"})
} 

// 
AttachEyeControlToPlayers()
if(IsMultiplayer() && "TEAM_SINGLEPLAYER" in getroottable()) { // "TEAM_SINGLEPLAYER" - p2mm const
    RunScriptCode.setInterval(AttachEyeControlToPlayers, 0.5)
}

::_lib_version_ <- version


/*
 * Prints information about the PCapture library upon initialization.
 *
 * This includes the library name, version, author, and a link to the GitHub repository.
*/
printl("\n----------------------------------------")
printl("Welcome to " + _lib_version_)
printl("Author: laVashik Production") // The Grand Archmage :P
printl("GitHub: https://github.com/IaVashik/PCapture-LIB")
printl("----------------------------------------\n")
