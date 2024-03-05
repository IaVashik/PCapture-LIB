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

if("animate" in getroottable()) {
    dev.warning("Animate module initialization skipped. Module already initialized.")
    return
}

/*
* Gets a valid event name for the entities.
* 
* @param {pcapEntity|CBaseEntity|string} entities - The entities.
* @param {object} EventSetting - The event settings.
* @returns {string} The event name. 
*/
local _GetValidEventName = function(entities, EventSetting) {
    if (!("eventName" in EventSetting && EventSetting.eventName)) {
        if(typeof entities == "array")
            return entities[0].GetClassname() 
    }

    // if(eventIsValid(EventSetting.eventName)) {
    //     cancelScheduledEvent(EventSetting.eventName)
    // }

    return EventSetting.eventName
}


/*
* Gets valid entity/entities from input.
*
* @param {pcapEntity|CBaseEntity|string} entities - The entity input.  
* @returns {array(pcapEntity)} Valid entity/entities.
*/ 
local _GetValidEntitiy = function(entities) {
    if (typeof entities == "string") {
        if(entities.find("*") == null)
            return [entLib.FindByName(entities)]
        else {
            local ents = []
            for(local ent; ent = entLib.FindByName(entities, ent);)
                ents.append(ent)
            return ents
        }
    }
            
    if (typeof entities != "pcapEntity")
            return [entLib.FromEntity(entities)]
    
    return [entities]
}

