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
    eventName = null
    delay = 0
    globalDelay = 0
    note = null
    outputs = null
    entities = []

    /*
     * Constructor for an AnimEvent object. 
     *
     * @param {table} settings - A table containing animation settings.
     * @param {array} entities - An array of entities to animate.
     * @param {number} time - The duration of the animation in seconds.
     */
    constructor(table, ents, time) {
        this.entities = ents
        this.delay = time

        this.eventName = macros.GetFromTable(table, "eventName", UniqueString("anim")) //! mega bruh! Use link id, hash or str?
        this.globalDelay = macros.GetFromTable(table, "globalDelay", 0)
        this.note = macros.GetFromTable(table, "note", null)
        this.outputs = macros.GetFromTable(table, "outputs", null)
    }

    /* 
     * Calls the outputs associated with the animation event. 
     */
    function callOutputs() {
        if (this.outputs)
            CreateScheduleEvent(this.eventName, this.outputs, this.time)
    }
}

/*
 * Applies an animation over a specified duration, calculating and setting new values for a property at each frame.
 * 
 * @param {AnimEvent} animSetting - The AnimEvent object containing animation settings and entities.
 * @param {function} valueCalculator - A function that calculates the new value for the property at each frame.
 * @param {function} propertySetter - A function that sets the new value for the property on each entity. 
 */
animate["applyAnimation"] <- function(animSetting, valueCalculator, propertySetter) {
    local transitionFrames = animSetting.time / FrameTime();
    for (local step = 0; step < transitionFrames; step++) {
        local elapsed = (FrameTime() * step) + animSetting.globalDelay

        local newValue = valueCalculator(step, transitionFrames)
        
        foreach(ent in animSetting.entities) {
            CreateScheduleEvent(animSetting.eventName, propertySetter, elapsed, animSetting.note, [ent, newValue])
        }
    }
}

// todo test
IncludeScript("SRC/Animations/alpha")
IncludeScript("SRC/Animations/color")
IncludeScript("SRC/Animations/position")
IncludeScript("SRC/Animations/angles")