// Object to store scheduled events 
::scheduledEventsList <- {global = AVLTree()}
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
::CreateScheduleEvent <- function(eventName, action, timeDelay, note = null, args = null) {
    if ( !(eventName in scheduledEventsList) ) {
        scheduledEventsList[eventName] <- AVLTree()
        dev.debug("Created new Event - " + eventName)
    }

    local newScheduledEvent = ScheduleEvent(this, action, timeDelay + Time(), note, args)
    local currentEventList = scheduledEventsList[eventName]
    // dev.debug("eventName: "+eventName+",  - "+eventList.len()+", currentEventList: "+currentEventList.len())

    currentEventList.insert(newScheduledEvent)

    if(!isEventLoopRunning) {
        isEventLoopRunning = true
        ExecuteScheduledEvents()
    }
}


/*
* Cancels a scheduled event with the given name.
* 
* @param {string} eventName - Name of event to cancel.
* @param {int|float} delay - Delay in seconds before event cancelation
*/
::cancelScheduledEvent <- function(eventName, delay = 0) {
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
    if(LibDebugInfo) {
        local test = ""
        foreach(k, i in scheduledEventsList)
            test += k + ", "

        test = test.slice(0, -2)
        dev.debug(format("Event \"%s\" closed. Actial events: [%s]", eventName, test))
    }
}


/*
 * Gets info about a scheduled event.
 * 
 * @param {string} eventName - Name of event to get info for.
 * @returns {table|null} - The event info object or null if not found.
*/
::getEventInfo <- function(eventName) {
    return eventName in scheduledEventsList ? scheduledEventsList[eventName] : null
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