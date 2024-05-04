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


IncludeScript("SRC/ActionScheduler/action")
IncludeScript("SRC/ActionScheduler/action_scheduler")
IncludeScript("SRC/ActionScheduler/event_handler")