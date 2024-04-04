/*
 * Executes scheduled events when their time is up
*/
::ExecuteScheduledEvents <- function() {
    if(scheduledEventsList.len() == 1 && scheduledEventsList.global.len() == 0) {
        return isEventLoopRunning = false
    }

    foreach(eventName, eventArray in scheduledEventsList) {
        foreach(idx, eventInfo in eventArray) {
            while (eventInfo.len() > 0 && Time() >= eventInfo[0].timeDelay) {
                local event = eventInfo[0]
                // printl(("eventName : "+eventName+", enclosure: "+idx+", event: "+event.action+", timeDelay: "+event.timeDelay+", Time(): "+Time())) //DEV CODE
                try {
                    event.run() 
                }

                catch(exception) {
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

                eventInfo.remove(0) 
                if(eventInfo.len() == 0) 
                    eventArray.remove(idx)
            }
        }
        if(eventArray.len() == 0 && eventName != "global" && eventName in scheduledEventsList) 
            cancelScheduledEvent(eventName)
    }

    RunScriptCode.delay("ExecuteScheduledEvents()", FrameTime())
}