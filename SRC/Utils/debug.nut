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