# ActionScheduler Module

The `ActionScheduler` module provides an enhanced system for creating and managing scheduled events in VScripts. It offers more flexibility and control compared to standard mechanisms like `EntFireByHandle`, allowing you to create complex events composed of multiple actions, schedule them with precise timing, and cancel them as needed.

## [ActionScheduler/event.nut](event.nut)

This file defines the `ScheduleEvent` class, which represents a scheduled event with information about its caller, action, execution time, optional note, and arguments.

### `ScheduleEvent`

This class encapsulates the details of a scheduled event, providing methods for executing the event and accessing its properties. **It's required for the CreateScheduleEvent**

**Properties:**

* `caller` (pcapEntity): The entity that created the event.
* `action` (string or function): The action to execute when the event is triggered. This can be a string containing VScripts code or a function object.
* `timeDelay` (number): The time at which the event is scheduled to be executed, measured in seconds since the start of the game.
* `note` (string, optional): An optional note describing the event, which can be useful for debugging or logging purposes.
* `args` (array, optional): Optional arguments to pass to the action function when the event is triggered.

**Methods:**

* `run()`: Executes the scheduled action. If the action is a string, it is compiled into a function before execution. If arguments are provided, they are passed to the action function. The return value of the action function is returned by the `run` method.


## [ActionScheduler/event_manager.nut](event_manager.nut)

This file provides functions for creating and managing scheduled events, including scheduling events, canceling events, and retrieving information about events.

### `CreateScheduleEvent(eventName, action, timeDelay, note, args)`

This function creates a new scheduled event and adds it to the list of scheduled events. If the event loop is not already running, it is started to process the scheduled events.

**Parameters:**

* `eventName` (string): The name of the event. This is used to group related events and to cancel events later.
* `action` (string or function): The action to execute when the event is triggered. This can be a string containing VScripts code or a function object.
* `timeDelay` (number): The delay in seconds before executing the event.
* `note` (string, optional): An optional note describing the event.
* `args` (array, optional): Optional arguments to pass to the action function.

**Example:**

```js
// Schedule an event to print a message after 1 second
CreateScheduleEvent("my_event", function() {
    printl("This is my scheduled event.")
}, 1)
```

### `cancelScheduledEvent(eventName, delay)`

This function cancels all scheduled events with the given name.

**Parameters:**

* `eventName` (string): The name of the event to cancel.
* `delay` (number, optional): An optional delay in seconds before canceling the event.

**Example:**

```js
// Cancel the "my_event" event after 0.5 seconds
cancelScheduledEvent("my_event", 0.5)
```

### `getEventInfo(eventName)`

This function retrieves information about a scheduled event with the given name.

**Parameters:**

* `eventName` (string): The name of the event to get information about.

**Returns:**

* (AVLTree or null): An AVL tree containing the scheduled `ScheduleEvent` objects for the event, or `null` if the event is not found.

**Example:**

```js
local eventInfo = getEventInfo("my_event")
if (eventInfo) {
    // ... process the event information
}
```

### `eventIsValid(eventName)`

This function checks if a scheduled event with the given name exists and has scheduled events.

**Parameters:**

* `eventName` (string): The name of the event to check.

**Returns:**

* (boolean): True if the event exists and has scheduled events, false otherwise.

**Example:**

```js
if (eventIsValid("my_event")) {
    // The event exists and has scheduled events
}
```

### `getEventNote(eventName)`

This function returns the note associated with the first scheduled event with the given name. It can be useful for retrieving additional information about the event's purpose.

**Parameters:**

* `eventName` (string): The name of the event.

**Returns:**

* (string or null): The note of the first event, or `null` if no note is found or the event doesn't exist.

**Example:**

```js
local eventNote = getEventNote("my_event")
if (eventNote) {
    printl("Event note:" + eventNote)
}
```

## [ActionScheduler/event_handler.nut](event_handler.nut)

This file defines the `ExecuteScheduledEvents` function, which processes scheduled events when their execution time arrives.

### `ExecuteScheduledEvents()`

This function iterates over all scheduled events and checks if their scheduled execution time has arrived. If so, it executes the event's action and removes it from the list of scheduled events. The function then schedules itself to run again after a short delay to continue processing events.

**Example:**

```js
// This function is called automatically by the Events module
ExecuteScheduledEvents()
```