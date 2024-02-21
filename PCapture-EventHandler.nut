/*+--------------------------------------------------------------------------------+
|                           PCapture Vscripts Library                               |
 +---------------------------------------------------------------------------------+
| Author:                                                                           |
|     One-of-a-Kind - laVashik :D                                                   |
 +---------------------------------------------------------------------------------+
| PCapture-EventHandler.nut                                                             |
|       Improved EntFire/logic_relay/loop module. Allows you to create whole events     |
|       from many different events and cancel them at any time, unlike EntFireByHandler.|
|       Able to take not only string, but also full-fledged functions                   |
+----------------------------------------------------------------------------------+ */

if("CreateScheduleEvent" in getroottable()) {
    dev.warning("EventHandler module initialization skipped. Module already initialized.")
    return
}

// Object to store scheduled events 
::scheduledEventsList <- {global = []}
// Var to track if event loop is running
::isEventLoopRunning <- false


/*
 * Creates a new scheduled event.
 * 
 * @param {string} eventName - Name of the event. 
 * @param {string|function} action - Action to execute for event.
 * @param {int|float} timeDelay - Delay in seconds before executing event.
 * @param {string} note - Optional note about the event, if needed.
*/
::CreateScheduleEvent <- function(eventName, action, timeDelay, note = null)
{
    if ( !(eventName in scheduledEventsList) ) {
        scheduledEventsList[eventName] <- [[]]
        // dev.log("Created new Event - " + eventName)
    }

    local eventList = scheduledEventsList[eventName]
    if(eventList.len() == 0 || eventList.top().len() > 300) {
        eventList.append([])
    }

    timeDelay += Time()
    local newScheduledEvent = {action = action, timeDelay = timeDelay, note = note}
    local currentEventList = eventList.top()

    if(currentEventList.len() == 0 || timeDelay > currentEventList.top().timeDelay) {
        return currentEventList.append(newScheduledEvent)
    }

    //! --- A binary tree. This is an experimental code!!
    local low = 0
    local high = currentEventList.len() - 1
    local mid

    while (low <= high) {
        mid = (low + high) / 2
        if (currentEventList[mid].timeDelay < newScheduledEvent.timeDelay) {
            low = mid + 1
        }
        else if (currentEventList[mid].timeDelay > newScheduledEvent.timeDelay) {
            high = mid - 1
        }
        else {
            low = mid
            break
        }
    }
    
    currentEventList.insert(low, newScheduledEvent)
    //! ---

    if(!isEventLoopRunning) {
        isEventLoopRunning = true
        ExecuteScheduledEvents()
    }
}


/*
 * Executes scheduled events when their time is up
*/
::ExecuteScheduledEvents <- function() {
    if(scheduledEventsList.len() == 1 && scheduledEventsList.global.len() == 0)
        return isEventLoopRunning = false

    foreach(eventName, eventArray in scheduledEventsList) {
        foreach(idx, eventInfo in eventArray) {
            while (eventInfo.len() > 0 && Time() >= eventInfo[0].timeDelay) {
                local event = eventInfo[0]
                // printl(("eventName : "+eventName+", event: "+event.action+", timeDelay: "+event.timeDelay+", Time(): "+Time())) //DEV CODE
                if(typeof event.action == "string") {
                    // try {
                        compilestring( event.action )()
                    // }
                    // catch(exception) {
                        // dev.error(exception + "! Event action: " + event.action)
                    // }
                }
                else if(typeof event.action == "function" || typeof event.action == "native function"){
                    event.action() 
                }
                else {
                    dev.warning("Unable to process event " + event.action + " in event " + eventName)
                }
                eventInfo.remove(0) 
                if(eventInfo.len() == 0) 
                    eventArray.remove(idx)
            }
        }
        if(eventArray.len() == 0 && eventName != "global" && eventName in scheduledEventsList) 
            cancelScheduledEvent(eventName)
    }

    RunScriptCode.delay("ExecuteScheduledEvents()", FrameTime())
}

/*
* Cancels a scheduled event with the given name.
* 
* @param {string} eventName - Name of event to cancel.
* @param {int|float} delay - Delay in seconds before event cancelation
*/
::cancelScheduledEvent <- function(eventName, delay = 0) 
{
    if(eventName == "global")
        return dev.warning("The global event cannot be closed!")
    if(!(eventName in scheduledEventsList))
        return dev.error("There is no event named " + eventName)

    if(delay == 0)
        scheduledEventsList.rawdelete(eventName)
    else {
        return CreateScheduleEvent("global", format("cancelScheduledEvent(\"%s\")", eventName), delay)
    }
        
    // Debug info
    // if(GetDeveloperLevel() > 0) {
    //     local test = ""
    //     foreach(k, i in scheduledEventsList)
    //         test += k + ", "

    //     test = test.slice(0, -2)
    //     dev.log(format("Event \"%s\" closed. Actial events: %s", eventName, test))
    // }
}

/*
 * Gets info about a scheduled event.
 * 
 * @param {string} eventName - Name of event to get info for.
 * @returns {table|null} - The event info object or null if not found.
*/
::getEventInfo <- function(eventName)
{
    local event = null
    if(eventName in scheduledEventsList)
        event = scheduledEventsList[eventName]
    return event
}

/*
 * Checks if event is valid
 * 
 * @param {string} eventName - Name of event to get info for.
 * @returns {bool} - Object exists or not.
*/
::eventIsValid <- function(eventName) {
    return eventName in scheduledEventsList && scheduledEventsList[eventName].len() != 0
}


::getEventNote <- function(eventName) {
    local info = getEventInfo(eventName)
    if(!info || info.len() == 0) 
        return null
    
    foreach(event in info) {
        if(event.note)
            return event.note
    }
    
    return null
}