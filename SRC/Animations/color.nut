
animate["ColorTransition"] <- function(entities, startColor, endColor, time, animSetting = {}) {
    local animSetting = AnimEvent(animSetting, _GetValidEntitiy(entities))

    animate.applyAnimation(
        animSetting, 
        function(step, transitionFrames):(startColor, endColor) {return math.lerp.color(startColor, endColor, step / transitionFrames)},
        function(ent, newColor) {ent.SetColor(newColor)})
    
    animSetting.callOutputs()
}