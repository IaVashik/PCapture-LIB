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
    
    local dist = endPos - startPos

    animate.applyAnimation(
        animSetting, 
        function(step, steps):(startPos, dist) {return startPos + dist * (step / steps)},
        function(ent, newPosition) {ent.SetOrigin(newPosition)}
    )
    
    animSetting.callOutputs()
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
    
    local dist = endPos - startPos
    local steps = dist.Length() / speed.tofloat()
    
    animate.applyAnimation(
        animSetting, 
        function(step, steps):(startPos, dist) {return startPos + dist * (step / steps)},
        function(ent, newPosition) {ent.SetOrigin(newPosition)}
        steps
    )
    
    animSetting.callOutputs()
    return animSetting.delay
} 