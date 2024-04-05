::GameEvent <- class {
    eventName = null; // Name of the event
    triggerCount = null; // Number of triggers remaining (-1 for unlimited)
    action = null; // Action to be performed when the event is triggered
    filterFunction = null; // Filter function to check the trigger conditions

    // Constructor for initializing the GameEvent
    constructor(eventName, triggerCount = -1, action = null) {
        this.eventName = eventName
        this.triggerCount = triggerCount
        this.action = action
        
        AllGameEvents[eventName] <- this
    }

    // Method to change a action function to the event
    function SetAction(filterFunc) return null

    // Method to add a filter function to the event
    function SetFilter(filterFunc) return null
    
    // Method to trigger the event if conditions are met
    function Trigger(args = null) return null
    
    // Method to forcibly trigger the event regardless of the filter function and remaining triggers
    function ForceTrigger(args = null) return null
}



function GameEvent::SetAction(filterFunc) {
    this.action = filterFunc
}


function GameEvent::SetFilter(filterFunc) {
    this.filterFunction = filterFunc
}


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


function GameEvent::ForceTrigger(args = null) {
    this.action(args)
}