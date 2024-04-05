/*
 * Executes scheduled events when their time is up
*/
::ExecuteScheduledEvents <- function() {
    if(scheduledEventsList.len() == 1 && scheduledEventsList.global.len() == 0) {
        return isEventLoopRunning = false
    }

    foreach(eventName, eventInfo in scheduledEventsList) {
        local event
        while(eventInfo.len() > 0 && Time() >= (event = eventInfo.GetMin()).timeDelay) {
            try {
                event.run() 
            }
            catch(exception) { // todo??
                SendToConsole("playvol resource/warning.wav 1")
                printl("\nSCHEDULED EVENT\n[Name] " + eventName + "\n" + event)

                if(type(event.action) == "function") {
                    local info = ""
                    foreach(key, val in event.action.getinfos()) {
                        if(type(val) == "array") val = arrayLib(val)
                        info += "[" + key.toupper() + "] " + val + "\n"
                    }
                    printl("\nFUNCTION INFO\n" + info)
                }
            }
            eventInfo.remove(event) 
        }
    }
    RunScriptCode.delay("ExecuteScheduledEvents()", FrameTime())
}