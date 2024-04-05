::EventListener <- {
    function Notify(eventName, args = null) {
        if(eventName in AllGameEvents)
            return AllGameEvents[eventName].Trigger(args)
        return dev.warning("Unknown GameEvent {" + eventName + "}")
    }
    
    function GetEvent(EventName) {
        return eventName in AllGameEvents ? AllGameEvents[eventName] : null
    }
}