# PCapture-Animate

The `animate` module provides a set of functions to smoothly animate entities in various ways. These functions allow you to transition the alpha value, color, position, or angles of entities over a specified time or based on speed. You can define event settings such as the event name, global delay, note, and outputs to execute with a specified delay.

To use these functions, pass the entities (or targetname) to animate, along with the necessary parameters for the specific animation type. You can also provide optional event settings to customize the animation behavior.

> **Note:**
> The `animate` module relies on the `CreateScheduleEvent` function from the PCapture-EventHandler module to schedule the animation events. To stop animation, call `cancelScheduledEvent(eventName/entity)`

## Animate Class

### AlphaTransition(entities, startOpacity, endOpacity, time, EventSetting = {eventName = null, globalDelay = 0, note = null, outputs = null})

Smoothly changes the alpha value of entities from the initial value to the final value over a specified time.
```
animate.AlphaTransition("box01", 255, 100, 1, {eventName = "test"})
```

- `entities` (pcapEntity|CBaseEntity|string): The entities (or targetname) to 
- `startOpacity` (int): The initial opacity value.
- `endOpacity` (int): The final opacity value.
- `time` (int|float): The duration of the animation in seconds.
- `EventSetting` (table, *optional*): The event settings.
  - `eventName` (string): The name of the event. If not provided, it will be inferred from the entities.
  - `globalDelay` (int): The global delay before starting the animation.
  - `note` (string, *optional*): note about the event.
  - `outputs` (string|function): Outputs to execute with a specified delay, if provided.

### ColorTransition(entities, startColor, endColor, time, EventSetting = {eventName = null, globalDelay = 0, note = null, outputs = null})

Smoothly changes the color of entities from start to end over time.
```
local ent = entLib.FindByName("box01")
animate.ColorTransition(ent, ent.GetColor(), "255 125 125", 1, {globalDelay = 1})
```
- `entities` (pcapEntity|CBaseEntity|string): The entities to 
- `startColor` (string|Vector): The starting color.
- `endColor` (string|Vector): The ending color.
- `time` (int|float): The duration in seconds.
- `EventSetting` (table, *optional*): The event settings.
  - `eventName` (string): The name of the event. If not provided, it will be inferred from the entities.
  - `globalDelay` (int): The global delay before starting the animation.
  - `note` (string, *optional*): note about the event.
  - `outputs` (string|function): Outputs to execute with a specified delay, if provided.

### PositionTransitionByTime(entities, startPos, endPos, time, EventSetting = {eventName = null, globalDelay = 0, note = null, outputs = null})

Moves entities from the start position to the end position over a specified time based on increments of time.
```
animate.PositionTransitionByTime(ent, ent.GetOrigin(), GetPlayer().GetOrigin(), 1, {outputs = 
  function():(ent) {
    ent.Destroy()
  }
})
```
- `entities` (pcapEntity|CBaseEntity|string): The entities (or targetname) to 
- `startPos` (Vector): The initial position.
- `endPos` (Vector): The final position.
- `time` (int|float): The duration of the animation in seconds.
- `EventSetting` (table, *optional*): The event settings.
  - `eventName` (string): The name of the event. If not provided, it will be inferred from the entities.
  - `globalDelay` (int): The global delay before starting the animation.
  - `note` (string, *optional*): note about the event.
  - `outputs` (string|function): Outputs to execute with a specified delay, if provided.

### PositionTransitionBySpeed(entities, startPos, endPos, speed, EventSetting = {eventName = null, globalDelay = 0, note = null, outputs = null})

Moves entities from the start position to the end position over a specified time based on speed.
```
animate.PositionTransitionBySpeed(ent, ent.GetOrigin(), GetPlayer().GetOrigin(), 3)
```
- `entities` (pcapEntity|CBaseEntity|string): The entities to 
- `startPos` (Vector): The initial position.
- `endPos` (Vector): The final position.
- `speed` (int|float): The speed at which to move the entities in units per second.
- `EventSetting` (table, *optional*): The event settings.
  - `eventName` (string): The name of the event. If not provided, it will be inferred from the entities.
  - `globalDelay` (int): The global delay before starting the animation.
  - `note` (string, *optional*): note about the event.
  - `outputs` (string|function): Outputs to execute with a specified delay, if provided.
- Returns: The time taken to complete the animation.

### AnglesTransitionByTime(entities, startAngles, endAngles, time, EventSetting = {eventName = null, globalDelay = 0, note = null, outputs = null})

Changes angles of entities from start to end over time.

- `entities` (pcapEntity|CBaseEntity|string): The entities.
- `startAngles` (Vector): Starting angles.
- `endAngles` (Vector): Ending angles.
- `time` (int|float): Duration in seconds.
- `EventSetting` (table, *optional*): Event settings.
  - `eventName` (string): The name of the event. If not provided, it will be inferred from the entities.
  - `globalDelay` (int): The global delay before starting the animation.
  - `note` (string, *optional*): note about the event.
  - `outputs` (string|function): Outputs to execute with a specified delay, if provided.
