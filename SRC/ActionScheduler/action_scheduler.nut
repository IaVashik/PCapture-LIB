/*
 * Adds a single action to a scheduled event with the specified name.
 *
 * @param {string} eventName - The name of the event to add the action to. If the event does not exist, it is created.
 * @param {string|function} action - The action to execute when the scheduled time arrives. This can be a string containing VScripts code or a function object.
 * @param {number} timeDelay - The delay in seconds before executing the action.
 * @param {array|null} args - An optional array of arguments to pass to the action function.
 * @param {object} scope - The scope in which to execute the action (default is `this`). 
*/
ScheduleEvent["Add"] <- function(eventName, action, timeDelay, args = null, scope = this) {
    if ( !(eventName in ScheduleEvent.eventsList) ) {
        ScheduleEvent.eventsList[eventName] <- List()
        dev.debug("Created new Event - " + eventName)
    }

    local newScheduledEvent = ScheduleAction(scope, action, timeDelay, args)
    local currentActionList = ScheduleEvent.eventsList[eventName]


    if(currentActionList.len() == 0 || currentActionList.top() <= newScheduledEvent) {
        currentActionList.append(newScheduledEvent)
        return ScheduleEvent._startThink()
    } 
    
    //* --- A binary tree.
    local low = 0
    local high = currentActionList.len() - 1
    local mid

    while (low <= high) {
        mid = (low + high) / 2
        if (currentActionList[mid] < newScheduledEvent) {
            low = mid + 1
        }
        else if (currentActionList[mid] > newScheduledEvent) {
            high = mid - 1
        }
        else {
            low = mid
            break
        }
    }
    
    currentActionList.insert(low, newScheduledEvent)
    ScheduleEvent._startThink()
}

/*
 * Adds an action to a scheduled event that will be executed repeatedly at a fixed interval. 
 *
 * @param {string} eventName - The name of the event to add the interval to. If the event does not exist, it is created.
 * @param {string|function} action - The action to execute at each interval.
 * @param {number} interval - The time interval in seconds between executions of the action.
 * @param {number} initialDelay - The initial delay in seconds before the first execution of the action (default is 0). 
 * @param {array|null} args - An optional array of arguments to pass to the action function. 
 * @param {object} scope - The scope in which to execute the action (default is `this`). 
*/ 
ScheduleEvent["AddInterval"] <- function(eventName, action, interval, initialDelay = 0, args = null, scope = this) {
    local actions = [ // TODO
        ScheduleAction(scope, action, initialDelay, args),
        ScheduleAction(scope, ScheduleEvent.AddInterval, initialDelay + interval, [eventName, action, interval, 0, args, scope])
    ]   

    ScheduleEvent.AddActions(eventName, actions, true)
    // ScheduleEvent.eventsList[eventName] <- actions // tood :d
}

/*
 * Adds multiple actions to a scheduled event, ensuring they are sorted by execution time.
 *
 * @param {string} eventName - The name of the event to add the actions to. If the event does not exist, it is created.
 * @param {array|List} actions - An array or List of `ScheduleAction` objects to add to the event.
 * @param {boolean} noSort - If true, the actions will not be sorted by execution time (default is false).
 * 
 * **Caution:** Use the `noSort` parameter with care. Incorrect usage may lead to unexpected behavior or break the event scheduling logic. 
*/ 
ScheduleEvent["AddActions"] <- function(eventName, actions, noSort = false) { 
    if (eventName in ScheduleEvent.eventsList ) {
        ScheduleEvent.eventsList[eventName].extend(actions)
        ScheduleEvent.eventsList[eventName].sort()
        // dev.debug("Added " + actions.len() + " actions to Event " + eventName)
        return ScheduleEvent._startThink()
    } 

    if(!noSort) actions.sort()

    if(typeof actions == "List") {
        ScheduleEvent.eventsList[eventName] <- actions
    } else {
        ScheduleEvent.eventsList[eventName] <- List.fromArray(actions)
    }

    dev.debug("Created new Event - " + eventName)
    ScheduleEvent._startThink()
}


/*
 * Cancels a scheduled event with the given name, optionally after a delay.
 *
 * @param {string} eventName - The name of the event to cancel.
 * @param {number} delay - An optional delay in seconds before canceling the event.
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
    if(LibDebugInfo || 1) {
        local test = ""
        foreach(k, i in ScheduleEvent.eventsList)
            test += k + ", "

        test = test.slice(0, -2)
        dev.debug(format("Event \"%s\" closed. Actial events: [%s]", eventName.tostring(), test))
    }
}

ScheduleEvent["TryCancel"] <- function(eventName, delay = 0) {
    if(delay > 0) 
        return ScheduleEvent.Add("global", format("ScheduleEvent.TryCancel(\"%s\")", eventName), delay)
    if(ScheduleEvent.IsValid(eventName)) ScheduleEvent.Cancel(eventName)
}


/*
 * Cancels all scheduled actions that match the given action, optionally after a delay.
 *
 * @param {string|function} action - The action to cancel.
 * @param {number} delay - An optional delay in seconds before canceling the actions. 
*/
ScheduleEvent["CancelByAction"] <- function(action, delay = 0) {
    if(delay > 0)
        return ScheduleEvent.Add("global", format("ScheduleEvent.Cancel(\"%s\")", eventName), delay)
    
    foreach(name, events in ScheduleEvent.eventsList) {
        foreach(eventAction in events) {
            if(eventAction.action == action) {
                events.remove(eventAction)
                dev.debug(eventAction + " was deleted from " + name)
            }
        }
    }
}

/*
 * Cancels all scheduled events and actions, effectively clearing the event scheduler.
*/
ScheduleEvent["CancelAll"] <- function() {
    ScheduleEvent.eventsList = {global = List()}
    dev.debug("All scheduled events have been canceled!")
}


/*
 * Gets info about a scheduled event.
 * 
 * @param {string} eventName - Name of event to get info for.
 * @returns {List|null} - The event info object or null if not found.
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