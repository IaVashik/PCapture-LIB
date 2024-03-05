/*+--------------------------------------------------------------------------------+
|                           PCapture Vscripts Library                               |
 +---------------------------------------------------------------------------------+
| Author:                                                                           |
|     One-of-a-Kind - laVashik :D                                                   |
 +---------------------------------------------------------------------------------+
| PCapture-utils.nut                                                                |
|       A collection of utility functions for script execution and debugging.       |
|       It's a Swiss army knife for developers working with Squirrel :D             |
+----------------------------------------------------------------------------------+ */


::RunScriptCode <- {
    /* Creates a delay before executing the specified script.
    * 
    * @param {string|function} script - The script to execute. Can be a function or a string.
    * @param {int|float} runDelay - The delay in seconds.
    * @param {CBaseEntity|pcapEntity} activator - The activator entity. (optional)
    * @param {CBaseEntity|pcapEntity} caller - The caller entity. (optional)
    */
    delay = function(script, runDelay, activator = null, caller = null) {
        if (typeof script == "function")
            return CreateScheduleEvent("global", script, runDelay)

        EntFireByHandle(self, "runscriptcode", script, runDelay, activator, caller)
    },  

    /* Executes a function repeatedly with a specified delay for a given number of loops.
    * 
    * @param {string} func - The function to execute.
    * @param {int|float} runDelay - The delay between each execution in seconds.
    * @param {int|float} loop - The number of loops.
    * @param {string} outputs - The function to execute after all loops completed. (optional)
    */
    loopy = function(func, runDelay, loop, outputs = null) {
        if (loop > 0) {
            this.delay(func, runDelay)
            this.delay("loopy(\"" + func + "\"," + runDelay + "," + (loop - 1) + ",\"" + outputs + "\")", runDelay)
        } else if (outputs)
            this.delay(outputs, 0)
    },

    /* Schedules the execution of a script recursively at a fixed interval.
     *
     * This function schedules the provided script to run repeatedly at a specified interval. After each execution,
     * the function schedules itself to run again, creating a loop that continues until you cancel the event
     *
     * @param {string|function} script - The script to be executed. Can be a function or a string containing code.
     * @param {int|float} interval -  // TODO
     * @param {int|float} runDelay - The time delay between consecutive executions in seconds. // TODO
     * @param {string} eventName - The name of the event used for scheduling. (optional, default="global")
     */
    setInterval = function(script, interval = FrameTime(), runDelay = 0, eventName = "global") {
        local runAgain = function() : (script, interval, eventName) {
            RunScriptCode.setInterval(script, interval, 0, eventName)
        }
        
        CreateScheduleEvent(eventName, script, runDelay)
        CreateScheduleEvent(eventName, runAgain, interval + runDelay)
    },

    /* Execute a script from a string.
    * 
    * @param {string} str - The script string.
    */
    fromStr = function(str) {
        compilestring(str)()
    }
}


::dev <- {
    /* Draws the bounding box of an entity for the specified time.
    * 
    * @param {CBaseEntity|pcapEntity} ent - The entity to draw the bounding box for.
    * @param {int|float} time - The duration of the display in seconds.
    */
    DrawEntityBBox = function(ent, time) {
        DebugDrawBox(ent.GetOrigin(), ent.GetBoundingMins(), ent.GetBoundingMaxs(), 255, 165, 0, 9, time)
    },

    /* Draws a box at the specified vector position for the specified time.
    * 
    * @param {Vector} vector - The position of the box.
    * @param {Vector} color - The color of the box.
    * @param {int|float} time - The duration of the display in seconds. (optional)
    */
    drawbox = function(vector, color, time = 0.05) {
        DebugDrawBox(vector, Vector(-1,-1,-1), Vector(1,1,1), color.x, color.y, color.z, 100, time)
    },


    /* Logs a message to the console only if developer mode is enabled.
    * 
    * @param {string} msg - The message to log.
    */
    log = function(msg) {
        if (developer() != 0)
            printl("• " + msg)
    },

    /* Displays a warning message in a specific format.
    * 
    * @param {string} msg - The warning message.
    */
    warning = function(msg) {
        _more_info("► Warning (%s [%d]): %s", msg)
    },

    /* Displays an error message in a specific format.
    * 
    * @param {string} msg - The error message.
    */
    error = function(msg) {
        _more_info("▄▀ *ERROR*: [func = %s; line = %d] | %s", msg)
        SendToConsole("playvol resource/warning.wav 1")
    },

    /*
    * Formats and prints detailed debug info.
    *
    * @param {string} pattern - Printf pattern 
    * @param {string} msg - The error message
    */  
    _more_info = function(pattern, msg) {
        if (developer() == 0)
            return

        local info = getstackinfos(3)
        local func_name = info.func
        if (func_name == "main" || func_name == "unknown")
            func_name = "file " + info.src

        printl(format(pattern, func_name, info.line, msg))
    }
}


/* Prints a formatted message to the console.
* 
* @param {string} msg - The message string containing `{}` placeholders.
* @param {any} vargs... - Additional arguments to substitute into the placeholders.

*/
::fprint <- function(msg, ...) {

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
            result += args[i].tostring();
        }
    }

    printl(result)
}



/* Converts a string to a Vector object.
* 
* @param {string} str - The string representation of the vector, e.g., "x y z".
* @returns {Vector} - The converted vector.
*/
::StrToVec <- function(str) {
    local str_arr = split(str, " ")
    local vec = Vector(str_arr[0].tointeger(), str_arr[1].tointeger(), str_arr[2].tointeger())
    return vec
}


/* Gets the prefix of the entity name.
*
* @returns {string} - The prefix of the entity name.
*/
::GetPrefix <- function(name) {
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
::GetPostfix <- function(name) {
    local parts = split(name, "-")
    if(parts.len() == 0)
        return name

    local lastPartLength = parts[0].len();
    local prefix = name.slice(lastPartLength);
    return prefix;
}


/* Precaches a sound script for later use.
* 
* @param {string|array|arrayLib} sound_path - The path to the sound script.
*/
::Precache <- function(sound_path) {
    if(typeof sound_path == "string")
        return self.PrecacheSoundScript(sound_path)
    foreach(path in sound_path)
        self.PrecacheSoundScript(path)
}


::GetFromTable <- function(table, key, defaultValue = null) {
    if(key in table) 
        return table[key]
    return defaultValue
}


::GetDist <- function(vec1, vec2) {
    return (vec2 - vec1).Length()
}