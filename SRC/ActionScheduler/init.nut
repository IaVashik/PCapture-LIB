/*+--------------------------------------------------------------------------------+
|                           PCapture Vscripts Library                              |
+----------------------------------------------------------------------------------+
| Author:                                                                          |
|     Event Orchestrator - laVashik ・人・                                          |
+----------------------------------------------------------------------------------+
|   The Events module, offering an advanced event scheduling and management system | 
|   for creating complex, timed events with precision and control.                 |
+----------------------------------------------------------------------------------+ */ 


::ScheduleEvent <- {
    // Object to store scheduled events 
    eventsList = {global = List()},
    // Var to track if event loop is running
    executorRunning = false,
    
    Add = null,
    AddActions = null,
    AddInterval = null,

    Cancel = null,
    CancelByAction = null,
    CancelAll = null,
    
    GetEvent = null,
    
    IsValid = null,
}

ScheduleEvent["_startThink"] <- function() {
    if(!ScheduleEvent.executorRunning) {
        ScheduleEvent.executorRunning = true
        ScheduledEventsLoop()
    }
}

IncludeScript("PCapture-LIB/SRC/ActionScheduler/action")
IncludeScript("PCapture-LIB/SRC/ActionScheduler/action_scheduler")
IncludeScript("PCapture-LIB/SRC/ActionScheduler/event_handler")