::RunScriptCode <- {
    /* 
     * Creates a delay before executing the specified script.
     * 
     * @param {string|function} script - The script to execute. Can be a function or a string.
     * @param {number} runDelay - The delay in seconds.
     * @param {array|null} args - Optional arguments to pass to the script function. 
     * @param {object} scope - // TODO. (optional)
    */
    delay = function(script, runDelay = 0, args = null, scope = null) { 
        ScheduleEvent.Add("global", script, runDelay, args, scope)
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
     * Execute a script from a string.
     * 
     * @param {string} str - The script string.
    */
    fromStr = function(str) {
        compilestring(str)()
    }
}