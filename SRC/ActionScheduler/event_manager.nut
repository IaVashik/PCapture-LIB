/*
 * Creates a new scheduled event.
 * 
 * @param {string} eventName - Name of the event. 
 * @param {string|function} action - Action to execute for event.
 * @param {number} timeDelay - Delay in seconds before executing event.
 * @param {string|null} note - Optional note about the event, if needed.
 * @param {array|null} args - Optional arguments to pass to the action function. 
*/
ScheduleEvent["Add"] <- function(eventName, action, timeDelay, args = null, note = null) {
    if ( !(eventName in ScheduleEvent.eventsList) ) {
        ScheduleEvent.eventsList[eventName] <- AVLTree() // todo, mb use list?
        dev.debug("Created new Event - " + eventName)
    }

    local newScheduledEvent = ScheduleAction(this, action, timeDelay, args, note)
    local currentEventList = ScheduleEvent.eventsList[eventName]

    currentEventList.insert(newScheduledEvent)

    if(!ScheduleEvent.executorRunning) {
        ScheduleEvent.executorRunning = true
        ExecuteScheduledEvents()
    }
}


ScheduleEvent["AddActions"] <- function(eventName, actions) {
    actions.sort()
    ScheduleEvent.eventsList[eventName] <- AVLTree.fromArray(actions) // todo а если уже есть события?
    dev.debug("Created new Event - " + eventName)

    if(!ScheduleEvent.executorRunning) {
        ScheduleEvent.executorRunning = true
        ExecuteScheduledEvents()
    }
}


// ScheduleEvent["AddInterval"] <- function(eventName, action, interval, initialDelay = 0 , args = null, note = null) {
//     local actions = [ // TODO
//         ScheduleAction(this, action, initialDelay, args, note),
//         ScheduleAction(this, this.AddInterval, initialDelay + interval, [eventName, action, interval, 0, args, note])
//     ]

//     ScheduleEvent.AddActions(eventName, actions)
// }


/*
* Cancels a scheduled event with the given name.
* 
* @param {string} eventName - Name of event to cancel.
* @param {number} delay - Delay in seconds before event cancelation
*/
ScheduleEvent["Cancel"] <- function(eventName, delay = 0) {
    if(eventName == "global")
        return dev.warning("The global event cannot be closed!")
    if(!(eventName in ScheduleEvent.eventsList))
        return dev.error("There is no event named " + eventName)
    if(delay > 0)
        return ScheduleEvent.Add("global", format("ScheduleEvent.Cancel(\"%s\")", eventName), delay)
    
        ScheduleEvent.eventsList.rawdelete(eventName)
        
    // Debug info
    if(LibDebugInfo) {
        local test = ""
        foreach(k, i in ScheduleEvent.eventsList)
            test += k + ", "

        test = test.slice(0, -2)
        dev.debug(format("Event \"%s\" closed. Actial events: [%s]", eventName, test))
    }
}

ScheduleEvent["CancelByAction"] <- function(action, delay = 0) {
    if(delay > 0)
        return ScheduleEvent.Add("global", format("ScheduleEvent.Cancel(\"%s\")", eventName), delay)
    
    foreach(name, events in ScheduleEvent.eventsList) {
        foreach(eventAction in events) {
            if(eventAction.action == action) {
                events.remove(eventAction)
                dev.debug(eventAction + " was deleted from " + name)
                return true
            }
        }
    }
    return false
}

ScheduleEvent["CancelAll"] <- function() {
    ScheduleEvent.eventsList = {global = AVLTree()}
    dev.debug("All scheduled events have been canceled!")
}


/*
 * Gets info about a scheduled event.
 * 
 * @param {string} eventName - Name of event to get info for.
 * @returns {AVLTree|null} - The event info object or null if not found.
*/
ScheduleEvent["GetEvent"] <- function(eventName) {
    return eventName in ScheduleEvent.eventsList ? ScheduleEvent.eventsList[eventName] : null
}


/*
 * Checks if event is valid
 * 
 * @param {string} eventName - Name of event to get info for.
 * @returns {bool} - Object exists or not.
*/
ScheduleEvent["IsValid"] <- function(eventName) {
    return eventName in ScheduleEvent.eventsList && ScheduleEvent.eventsList[eventName].len() != 0
}


/* 
 * Gets the note associated with the first scheduled event with the given name.
 *
 * @param {string} eventName - The name of the event. 
 * @returns {string|null} - The note of the first event, or null if no note is found or the event doesn't exist. 
*/
ScheduleEvent["GetNote"] <- function(eventName) {
    local info = ScheduleEvent.GetEvent(eventName)
    if(!info || info.len() == 0) 
        return null
    
    foreach(event in info) {
        if(event.note)
            return event.note
    }
    
    return null
}