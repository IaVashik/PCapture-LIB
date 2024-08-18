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
    frameInterval = 0
    maxFrames = 60.0
    outputs = null
    entities = []
    lerpFunc = null;
    scope = null;

    /*
     * Constructor for an AnimEvent object. 
     *
     * @param {string} name - A name of type animation
     * @param {table} settings - A table containing animation settings.
     * @param {array} entities - An array of entities to animate.
     * @param {number} time - The duration of the animation in seconds.
    */
    constructor(name, table, ents, time = 0) {
        this.animName = name
        this.entities = _GetEntities(ents)
        this.delay = time
        
        this.eventName = macros.GetFromTable(table, "eventName", UniqueString(name + "_anim"))
        this.globalDelay = macros.GetFromTable(table, "globalDelay", 0)
        this.outputs = macros.GetFromTable(table, "outputs", null)
        this.scope = macros.GetFromTable(table, "scope", this)
        this.lerpFunc = macros.GetFromTable(table, "lerp", function(t) return t)
        this.frameInterval = macros.GetFromTable(table, "frameInterval", FrameTime()) 
        this.maxFrames = macros.GetFromTable(table, "fps", 60.0)
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
 * This function is used internally by the various animation functions to handle the animation process.
 * It calculates the new value for the property at each frame using the provided `valueCalculator` function and applies it to each entity using the `propertySetter` function.
 *
 * @param {AnimEvent} animInfo - The AnimEvent object containing the animation settings and entities.
 * @param {function} valueCalculator - A function that calculates the new value for the property at each frame.
 *    This function should take three arguments:
 *        * `step`: The current frame number (starting from 0).
 *        * `transitionFrames`: The total number of frames in the animation.
 *        * `vars`: Optional variables passed through the `vars` parameter.
 * @param {function} propertySetter - A function that sets the new value for the property on each entity.
 *    This function should take two arguments:
 *        * `entity`: The entity to apply the value to.
 *        * `newValue`: The calculated new value for the property.
 * @param {any} vars - Optional variable to pass to the `valueCalculator` function.
 *    This can be used to customize the animation behavior.
 * @param {number} transitionFrames - The total number of frames in the animation.
 *    If 0, it's calculated based on `animInfo.delay` and `animInfo.frameInterval`. (default: 0)
*/
animate["applyAnimation"] <- function(animInfo, valueCalculator, propertySetter, vars = null, transitionFrames = 0) {
    if(transitionFrames == 0) {
        if (animInfo.delay / animInfo.frameInterval > animInfo.maxFrames)  
            animInfo.frameInterval = animInfo.delay / animInfo.maxFrames
        
        transitionFrames = animInfo.delay / animInfo.frameInterval;
    }

    transitionFrames = ceil(transitionFrames) 
    local actionsList = List()

    for(local step = 0; step <= transitionFrames; step++) {
        local elapsed = (animInfo.frameInterval * step) + animInfo.globalDelay

        local newValue = valueCalculator(step, transitionFrames, vars)
        
        foreach(ent in animInfo.entities) {
            local action = ScheduleAction(this, propertySetter, elapsed, [ent, newValue])
            actionsList.append(action)
        }
    }

    ScheduleEvent.AddActions(animInfo.eventName, actionsList, true)
    animInfo.delay = FrameTime() * transitionFrames

    if(developer() > 0) dev.trace("Created {} animation ({}) for {} actions", animInfo.animName, animInfo.eventName, actionsList.len())
}

IncludeScript("SRC/Animations/alpha")
IncludeScript("SRC/Animations/color")
IncludeScript("SRC/Animations/position")
IncludeScript("SRC/Animations/angles")