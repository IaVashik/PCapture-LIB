/*
 * Creates an animation that transitions the position of entities over time.
 *
 * @param {array|CBaseEntity|pcapEntity} entities - The entities to animate.
 * @param {Vector} startPos - The starting position. 
 * @param {Vector} endPos - The ending position. 
 * @param {number} time - The duration of the animation in seconds. 
 * @param {table} animSetting - A table containing additional animation settings. (optional) 
 */
 animate["PositionTransitionByTime"] <- function(entities, startPos, endPos, time, animSetting = {}) {
    local animSetting = AnimEvent(animSetting, _GetValidEntitiy(entities), time)
    
    local dist = endPos - startPos
    local coordStep = dist.Length() / abs(time / FrameTime())

    animate.applyAnimation(
        animSetting, 
        function(step, _):(startPos, dist, coordStep) {return startPos + dist * (tick / coordStep)},
        function(ent, newPosition) {ent.SetAbsOrigin(newPosition)})
    
    animSetting.callOutputs()
}


//! BROKEN NOW, FIX!
// animate["PositionTransitionBySpeed"] <- function(entities, startPos, endPos, speed, animSetting = {}) {
//     local animSetting = AnimEvent(animSetting, _GetValidEntitiy(entities))
    
//     local distance = endPos - startPos
//     local dir = (endPos - startPos)
//     dir.Norm()

//     // local steps = abs(distance.Length() / speed)

//     animate.applyAnimation(
//         animSetting, 
//         function(step, _):(startPos, dir, speed) {return startPos + (dir * speed * step)},
//         function(ent, newPosition) {ent.SetAbsOrigin(newPosition)})
    
//     animSetting.callOutputs()
// }