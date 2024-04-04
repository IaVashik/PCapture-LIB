::RunScriptCode <- {
    /* Creates a delay before executing the specified script.
    * 
    * @param {string|function} script - The script to execute. Can be a function or a string.
    * @param {int|float} runDelay - The delay in seconds.
    * @param {CBaseEntity|pcapEntity} activator - The activator entity. (optional)
    * @param {CBaseEntity|pcapEntity} caller - The caller entity. (optional)
    */
    delay = function(script, runDelay, activator = null, caller = null, args = null) {
        if (typeof script == "function")
            return CreateScheduleEvent("global", script, runDelay, null, args)

        EntFireByHandle(self, "runscriptcode", script, runDelay, activator, caller)
    },  

    /* Executes a function repeatedly with a specified delay for a given number of loops.
    * 
    * @param {string|function} func - The function to execute.
    * @param {int|float} runDelay - The delay between each execution in seconds.
    * @param {int|float} loop - The number of loops.
    * @param {string} outputs - The function to execute after all loops completed. (optional)
    */
    loopy = function(script, runDelay, loop, outputs = null) {
        if (loop > 0) {
            this.delay(script, runDelay)
            this.delay(this.loopy, runDelay, null, null, [script, runDelay, --loop, outputs])
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
        CreateScheduleEvent(eventName, script, runDelay)
        CreateScheduleEvent(eventName, this.setInterval, interval + runDelay, null, [script, interval, 0, eventName])
    },

    /* Execute a script from a string.
    * 
    * @param {string} str - The script string.
    */
    fromStr = function(str) {
        compilestring(str)() // todo а если передать функцию в виде строки?
    }
}