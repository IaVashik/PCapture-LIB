/*
 * Creates a function that animates a property of one or more entities.
 * 
 * @param {string} name - The name of the animation. This name is used to identify the animation internally. 
 * @param {function} propertySetterFunc - A function that takes an entity and a value, and sets a property on that entity. This function will be called repeatedly during the animation to update the property.
 * @returns {function} - A function that can be used to start the animation. This function takes the following arguments:
 *   * `entities` {array|pcapEntity} - An array of entities or a single entity to animate.
 *   * `startValue` {any} - The starting value for the property.
 *   * `endValue` {any} - The ending value for the property.
 *   * `time` {number} - The duration of the animation in seconds.
 *   * `animSetting` {table} (optional) - A table of additional animation settings. See the `AnimEvent` constructor for details.
*/
macros["BuildAnimateFunction"] <- function(name, propertySetterFunc) {
    return function(entities, startValue, endValue, time, animSetting = {}) : (name, propertySetterFunc) {
        local animSetting = AnimEvent(name, animSetting, entities, time) 
        local varg = {
            start = startValue,
            delta = endValue - startValue,
            lerpFunc = animSetting.lerpFunc
        }

        animate.applyAnimation(
            animSetting,
            function(step, steps, v) {return v.start + v.delta * v.lerpFunc(step / steps)},
            propertySetterFunc
            varg
        ) 

        animSetting.callOutputs() 
        return animSetting.delay
    }
}