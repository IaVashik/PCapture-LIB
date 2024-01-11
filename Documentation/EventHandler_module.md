# PCapture-EventHandler

Improved event handling module for creating and canceling scheduled events.

### CreateScheduleEvent(eventName, action, timeDelay, note = null)

Creates a new scheduled event.

```
CreateScheduleEvent("EventName", "printl(\"Scheduled Event!\")", 1.5)
```

- eventName - Name of the event
- action - Action to execute for the event (string or function)
- timeDelay - Delay in seconds before executing the event
- note - Optional note about the event (default null)

### cancelScheduledEvent(eventName, delay = 0)

Cancels a scheduled event with the given name.

```
cancelScheduledEvent("EventName", 2.5)
```

- eventName - Name of the event to cancel
- delay - Delay in seconds before cancelation (default 0)

> **Note:** The global event cannot be closed using this function.

### getEventInfo(eventName)

Gets information about a scheduled event.

```
local eventInfo = getEventInfo("EventName")
```

- eventName - Name of the event to get information for

Returns the event info object or null if not found.

### eventIsValid(eventName)

Checks if a scheduled event is valid.

```
local isValid = eventIsValid("EventName")
```

- eventName - Name of the event to check validity for

Returns true if the event exists and is valid, otherwise false.

### getEventNote(eventName)

Gets the note associated with a scheduled event.

```
local note = getEventNote("EventName")
```

- eventName - Name of the event to get the note for

Returns the note associated with the event, or null if not found.