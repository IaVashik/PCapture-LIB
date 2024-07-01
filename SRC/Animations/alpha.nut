/*
 * Creates an animation that transitions the alpha (opacity) of entities over time.
 *
 * @param {array|CBaseEntity|pcapEntity} entities - The entities to animate.
 * @param {number} startOpacity - The starting opacity value (0-255). 
 * @param {number} endOpacity - The ending opacity value (0-255). 
 * @param {number} time - The duration of the animation in seconds. 
 * @param {table} animSetting - A table containing additional animation settings. (optional) 
 * @returns {number} The duration of the animation in seconds. 
*/
animate["AlphaTransition"] <- function(entities, startOpacity, endOpacity, time, animSetting = {}) {
    local animSetting = AnimEvent("alpha", animSetting, entities, time)
    local vars = {
        startOpacity = startOpacity,
        opacityDelta = endOpacity - startOpacity,
        lerpFunc = animSetting.lerpFunc
    }

    animate.applyAnimation(
        animSetting, 
        function(step, steps, v) {return v.startOpacity + v.opacityDelta * v.lerpFunc(step / steps)},
        function(ent, newAlpha) {ent.SetAlpha(newAlpha)},
        vars
    )
    
    animSetting.callOutputs()
    return animSetting.delay
}