/*
 * Creates an animation that transitions the color of entities over time.
 *
 * @param {array|CBaseEntity|pcapEntity} entities - The entities to animate.
 * @param {string|Vector} startColor - The starting color as a string (e.g., "255 0 0") or a Vector. 
 * @param {string|Vector} endColor - The ending color as a string or a Vector. 
 * @param {number} time - The duration of the animation in seconds. 
 * @param {table} animSetting - A table containing additional animation settings. (optional) 
*/
 animate["ColorTransition"] <- function(entities, startColor, endColor, time, animSetting = {}) {
    local animSetting = AnimEvent("color", animSetting, entities, time)

    animate.applyAnimation(
        animSetting, 
        function(step, transitionFrames):(startColor, endColor) {return math.lerp.color(startColor, endColor, step / transitionFrames)},
        function(ent, newColor) {ent.SetColor(newColor)})
    
    animSetting.callOutputs()
}