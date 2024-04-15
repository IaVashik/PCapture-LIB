/* 
 * Listens for and handles custom game events.
*/
 ::EventListener <- {
    /*
     * Notifies the listener of a triggered event.
     *
     * @param {string} eventName - The name of the triggered event.
     * @param {any} args - Optional arguments associated with the event. 
     * @returns {any|null} - The result of the event's action, or null if the event is not found or the filter fails. 
    */
    function Notify(eventName, args = null) {
        if(eventName in AllGameEvents)
            return AllGameEvents[eventName].Trigger(args)
        return dev.warning("Unknown GameEvent {" + eventName + "}")
    }
    
    /* 
     * Gets a GameEvent object by name. 
     * 
     * @param {string} EventName - The name of the event to retrieve. 
     * @returns {GameEvent|null} - The GameEvent object, or null if the event is not found. 
    */
    function GetEvent(EventName) {
        return eventName in AllGameEvents ? AllGameEvents[eventName] : null
    }
}