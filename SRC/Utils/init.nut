/*+--------------------------------------------------------------------------------+
|                           PCapture Vscripts Library                              |
+----------------------------------------------------------------------------------+
| Author:                                                                          |
|     Squirrel Whisperer - laVashik :>                                             |
+----------------------------------------------------------------------------------+
|       A toolbox of versatile utilities for script execution, debugging, file     |
|       operations, and entity manipulation, empowering VScripts developers.       | 
+----------------------------------------------------------------------------------+ */ 

IncludeScript("PCapture-LIB/SRC/Utils/debug")
IncludeScript("PCapture-LIB/SRC/Utils/improvements")
IncludeScript("PCapture-LIB/SRC/Utils/portals")
IncludeScript("PCapture-LIB/SRC/Utils/player_hooks")
IncludeScript("PCapture-LIB/SRC/Utils/macros")

::LibLogger <- LoggerLevels.Info

/*
 * Initializes eye tracking for all players, allowing retrieval of their coordinates and viewing directions.
 * This serves as a workaround for the absence of the EyeForward function in Portal 2.
 *
 * In multiplayer sessions, it reinitializes eye tracking after 1 second to ensure that players are set up 
 * correctly, as there is typically a slight delay (1-2 seconds) in player initialization.
 *
 * When running in the Portal 2 Multiplayer Mod (P2MM), it schedules repeated initialization every second 
 * to dynamically accommodate new players joining the session.
*/

ScheduleEvent.Add("global", TrackPlayerJoins, 0.4)
if(IsMultiplayer()) {
    ScheduleEvent.Add("global", TrackPlayerJoins, 2) // Thanks Volve for making it take so long for players to initialize
    ScheduleEvent.AddInterval("global", HandlePlayerEventsMP, 0.3)
    
    if("TEAM_SINGLEPLAYER" in getroottable()) 
        // This session is running in P2MM, actively monitoring players.
        ScheduleEvent.AddInterval("global", TrackPlayerJoins, 1, 2)
} 
else {
    ScheduleEvent.AddInterval("global", HandlePlayerEventsSP, 0.5, 0.5)
} 


// Global settings for the portals correct working
SetupLinkedPortals()
local globalDetector = _CreatePortalDetector("CheckAllIDs", true)
globalDetector.ConnectOutputEx("OnStartTouchPortal", function() {entLib.FromEntity(activator).SetTraceIgnore(false)})
globalDetector.ConnectOutputEx("OnEndTouchPortal", function() {entLib.FromEntity(activator).SetTraceIgnore(true)})
