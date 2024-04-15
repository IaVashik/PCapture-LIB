/*
 * Represents a custom game event. 
 * 
 * This class allows you to create and manage custom game events with triggers, filters, and actions. 
*/
 ::GameEvent <- class {
    // The name of the event.  
    eventName = null; 
    // The number of times the event can be triggered before it becomes inactive (-1 for unlimited triggers). 
    triggerCount = null; 
    // The action to be performed when the event is triggered. 
    action = null; 
    // A filter function to check conditions before triggering the event.  
    filterFunction = null; 

    // Constructor for initializing the GameEvent
    /*
     * Constructor for a GameEvent object.
     *
     * @param {string} eventName - The name of the event.
     * @param {number} triggerCount - The number of times the event can be triggered (-1 for unlimited). (optional, default=-1) 
     * @param {function} action - The action to be performed when the event is triggered. (optional) 
    */
    constructor(eventName, triggerCount = -1, action = null) {
        this.eventName = eventName
        this.triggerCount = triggerCount
        this.action = action
        
        AllGameEvents[eventName] <- this
    }

    // Method to change a action function to the event
    /* 
     * Sets the action function for the event. 
     *
     * @param {function} actionFunction - The function to execute when the event is triggered. 
    */
    function SetAction(filterFunc) return null

    // Method to add a filter function to the event
    /* 
     * Sets the filter function for the event. 
     *
     * The filter function should return true if the event should be triggered, false otherwise. 
     *
     * @param {function} filterFunction - The function to use for filtering trigger conditions. 
    */
    function SetFilter(filterFunc) return null
    
    // Method to trigger the event if conditions are met
    /* 
     * Triggers the event if the trigger count allows and the filter function (if set) returns true. 
     *
     * @param {any} args - Optional arguments to pass to the action function. 
    */
    function Trigger(args = null) return null
    
    // Method to forcibly trigger the event regardless of the filter function and remaining triggers
    /*
     * Forces the event to trigger, ignoring the filter function and trigger count. 
     * 
     * @param {any} args - Optional arguments to pass to the action function. 
    */
    function ForceTrigger(args = null) return null
}



/*
 * Sets the action function for the event. 
 *
 * @param {function} actionFunction - The function to execute when the event is triggered. 
*/
function GameEvent::SetAction(filterFunc) {
    this.action = filterFunc
}


/* 
 * Sets the filter function for the event. 
 *
 * The filter function should return true if the event should be triggered, false otherwise. 
 *
 * @param {function} filterFunction - The function to use for filtering trigger conditions. 
*/
function GameEvent::SetFilter(filterFunc) {
    this.filterFunction = filterFunc
}


/* 
 * Triggers the event if the trigger count allows and the filter function (if set) returns true. 
 *
 * @param {any} args - Optional arguments to pass to the action function. 
*/
function GameEvent::Trigger(args = null) {
    if (this.triggerCount != 0 && (this.filterFunction == null || this.filterFunction(args))) {
        this.action(args)
        if (this.triggerCount > 0) {
            // Decrement the trigger count if it is not unlimited
            this.triggerCount-- 
        }
        return dev.VSEvent(this.eventName)
    }
}


/*
 * Forces the event to trigger, ignoring the filter function and trigger count. 
 * 
 * @param {any} args - Optional arguments to pass to the action function. 
*/
function GameEvent::ForceTrigger(args = null) {
    this.action(args)
}