# Script Events Module

This module provides a framework for creating and managing custom "game events" within VScript, similar to Source Engine's Game Events. These events, referred to as VGameEvents (VScript Game Events), allow for modular and extensible scripting by enabling different parts of your code to communicate and react to specific occurrences without direct coupling. This is particularly useful for creating custom mechanics and extending existing functionality.

## Table of Contents

* [`ScriptEvents/game_event.nut`](#scripteventsgame_eventnut)
	* [`VGameEvent(eventName, triggerCount = -1, actionsList = null)`](#vgameeventeventname-triggercount---1-actionslist--null)
	* [`AddAction(actionFunction)`](#addactionactionfunction)
	* [`ClearActions()`](#clearactions)
	* [`SetFilter(filterFunc)`](#setfilterfilterfunc)
	* [`Trigger(args = null)`](#triggerargs--null)
	* [`ForceTrigger(args = null)`](#forcetriggerargs--null)
* [`ScriptEvents/event_listener.nut`](#scripteventsevent_listenernut)
	* [`Notify(eventName, ...)`](#notifyeventname)
	* [`GetEvent(EventName)`](#geteventeventname)
* [`Creating and Using VGameEvents`](#creating-and-using-vgameevents)

## [ScriptEvents/game_event.nut](game_event.nut)

### `VGameEvent`

The `VGameEvent` class represents a custom game event. It encapsulates the event's name, trigger conditions, actions to be performed when triggered, and optional filters.

#### `VGameEvent(eventName, triggerCount = -1, actionsList = null)`

**Constructor**

Creates a new `VGameEvent` object.

**Parameters:**

* `eventName` (string): The unique name of the event.
* `triggerCount` (number, optional): The number of times the event can be triggered before becoming inactive. Set to -1 for unlimited triggers (default is -1).
* `actionsList` (function, optional): An initial action function to be added to the event's action list.


**Example:**

```squirrel
// Create a new VGameEvent named "my_custom_event"
local myEvent = VGameEvent("my_custom_event")

// Create a VGameEvent with a limited trigger count and an initial action
local limitedEvent = VGameEvent("limited_event", 3, function(event, data) { 
    printl("Limited event triggered with data: " + data) 
})
```


#### `AddAction(actionFunction)`

Adds an action function to the event's action list. This function will be executed when the event is triggered.

**Parameters:**

* `actionFunction` (function): The function to execute when the event is triggered. The function should accept the event object and any additional arguments passed during the trigger as parameters.


**Example:**

```squirrel
// Add an action to the "my_custom_event" event
myEvent.AddAction(function(event, message) { 
    printl("Event triggered: " + event.eventName + " with message: " + message) 
})
```

#### `ClearActions()`

Clears all action functions associated with the event.

**Example:**

```squirrel
// Clear all actions for the "my_custom_event" event
myEvent.ClearActions()
```


#### `SetFilter(filterFunc)`

Sets a filter function for the event. The filter function will be executed before triggering the event's actions. If the filter function returns `false`, the event's actions will not be executed.

**Parameters:**

* `filterFunc` (function): The function to use for filtering trigger conditions. The function should accept any arguments passed during the trigger as parameters and return `true` to allow the event to trigger, or `false` to prevent it.


**Example:**

```squirrel
// Set a filter function for the "my_custom_event" event
myEvent.SetFilter(function(player) {
    // Only trigger the event if the player's health is above 50
    return player.GetHealth() > 50
})
```

#### `Trigger(args = null)`

Triggers the event if the trigger count allows and the filter function (if set) returns `true`.

**Parameters:**

* `args` (any, optional): Optional arguments to pass to the action functions.


**Example:**

```squirrel
// Trigger the "my_custom_event" event
myEvent.Trigger("Hello from the event!")
```


#### `ForceTrigger(args = null)`

Forces the event to trigger, ignoring the filter function and trigger count.

**Parameters:**

* `args` (any, optional): Optional arguments to pass to the action functions.


**Example:**

```squirrel
// Force trigger the "my_custom_event" event
myEvent.ForceTrigger("This will always trigger!")
```

## [ScriptEvents/event_listener.nut](event_listener.nut)

### `EventListener`

The `EventListener` object provides a global interface for interacting with VGameEvents.

#### `Notify(eventName, ...)`

Notifies the listener of a triggered event. This function will attempt to trigger the event with the given name, passing any additional arguments to the event's action functions.

**Parameters:**

* `eventName` (string): The name of the event to trigger.
* `...` (any): Optional arguments to pass to the event's action functions.


**Example:**

```squirrel
// Trigger the "my_custom_event" event using EventListener
EventListener.Notify("my_custom_event", "Hello from EventListener!")
```

#### `GetEvent(EventName)`

Retrieves a VGameEvent object by its name.

**Parameters:**

* `EventName` (string): The name of the event to retrieve.

**Returns:**

* `VGameEvent|null`: The VGameEvent object if found, or `null` if the event does not exist.


**Example:**

```squirrel
// Get the "my_custom_event" VGameEvent object
local myEvent = EventListener.GetEvent("my_custom_event")
```

## Creating and Using VGameEvents

1. **Define your events:** Create `VGameEvent` objects, typically in a central location, giving them descriptive names.

2. **Add actions:** Use the `AddAction` method to define the behavior that should occur when the event is triggered.

3. **Trigger events:** Use `EventListener.Notify` to trigger the event by name in your code.

4. **Handle events:** The action functions you defined will be executed when the event is triggered, allowing you to respond to the event in a modular and decoupled manner.

**Real Examples from Project Capture:**

**Defining Events:**

```squirrel
PCaptureGameEvents <- {
    /* Core ASQRA Camera Events */
    CameraPicked = GameEvent("asqra_camera_picked_up"),                 /* Triggered when the ASQRA camera is picked up. */
    MemoryFlushed = GameEvent("asqra_memory_flushed"),                  /* Triggered when the camera's memory is flushed, clearing all captured objects. */ 
    ModeChanged = GameEvent("asqra_mode_changed"),                      /* Triggered when the camera mode changes between Capture and Placement modes. */
    // ... more events
}
```

**Triggering Events:**

Events can be triggered from various parts of the code, for example, when a specific action occurs:

```squirrel
function ASQRA::FlushMemory() {
    this.EnableCameraMode()

    // ... other logic ...

    // Trigger the MemoryFlushed event
    EventListener.Notify("asqra_memory_flushed", this) // `this` is the ASQRA
}
```

**Adding Actions (Handling Events):**

You can add actions to events to define how the game should respond when the event is triggered:

```squirrel
// Add an action to the ModeChanged event
PCaptureGameEvents.ModeChanged.AddAction(function(event, camera) { 
    // Display a message on the camera entity when the mode changes
    camera.ShowMessage("Mode changed") 
}) 
```

This module provides a powerful tool for creating complex and extensible VScript systems by facilitating communication and event-driven logic within your scripts. By defining and triggering custom events, you can create more modular and maintainable code, making it easier to add new features and modify existing behavior without affecting other parts of your script.