::animate <- {
    /* 
    * Smoothly changes the alpha value of an entities from the initial value to the final value over a specified time.
    * 
    * @param {pcapEntity|CBaseEntity|string} entities - The entities (or targetname) to animate.
    * @param {int} startOpacity - The initial opacity value.
    * @param {int} endOpacity - The final opacity value.
    * @param {int|float} time - The duration of the animation in seconds.
    * @param {object} EventSetting - The event settings.
    */ 
    AlphaTransition = function(entities, startOpacity, endOpacity, time, 
        EventSetting = {eventName = null, globalDelay = 0, note = null, outputs = null}) : (_GetValidEventName, _GetValidEntitiy) {

        entities = _GetValidEntitiy(entities)
        // if(entities[0].GetAlpha() == endOpacity) // todo bruh
        //     return 
        
        local eventName = _GetValidEventName(entities, EventSetting)
        local globalDelay = "globalDelay" in EventSetting ? EventSetting.globalDelay : 0
        local note = "note" in EventSetting ? EventSetting.note : null

        local transitionFrames = time / FrameTime();
        local alphaStep = (endOpacity - startOpacity) / transitionFrames;    

        // Smoothly change alpha on each frame
        for (local step = 0; step < transitionFrames; step++) {
            local elapsed = (FrameTime() * step) + globalDelay

            // Calculate the new alpha for the current frame
            local newAlpha = startOpacity + alphaStep * (step + 1);
            
            foreach(ent in entities) {
                local action = function() : (ent, newAlpha) {
                    ent.SetAlpha(newAlpha)
                }
                CreateScheduleEvent(eventName, action, elapsed, note)
            }
        }
        
        // Execute outputs with a specified delay, if provided
        if ("outputs" in EventSetting && EventSetting.outputs) {
            CreateScheduleEvent(eventName, EventSetting.outputs, time)
        }
    },


    /*  
    * Smoothly changes the color of entities from start to end over time. 
    *
    * @param {pcapEntity|CBaseEntity|string} entities - The entities.
    * @param {string|Vector} startColor - The starting color.
    * @param {string|Vector} endColor - The ending color.
    * @param {int|float} time - The duration in seconds.  
    * @param {object} EventSetting - The event settings.
    */
    ColorTransition = function(entities, startColor, endColor, time,
        EventSetting = {eventName = null, globalDelay = 0, note = null, outputs = null}) : (_GetValidEventName, _GetValidEntitiy) {

        entities = _GetValidEntitiy(entities)
        local eventName = _GetValidEventName(entities, EventSetting)
        local globalDelay = "globalDelay" in EventSetting ? EventSetting.globalDelay : 0
        local note = "note" in EventSetting ? EventSetting.note : null

        local transitionFrames = abs(time / FrameTime())
        for (local step = 0.0; step <= transitionFrames; step++) {
            local elapsed = (FrameTime() * step) + globalDelay

            local newColor = math.lerp.color(startColor, endColor, step / transitionFrames) 

            foreach(ent in entities) {
                local action = function() : (ent, newColor) {
                    ent.SetColor(newColor)
                }
                CreateScheduleEvent(eventName, action, elapsed, note)
            }
        }

        // Execute outputs with a specified delay, if provided
        if ("outputs" in EventSetting && EventSetting.outputs) {
            CreateScheduleEvent(eventName, EventSetting.outputs, time)
        }
    },


    /* 
    * Moves an entities from the start position to the end position over a specified time based on increments of time.
    * 
    * @param {pcapEntity|CBaseEntity|string} entities - The entities (or targetname) to animate.
    * @param {Vector} startPos - The initial position.
    * @param {Vector} endPos - The final position.
    * @param {int|float} time - The duration of the animation in seconds.
    * @param {object} EventSetting - The event settings.
    */ 
    PositionTransitionByTime = function(entities, startPos, endPos, time, 
        EventSetting = {eventName = null, globalDelay = 0, note = null, outputs = null}) : (_GetValidEventName, _GetValidEntitiy) {
        
        entities = _GetValidEntitiy(entities)
        local eventName = _GetValidEventName(entities, EventSetting)
        local globalDelay = "globalDelay" in EventSetting ? EventSetting.globalDelay : 0

        local steps = abs(time / FrameTime())
        local dist = endPos - startPos
        local coordStep = dist.Length() / steps

        for (local tick = 1; tick <= steps; tick++) {
            local newPosition = startPos + dist * (tick / coordStep)
            local elapsed = (FrameTime() * tick) + globalDelay
            local note = "note" in EventSetting ? EventSetting.note : newPosition

            foreach(ent in entities) {
                local action = function() : (ent, newPosition) {
                    ent.SetOrigin(newPosition)
                }
                CreateScheduleEvent(eventName, action, elapsed, note)
            }
            
        }

        // Execute outputs with a specified delay, if provided
        if ("outputs" in EventSetting && EventSetting.outputs) {
            CreateScheduleEvent(eventName, EventSetting.outputs, time)
        }
    },
    
    
    /* Moves an entities from the start position to the end position over a specified time based on speed.
    * 
    * @param {pcapEntity|CBaseEntity|string} entities - The entities to animate.
    * @param {Vector} startPos - The initial position.
    * @param {Vector} endPos - The final position.
    * @param {int|float} speed - The speed at which to move the entities in units per second.
    * @param {object} EventSetting - The event settings.
    * @returns {number} - The time taken to complete the animation.
    */ 
    PositionTransitionBySpeed = function(entity, startPos, endPos, speed, 
        EventSetting = {eventName = null, globalDelay = 0, note = null, outputs = null}) : (_GetValidEventName, _GetValidEntitiy) {
        
        local entities = _GetValidEntitiy(entity)
        local eventName = _GetValidEventName(entities, EventSetting)
        local globalDelay = "globalDelay" in EventSetting ? EventSetting.globalDelay : 0

        local distance = endPos - startPos
        local dir = (endPos - startPos)
        dir.Norm()

        local steps = abs(distance.Length() / speed)
        for (local tick = 1; tick <= steps; tick++) {
            local newPosition = startPos + (dir * speed * tick)
            local elapsed = (FrameTime() * tick) + globalDelay
            local note = "note" in EventSetting ? EventSetting.note : newPosition
        
            foreach(ent in entities) {
                local action = function() : (ent, newPosition) {
                    ent.SetOrigin(newPosition)
                }
                CreateScheduleEvent(eventName, action, elapsed, note)
            }

        }


        // Execute outputs with a specified delay, if provided
        if ("outputs" in EventSetting && EventSetting.outputs) {
            CreateScheduleEvent(eventName, EventSetting.outputs, time)
        }
        return steps * FrameTime()
    },


    /*
    * Changes angles of entities from start to end over time.
    *
    * @param {pcapEntity|CBaseEntity|string} entities - The entities.
    * @param {Vector} startAngles - Starting angles.  
    * @param {Vector} endAngles - Ending angles.
    * @param {int|float} time - Duration in seconds. 
    * @param {object} EventSetting - Event settings.
    */  
    AnglesTransitionByTime = function(entity, startAngles, endAngles, time, 
        EventSetting = {eventName = null, globalDelay = 0, note = null, outputs = null}) : (_GetValidEventName, _GetValidEntitiy) {
        
        local entities = _GetValidEntitiy(entity)
        local eventName = _GetValidEventName(entities, EventSetting)
        local globalDelay = "globalDelay" in EventSetting ? EventSetting.globalDelay : 0
        local note = "note" in EventSetting ? EventSetting.note : null
    
        local transitionFrames = abs(time / FrameTime())

        for(local step = 0.0; step <= transitionFrames; step++) {
            local elapsed = (FrameTime() * step) + globalDelay
    
            local newAngle = math.lerp.sVector(startAngles, endAngles, step / transitionFrames) 
    
            foreach(ent in entities) {
                local action = function() : (ent, newAngle) {
                    ent.SetAbsAngles(newAngle)
                }
                CreateScheduleEvent(eventName, action, elapsed, note)
            }
        }

    
        // Execute outputs with a specified delay, if provided
        if ("outputs" in EventSetting && EventSetting.outputs) {
            CreateScheduleEvent(eventName, EventSetting.outputs, time)
        }
    }
}
