/*
 * Executes scheduled events when their time is up. 
 * 
 * This function iterates over all scheduled events and checks if their scheduled execution time has arrived. 
 * If so, it executes the event's action and removes it from the list of scheduled events. 
 * The function then schedules itself to run again after a short delay to continue processing events.
*/
::ScheduledEventsLoop <- function() {
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
                local gtor = event.action
                if(typeof event.action == "generator" || typeof (gtor = event.run()) == "generator") {
                    event.processGenerator(gtor, eventName)
                }
            }
            catch(exception) {
                //* Stack unwinding
                macros.fprint("AN ERROR HAS OCCURED IN ScheduleEvent [{}]", exception)
                printl("\nCALLSTACK")
                local stack
                for(local i = 1; stack = getstackinfos(i); i++)
                    macros.fprint("*FUNCTION [{}()] {} line [{}]", stack.func, stack.src, stack.line)

                macros.fprint("\nSCHEDULED EVENT\n[Name] {}\n{}\n[Exception]{}", eventName, event.GetInfo(), exception)

                if(type(event.action) == "function" || type(event.action) == "native function") {
                    printl("\nFUNCTION INFO")
                    foreach(key, val in event.action.getinfos()) {
                        if(type(val) == "array") val = ArrayEx.FromArray(val)
                        macros.fprint("[{}] {}", key.toupper(), val)
                    }
                }

                SendToConsole("playvol resource/warning.wav 1")
            }
            eventInfo.remove(0)
        }
        if(eventName != "global" && eventInfo.len() == 0) {
            ScheduleEvent.eventsList.rawdelete(eventName)
            if(developer() > 0) dev.trace("Event {} closed.", eventName)
        }
    }
    EntFireByHandle(self, "RunScriptCode", "ScheduledEventsLoop()", FrameTime())
}