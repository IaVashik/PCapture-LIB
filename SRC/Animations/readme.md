# Animations Module

The `Animations` module provides functions for creating various animations in VScripts, such as fading objects in or out, changing their colors, and moving them along paths. It simplifies the process of creating smooth and visually appealing animations.

## [Animations/init.nut](init.nut)

This file initializes the `Animations` module, defines the `AnimEvent` class for managing animation events, and includes the necessary script files for the module's functionality.

### `AnimEvent`

The `AnimEvent` class is used to encapsulate information about an animation event. It stores details such as the event name, delay, global delay, frame interval, maximum frames, scope, outputs (functions to call when the animation finishes), the entities involved in the animation, and an optional lerp function for customizing the animation curve. 

#### `AnimEvent(name, settings, entities, time = 0)`

**Constructor**

Creates a new `AnimEvent` object with the specified name, settings, entities, and animation duration. 

**Parameters:**

* `name` (string): The name of the animation type.
* `settings` (table): A table containing optional settings for the animation event. See the **Animation Settings Table** section below for details.
* `entities` (array, CBaseEntity, or pcapEntity): An array of entities, a single entity, or a pcapEntity to animate.
* `time` (number, optional): The duration of the animation in seconds (default is 0).

**Example:**

```js

// Create an AnimEvent object with custom settings
local animSettings = {
    eventName = "my_animation",
    globalDelay = 0.5,
    outputs = function() {
        printl("Animation completed!")
    },
    lerpFunc = math.lerp.InOutElastic,
    frameInterval = 0.1, // Custom frame interval
    maxFrames = 30 // Custom maximum frames
}

local entitiesToAnimate = [
    entLib.FindByClassname("prop_physics"),
    entLib.FindByClassname("prop_dynamic") 
]

// Create the AnimEvent object 
local animEvent = AnimEvent("my_animation_type", animSettings, entitiesToAnimate, 2)

// ... (Use animEvent with animate functions)
```

### Animation Settings Table

The `settings` table in the `AnimEvent` constructor can contain the following optional properties:

