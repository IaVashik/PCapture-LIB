
animate["AlphaTransition"] <- function(entities, startOpacity, endOpacity, time, animSetting = {}) {
    local animSetting = AnimEvent(animSetting, _GetValidEntitiy(entities))
    local alphaStep = (endOpacity - startOpacity) / transitionFrames;    

    animate.applyAnimation(
        animSetting, 
        function(step, _):(startOpacity, alphaStep) {return startOpacity + alphaStep * (step + 1)}, //? +1
        function(ent, newAlpha) {ent.SetAlpha(newAlpha)})
    
    animSetting.callOutputs()
}