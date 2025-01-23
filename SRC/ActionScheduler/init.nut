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
    
    Add = null,
    AddActions = null,
    AddInterval = null,

    Cancel = null,
    CancelByAction = null,
    CancelAll = null,
    
    GetEvent = null,
    
    IsValid = null,
}

IncludeScript("PCapture-LIB/SRC/ActionScheduler/action")
IncludeScript("PCapture-LIB/SRC/ActionScheduler/action_scheduler")
IncludeScript("PCapture-LIB/SRC/ActionScheduler/event_handler")

// Create a logic_timer to process the event loop.
local timer = entLib.CreateByClassname("logic_timer", {RefireTime=0.001})
timer.ConnectOutput("OnTimer", "ScheduledEventsLoop")
EntFireByHandle(timer, "Enable");