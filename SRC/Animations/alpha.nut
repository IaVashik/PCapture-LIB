/*
 * Creates an animation that transitions the alpha (opacity) of entities over time.
 *
 * @param {array|CBaseEntity|pcapEntity} entities - The entities to animate.
 * @param {number} startOpacity - The starting opacity value (0-255). 
 * @param {number} endOpacity - The ending opacity value (0-255). 
 * @param {number} time - The duration of the animation in seconds. 
 * @param {table} animSetting - A table containing additional animation settings. (optional) 
*/
 animate["AlphaTransition"] <- function(entities, startOpacity, endOpacity, time, animSetting = {}) {
    local animSetting = AnimEvent("alpha", animSetting, entities, time)
    local transitionFrames = time / FrameTime();    
    local alphaStep = (endOpacity - startOpacity) / transitionFrames;    

    animate.applyAnimation(
        animSetting, 
        function(step, _):(startOpacity, alphaStep) {return startOpacity + alphaStep * (step + 1)}, //? +1
        function(ent, newAlpha) {ent.SetAlpha(newAlpha)})
    
    animSetting.callOutputs()
}