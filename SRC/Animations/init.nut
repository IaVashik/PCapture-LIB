/*+--------------------------------------------------------------------------------+
|                           PCapture Vscripts Library                               |
 +---------------------------------------------------------------------------------+
| Author:                                                                           |
|     One-of-a-Kind - laVashik :D                                                   |
 +---------------------------------------------------------------------------------+
| PCapture-anims.nut                                                                 |
|       Animation module, used to quickly create animation events                    |
|       related to alpha, color, object moving                                       |
+----------------------------------------------------------------------------------+ */

::animate <- {}

::AnimEvent <- class {
    eventName = null
    delay = 0
    globalDelay = 0
    note = null
    outputs = null
    entities = []

    constructor(table, ents, time) {
        this.entities = ents
        this.delay = time

        this.eventName = macros.GetFromTable(table, "eventName", UniqueString("anim")) //! mega bruh! Use link id, hash or str?
        this.globalDelay = macros.GetFromTable(table, "globalDelay", 0)
        this.note = macros.GetFromTable(table, "note", null)
        this.outputs = macros.GetFromTable(table, "outputs", null)
    }

    function callOutputs() {
        if (this.outputs)
            CreateScheduleEvent(this.eventName, this.outputs, this.time)
    }
}

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