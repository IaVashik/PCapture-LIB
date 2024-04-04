local print_info = function(pattern, msg) {
    if (developer() == 0)
        return

    local info
    for(local i = 0; getstackinfos(i); i++){
        info = i
    }
    local func_name = info.func
    if (func_name == "main" || func_name == "unknown")
        func_name = "file " + info.src

    local line = info.line 
    printl(format(pattern, func_name, line, msg))
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
    warning = function(msg) : (print_info) {
        print_info("► Warning (%s [%d]): %s", msg)
    },

    /* Displays an error message in a specific format.
    * 
    * @param {string} msg - The error message.
    */
    error = function(msg) : (print_info) {
        print_info("▄▀ *ERROR*: [func = %s; line = %d] | %s", msg)
        SendToConsole("playvol resource/warning.wav 1")
    },


    /* Prints a formatted message to the console.
    * 
    * @param {string} msg - The message string containing `{}` placeholders.
    * @param {any} vargs... - Additional arguments to substitute into the placeholders.
    */
    fprint = function(msg, ...) {

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
    },
}