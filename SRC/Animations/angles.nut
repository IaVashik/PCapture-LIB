/*
 * Creates an animation that transitions the angles of entities over time.
 *
 * @param {array|CBaseEntity|pcapEntity} entities - The entities to animate.
 * @param {Vector} startAngles - The starting angles. 
 * @param {Vector} endAngles - The ending angles. 
 * @param {number} time - The duration of the animation in seconds. 
 * @param {table} animSetting - A table containing additional animation settings. (optional) 
 * @returns {number} The duration of the animation in seconds. 
*/
 animate["AnglesTransitionByTime"] <- function(entities, startAngles, endAngles, time, animSetting = {}) {
    local animSetting = AnimEvent("angles", animSetting, entities, time)

    animate.applyAnimation(
        animSetting, 
        function(step, transitionFrames):(startAngles, endAngles) {return math.lerp.sVector(startAngles, endAngles, step / transitionFrames)},
        function(ent, newAngle) {ent.SetAbsAngles(newAngle)})
    
    animSetting.callOutputs()
    return animSetting.delay
}