

animate["AnglesTransitionByTime"] <- function(entities, startAngles, endAngles, time, animSetting = {}) {
    local animSetting = AnimEvent(animSetting, _GetValidEntitiy(entities))

    animate.applyAnimation(
        animSetting, 
        function(step, transitionFrames):(startAngles, endAngles) {return math.lerp.sVector(startAngles, endAngles, step / transitionFrames)},
        function(ent, newAngle) {ent.SetAbsAngles(newAngle)})
    
    animSetting.callOutputs()
}