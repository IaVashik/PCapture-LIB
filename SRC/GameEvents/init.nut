/*+--------------------------------------------------------------------------------+
|                           PCapture Vscripts Library                              |
+----------------------------------------------------------------------------------+
| Author:                                                                          |
|     Game Event Guru - laVashik >_<                                               |
+----------------------------------------------------------------------------------+
|   The Game Events module, empowering you to create and handle custom game events |
|   with triggers, filters, and actions, surpassing the limitations of standard    |
|   VScripts game events.                                                          |
+----------------------------------------------------------------------------------+ */

::AllGameEvents <- {}

/*
 * Logs a VScript event message to the console if event logging is enabled. 
 *
 * @param {string} msg - The event message to log. 
*/
dev["VSEvent"] <- function(msg) if(VSEventLogs) printl("VScript Event Fired: " + msg)

// TODO add support real game event

IncludeScript("SRC/GameEvents/event_listener")
IncludeScript("SRC/GameEvents/game_event")