* `eventName` (string, optional): The name of the event (default is a unique string based on the animation name).
* `globalDelay` (number, optional): A global delay in seconds before the animation starts (default is 0).
* `outputs` (string or function, optional): A script or function to execute when the animation finishes.
* `scope` (object, optional): The scope in which to execute the action (default is the `AnimEvent` object itself).
* `lerp` (function, optional): A custom lerp function to use for interpolation. If not provided, a linear interpolation function is used.
* `note` (string, optional): A note or description for the animation event.
* `frameInterval` (number, optional): The time interval between frames in seconds (default is the engine's frame time).
* `fps` (number, optional): The desired frames per second for the animation, used to calculate `frameInterval` if it's not explicitly set (default is 60, maximum 60).


### `animate.applyAnimation(animInfo, valueCalculator, propertySetter, vars = null, transitionFrames = 0)`
This function applies an animation over a specified duration, calculating and setting new values for a property at each frame. It is used internally by the various animation functions to handle the animation process.

**Parameters:**

* `animInfo` (AnimEvent): The `AnimEvent` object containing the animation settings and entities.
* `valueCalculator` (function): A function that calculates the new value for the property at each frame. The function should take three arguments: current step, total steps, and optional variables.
* `propertySetter` (function): A function that sets the new value for the property on each entity. The function should take two arguments: the entity and the calculated value.
* `vars` (any, optional): Optional variables to pass to the `valueCalculator` function. Can be used for your custom animations
* `transitionFrames` (number, optional): The total number of frames in the animation. If 0, it's calculated based on `animInfo.delay` and `animInfo.frameInterval` (default is 0).


**Example:**

```js
// ... (assuming you have animInfo, valueCalculator, and propertySetter defined)
animate.applyAnimation(animInfo, valueCalculator, propertySetter) // Apply the animation
```

## [Animations/alpha.nut](alpha.nut)

This file provides the `animate.AlphaTransition` function for creating animations that transition the alpha (opacity) of entities over time.

### `animate.AlphaTransition(entities, startOpacity, endOpacity, time, animSetting)`

This function creates an animation that smoothly transitions the alpha (opacity) of entities from the starting value to the ending value over a specified time.

**Parameters:**

* `entities` (array, CBaseEntity, or pcapEntity): The entities to animate.
* `startOpacity` (number): The starting opacity value (0-255).
* `endOpacity` (number): The ending opacity value (0-255).
* `time` (number): The duration of the animation in seconds.
* `animSetting` (table, optional): A table containing additional animation settings (see **Animation Settings Table** in the `AnimEvent` constructor section for details).

**Returns:**

*   (number): The duration of the animation in seconds. 

**Example:**

```js
local myEntity = entLib.FindByClassname("prop_physics")
animate.AlphaTransition(myEntity, 255, 0, 2) // Fade out the entity over 2 seconds
```

## [Animations/color.nut](color.nut)

This file provides the `animate.ColorTransition` function for creating animations that transition the color of entities over time.

### `animate.ColorTransition(entities, startColor, endColor, time, animSetting)`

This function creates an animation that smoothly transitions the color of entities from the starting color to the ending color over a specified time.

**Parameters:**

* `entities` (array, CBaseEntity, or pcapEntity): The entities to animate.
* `startColor` (string or Vector): The starting color as a string (e.g., "255 0 0" for red) or a Vector with components (r, g, b).
* `endColor` (string or Vector): The ending color as a string or a Vector.
* `time` (number): The duration of the animation in seconds.
* `animSetting` (table, optional): A table containing additional animation settings (see `AnimEvent` constructor for details).

**Returns:**

*   (number): The duration of the animation in seconds. 

**Example:**

```js
local myEntity = entLib.FindByClassname("prop_physics")
animate.ColorTransition(myEntity, "255 0 0", "0 255 0", 3) // Change the entity's color from red to green over 3 seconds
```

## [Animations/position.nut](position.nut)

This file provides the `animate.PositionTransitionByTime` function for creating animations that transition the position of entities over time.

### `animate.PositionTransitionByTime(entities, startPos, endPos, time, animSetting)`

This function creates an animation that moves entities from the starting position to the ending position over a specified time based on increments of time.

**Parameters:**

* `entities` (array, CBaseEntity, or pcapEntity): The entities to animate.
* `startPos` (Vector): The starting position of the entities.
* `endPos` (Vector): The ending position of the entities.
* `time` (number): The duration of the animation in seconds.
* `animSetting` (table, optional): A table containing additional animation settings (see `AnimEvent` constructor for details).

**Returns:**

*   (number): The duration of the animation in seconds. 

**Example:**

```js
local myEntity = entLib.FindByClassname("prop_physics")
local startPos = myEntity.GetOrigin()
local endPos = startPos + Vector(0, 100, 0) // Move 100 units along the Y axis
animate.PositionTransitionByTime(myEntity, startPos, endPos, 5) // Move the entity over 5 seconds
```

### `animate.PositionTransitionBySpeed(entities, startPos, endPos, speed, animSetting)`

This function creates an animation that transitions the position of entities over time based on a specified speed. The animation calculates the time it takes to travel from the start position to the end position based on the provided speed and creates a smooth transition of the entities' positions over that duration.

**Parameters:**

* `entities` (array, CBaseEntity, or pcapEntity): The entities to animate.
* `startPos` (Vector): The starting position of the entities.
* `endPos` (Vector): The ending position of the entities.
* `speed` (number): The speed of the animation in units per tick.
* `animSetting` (table, optional): A table containing additional animation settings (see the `AnimEvent` constructor for details).

**Returns:**

*   (number): The duration of the animation in seconds. 

**Example:**

```js
local myEntity = entLib.FindByClassname("prop_physics")
local startPos = myEntity.GetOrigin()
local endPos = startPos + Vector(100, 0, 0) // Move 100 units to the right
animate.PositionTransitionBySpeed(myEntity, startPos, endPos, 50) // Animate the movement over time with a speed of 50 units per tick
```

## [Animations/angles.nut](angles.nut)

This file provides the `animate.AnglesTransitionByTime` function for creating animations that transition the angles of entities over time.

### `animate.AnglesTransitionByTime(entities, startAngles, endAngles, time, animSetting)`

This function creates an animation that smoothly changes the angles of entities from the starting angles to the ending angles over a specified time.

**Parameters:**

* `entities` (array, CBaseEntity, or pcapEntity): The entities to animate.
* `startAngles` (Vector): The starting angles of the entities (pitch, yaw, roll).
* `endAngles` (Vector): The ending angles of the entities (pitch, yaw, roll).
* `time` (number): The duration of the animation in seconds.
* `animSetting` (table, optional): A table containing additional animation settings (see `AnimEvent` constructor for details).

**Returns:**

*   (number): The duration of the animation in seconds. 

**Example:**

```js
local myEntity = entLib.FindByClassname("prop_physics")
local startAngles = myEntity.GetAngles()
local endAngles = startAngles + Vector(0, 90, 0) // Rotate 90 degrees around the Y axis
animate.AnglesTransitionByTime(myEntity, startAngles, endAngles, 2) // Rotate the entity over 2 seconds
```