/*
 * Executes scheduled events when their time is up. 
 * 
 * This function iterates over all scheduled events and checks if their scheduled execution time has arrived. 
 * If so, it executes the event's action and removes it from the list of scheduled events. 
 * The function then schedules itself to run again after a short delay to continue processing events.
*/
 ::ExecuteScheduledEvents <- function() {
    // If there are no events scheduled, stop the event loop. 
    if(ScheduleEvent.eventsList.len() == 1 && ScheduleEvent.eventsList.global.len() == 0) {
        return ScheduleEvent.executorRunning = false
    }

    // Iterate over each event name and its corresponding event list. 
    foreach(eventName, eventInfo in ScheduleEvent.eventsList) {
        local event 
        // Process events until the list is empty or the next event's time hasn't arrived yet.  
        while(eventInfo.len() > 0 && Time() >= (event = eventInfo.first()).executionTime) {
            try {
                event.run() 
            }
            catch(exception) { // todo??
                SendToConsole("playvol resource/warning.wav 1")
                printl("\nSCHEDULED EVENT\n[Name] " + eventName + "\n" + event.GetInfo())

                if(type(event.action) == "function") {
                    local info = ""
                    foreach(key, val in event.action.getinfos()) {
                        if(type(val) == "array") val = arrayLib(val)
                        info += "[" + key.toupper() + "] " + val + "\n"
                    }
                    printl("\nFUNCTION INFO\n" + info)
                }
            }
            eventInfo.remove(0) 
        }
        if(eventName != "global" && eventInfo.len() == 0) {
            ScheduleEvent.eventsList.rawdelete(eventName)
            dev.debug("I delete " + eventName) // todo dev code
        }
    }
    EntFireByHandle(self, "runscriptcode", "ExecuteScheduledEvents()", FrameTime(), null, null)
}