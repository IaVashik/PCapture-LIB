# Animations Module

The `Animations` module provides functions for creating various animations in VScripts, such as fading objects in or out, changing their colors, and moving them along paths. It simplifies the process of creating smooth and visually appealing animations.

## [Animations/init.nut](init.nut)

This file initializes the `Animations` module, defines the `AnimEvent` class for managing animation events, and includes the necessary script files for the module's functionality.

### `AnimEvent`

The `AnimEvent` class is used to encapsulate information about an animation event. It stores details such as the event name, delay, global delay, scope, outputs (functions to call when the animation finishes), and the entities involved in the animation.

#### `AnimEvent(settings, entities, time)`

**Constructor**

Creates a new `AnimEvent` object with the specified settings, entities, and animation duration.

**Parameters:**

* `settings` (table): A table containing optional settings for the animation event:
* `eventName` (string, optional): The name of the event (default is a unique string starting with "anim").
* `globalDelay` (number, optional): A global delay in seconds before the animation starts (default is 0).
* `scope` (object, optional): The scope in which to execute the action (default is `this`).
* `outputs` (string or function, optional): A script or function to execute when the animation finishes.
* `entities` (array): An array of entities to animate.
* `time` (number): The duration of the animation in seconds.

### `applyAnimation(animSetting, valueCalculator, propertySetter)`

This function applies an animation over a specified duration, calculating and setting new values for a property at each frame. It is used internally by the various animation functions to handle the animation process.

**Parameters:**

* `animSetting` (AnimEvent): The `AnimEvent` object containing the animation settings and entities.
* `valueCalculator` (function): A function that calculates the new value for the property at each frame. The function should take two arguments:
* `step` (number): The current animation step (frame).
* `transitionFrames` (number): The total number of frames in the animation.
The function should return the new value for the property.
* `propertySetter` (function): A function that sets the new value for the property on each entity. The function should take two arguments:
* `ent` (pcapEntity): The entity to set the property on.
* `newValue` (any): The new value for the property.

**Example:**

```js
// ... (assuming you have animSetting, valueCalculator, and propertySetter defined)
animate.applyAnimation(animSetting, valueCalculator, propertySetter) // Apply the animation
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
* `animSetting` (table, optional): A table containing additional animation settings (see `AnimEvent` constructor for details).

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