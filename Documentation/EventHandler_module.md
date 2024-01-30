# PCapture-EventHandler

Improved event handling module for creating and canceling scheduled events a more controlled and versatile way of creating scheduled events compared to built-in functions like `EntFireByHandler` or `logic_timer`. It allows you to create and manage events by providing the event name, action to execute, time delay, and an *optional* note to track the event's progress or for other purposes.

## Usage

CreateScheduleEvent is used to create a new scheduled event. You specify the event name, the action to execute (either a string or a function), the time delay in seconds, and an *optional* note. The event will be executed after the specified delay.

cancelScheduledEvent allows you to cancel a scheduled event with the given name. You can also specify an *optional* delay before the cancelation.

getEventInfo retrieves information about a scheduled event. This can be useful for debugging or tracking the progress of an event.

eventIsValid checks if a scheduled event is valid, meaning it exists and contains events.

getEventNote retrieves the note associated with a scheduled event. This can be useful for tracking additional information about the event.

## Functions

### CreateScheduleEvent(eventName, action, timeDelay, note = null)

Creates a new scheduled event.

```
CreateScheduleEvent("EventName", "printl(\"Scheduled Event!\")", 1.5)
```
- `eventName` (string): Name of the event.
- `action` (string|function): Action to execute for the event.
- `timeDelay` (int|float): Delay in seconds before executing the event.
- `note` (string, *optional*): *optional* note about the event.

### cancelScheduledEvent(eventName, delay = 0)

Cancels a scheduled event with the given name.

```
cancelScheduledEvent("EventName", 2.5)
```
- `eventName` (string): Name of the event to cancel.
- `delay` (int|float, *optional*): Delay in seconds before cancelation.
> **Note:** The global event cannot be closed using this function.

### getEventInfo(eventName)

Gets information about a scheduled event.

```
local eventInfo = getEventInfo("EventName")
print(eventInfo.action) // Output: printl("Scheduled Event!")
```
- `eventName` (string): Name of the event to get information for.
- Returns: The event info object or null if not found.

### eventIsValid(eventName)

Checks if a scheduled event is valid.

```
local isValid = eventIsValid("EventName")
```
- `eventName` (string): Name of the event.
- Returns: True if the event exists and contains events, otherwise false.

### getEventNote(eventName)

Gets the note associated with a scheduled event.

```
local note = getEventNote("EventName")
```
- `eventName` (string): Name of the event.
- Returns: The note for the event or null if not found.