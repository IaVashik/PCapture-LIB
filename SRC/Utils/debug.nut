::LoggerLevels <- class {
    Trace = 1
    Debug = 5
    Info = 10
    Warning = 30
    Error = 60
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
        if (developer() == 0) return
        DebugDrawBox(ent.GetOrigin(), ent.GetBoundingMins(), ent.GetBoundingMaxs(), 255, 165, 0, 9, time)
    },

    /*
     * Draws a box at the specified vector position for the specified time.
     * 
     * @param {Vector} vector - The position of the box.
     * @param {Vector} color - The color of the box. (optional)
     * @param {number} time - The duration of the display in seconds. (optional)
    */
    drawbox = function(vector, color = Vector(125, 125, 125), time = 0.05) {
        if (developer() == 0) return
        DebugDrawBox(vector, Vector(-1,-1,-1), Vector(1,1,1), color.x, color.y, color.z, 100, time)
    },

    // only for PCapture-LIB debugging
    trace = function(msg, ...) {
        if (developer() == 0 || LibLogger > LoggerLevels.Trace) return
        // region - repeatable code, thanks to Squirrel
        local args = array(vargc + 2)
        args[0] = this
        args[1] = msg

        for(local i = 0; i< vargc; i++) {
            args[i + 2] = vargv[i]
        }
        // endregion

        local msg = this.format.acall(args)
        printl("-- PCapture-Lib: " + msg)
    },

    /*
     * Logs a debug message to the console if debug logging is enabled. 
     *
     * @param {string} msg - The debug message string containing `{}` placeholders. 
    */ 
    debug = function(msg, ...) {
        if (developer() == 0 || LibLogger > LoggerLevels.Debug) return
        // region - repeatable code, thanks to Squirrel
        local args = array(vargc + 2)
        args[0] = this
        args[1] = msg

        for(local i = 0; i< vargc; i++) {
            args[i + 2] = vargv[i]
        }
        // endregion

        local msg = this.format.acall(args)
        printl("~ " + msg)
    },


    /*
     * Logs a info message to the console only if developer mode is enabled.
     * 
     * @param {string} msg - The message to log string containing `{}` placeholders.
    */
    info = function(msg, ...) {
        if (developer() == 0 || LibLogger > LoggerLevels.Info) return
        // region - repeatable code, thanks to Squirrel
        local args = array(vargc + 2)
        args[0] = this
        args[1] = msg

        for(local i = 0; i< vargc; i++) {
            args[i + 2] = vargv[i]
        }
        // endregion

        local msg = this.format.acall(args)
        printl("• " + msg)
    },

    /*
     * Displays a warning message in a specific format.
     * 
     * @param {string} msg - The warning message string containing `{}` placeholders. 
    */
    warning = function(msg, ...) {
        if (developer() == 0 || LibLogger > LoggerLevels.Warning) return
        local pattern = "► Warning ({} [{}]): " + msg
        // region - repeatable code, thanks to Squirrel
        local info = dev._getInfo()
        local args = array(vargc + 4)
        args[0] = this
        args[1] = pattern // pattern
        args[2] = info[0] // func name
        args[3] = info[1] // func line

        for(local i = 0; i< vargc; i++) {
            args[i + 4] = vargv[i]
        }
        // endregion
        printl(this.format.acall(args))
    },

    /* 
     * Displays an error message in a specific format.
     * 
     * @param {string} msg - The error message string containing `{}` placeholders.
    */
    error = function(msg, ...) {
        if (developer() == 0 || LibLogger > LoggerLevels.Error) return
        local pattern = "▄▀ *ERROR*: [func = {}; line = {}] | " + msg
        // region - repeatable code, thanks to Squirrel
        local info = dev._getInfo()
        local args = array(vargc + 4)
        args[0] = this
        args[1] = pattern // pattern
        args[2] = info[0] // func name
        args[3] = info[1] // func line

        for(local i = 0; i< vargc; i++) {
            args[i + 4] = vargv[i]
        }
        // endregion
        printl(this.format.acall(args))
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
    },

    _getInfo = function() {
        local last_info
        for(local i = 0; getstackinfos(i); i++)
            last_info = i 
        local info = getstackinfos(last_info)
        
        local funcName = getstackinfos(last_info).func
        if (funcName == "main" || funcName == "unknown")
            funcName = "file " + info.src
            
        local line = info.line
        return [funcName, line]
    }
}