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
animate["applyAnimation"] <- function(animSetting, valueCalculator, propertySetter, transitionFrames = 0) {
    if(transitionFrames == 0)
        transitionFrames = animSetting.delay / FrameTime();
    transitionFrames = ceil(transitionFrames) 
    local actionsList = List()

    for (local step = 0; step <= transitionFrames; step++) {
        local elapsed = (FrameTime() * step) + animSetting.globalDelay

        local newValue = valueCalculator(step, transitionFrames)
        
        foreach(ent in animSetting.entities) {
            local action = ScheduleAction(this, propertySetter, elapsed, [ent, newValue])
            actionsList.append(action)
        }
    }

    ScheduleEvent.AddActions(animSetting.eventName, actionsList, true)
    animSetting.delay = FrameTime() * transitionFrames

    dev.debug("Created " + animSetting.animName + " animation ("+animSetting.eventName+") for " + actionsList.len() + " actions")
}

IncludeScript("SRC/Animations/alpha")
IncludeScript("SRC/Animations/color")
IncludeScript("SRC/Animations/position")
IncludeScript("SRC/Animations/angles")