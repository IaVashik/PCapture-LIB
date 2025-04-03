/*
 * Creates an animation that transitions the position of entities over time.
 *
 * @param {array|CBaseEntity|pcapEntity} entities - The entities to animate.
 * @param {Vector} startPos - The starting position. 
 * @param {Vector} endPos - The ending position. 
 * @param {number} time - The duration of the animation in seconds. 
 * @param {table} animSetting - A table containing additional animation settings. (optional) 
 * @returns {number} The duration of the animation in seconds. 
*/
animate["PositionTransitionByTime"] <- function(entities, startPos, endPos, time, animSetting = {}) {
    local animSetting = AnimEvent("position", animSetting, entities, time)
    local vars = {
        startPos = startPos,
        dist = endPos - startPos,
        easeFunc = animSetting.easeFunc
    }

    animate.applyAnimation(
        animSetting, 
        function(step, steps, v) {return v.startPos + v.dist * v.easeFunc(step / steps)},
        function(ent, newPosition) {ent.SetAbsOrigin(newPosition)},
        vars
    )
    
    return animSetting.delay
}

animate.RT["PositionTransitionByTime"] <- function(entities, startPos, endPos, time, animSetting = {}) {
    local animSetting = AnimEvent("position", animSetting, entities, time)
    local vars = {
        startPos = startPos,
        dist = endPos - startPos,
        easeFunc = animSetting.easeFunc
    }

    animate.applyRTAnimation(
        animSetting, 
        function(step, steps, v) {return v.startPos + v.dist * v.easeFunc(step / steps)},
        function(ent, newPosition) {ent.SetAbsOrigin(newPosition)},
        vars
    )
    
    return animSetting.delay
}


/*
 * Creates an animation that transitions the position of entities over time based on a specified speed. 
 *
 * @param {array|CBaseEntity|pcapEntity} entities - The entities to animate.
 * @param {Vector} startPos - The starting position.
 * @param {Vector} endPos - The ending position.
 * @param {number} speed - The speed of the animation in units per tick.
 * @param {table} animSetting - A table containing additional animation settings. (optional)
 * 
 * The animation will calculate the time it takes to travel from the start position to the end position based on the specified speed. 
 * It will then use this time to create a smooth transition of the entities' positions over that duration.
 * @returns {number} The duration of the animation in seconds. 
*/
animate["PositionTransitionBySpeed"] <- function(entities, startPos, endPos, speed, animSetting = {}) {
    local animSetting = AnimEvent("position", animSetting, entities)
    local vars = {
        startPos = startPos,
        dist = endPos - startPos,
        easeFunc = animSetting.easeFunc
    }
    
    animate.applyAnimation(
        animSetting, 
        function(step, steps, v) {return v.startPos + v.dist * v.easeFunc(step / steps)},
        function(ent, newPosition) {ent.SetAbsOrigin(newPosition)},
        vars,
        vars.dist.Length() / speed.tofloat() // steps
    )
    
    return animSetting.delay
} 

animate.RT["PositionTransitionBySpeed"] <- function(entities, startPos, endPos, speed, animSetting = {}) {
    local animSetting = AnimEvent("position", animSetting, entities)
    local vars = {
        startPos = startPos,
        dist = endPos - startPos,
        easeFunc = animSetting.easeFunc
    }
    
    animate.applyRTAnimation(
        animSetting, 
        function(step, steps, v) {return v.startPos + v.dist * v.easeFunc(step / steps)},
        function(ent, newPosition) {ent.SetAbsOrigin(newPosition)},
        vars,
        vars.dist.Length() / speed.tofloat() // steps
    )
    
    return animSetting.delay
} 