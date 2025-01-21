/*+--------------------------------------------------------------------------------+
|                           PCapture Vscripts Library                               |
 +---------------------------------------------------------------------------------+
| Author:                                                                           |
|     One-of-a-Kind - laVashik                                                      |
 +---------------------------------------------------------------------------------+
| pcapture-lib.nut                                                                  |
|       The main file in the library. initializes required parts of the library     |
|    GitHud repo: https://github.com/IaVashik/PCapture-LIB                          |
+----------------------------------------------------------------------------------+ */

local version = "PCapture-Lib 3.2 Stable"

// `Self` must be in any case, even if the script is run directly by the interpreter
if (!("self" in this)) {
    self <- Entities.First()
} else {
    getroottable()["self"] <- self
}

if("_lib_version_" in getroottable() && version.find("Debug") == null) {
    printl("\n")
    dev.warning("PCapture-Lib already initialized.")
    if(_lib_version_ != version) {
        dev.error("Attempting to initialize different versions of the PCapture-Lib library!")
        dev.fprint("Version \"{}\" != \"{}\"", _lib_version_, version)
    }
    return
}

IncludeScript("PCapture-LIB/SRC/Math/init.nut")
IncludeScript("PCapture-LIB/SRC/IDT/init.nut")
IncludeScript("PCapture-LIB/SRC/Utils/init.nut")

::LibLogger <- LoggerLevels.Info
const ALWAYS_PRECACHED_MODEL = "models/weapons/w_portalgun.mdl" // needed for pcapEntity::EmitSoundEx

IncludeScript("PCapture-LIB/SRC/TracePlus/init.nut")
IncludeScript("PCapture-LIB/SRC/ActionScheduler/init.nut")
IncludeScript("PCapture-LIB/SRC/Animations/init.nut")
IncludeScript("PCapture-LIB/SRC/ScriptEvents/init.nut")
IncludeScript("PCapture-LIB/SRC/HUD/init.nut")


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

TrackPlayerJoins()
if(IsMultiplayer()) {
    ScheduleEvent.Add("global", TrackPlayerJoins, 2) // Thanks Volve for making it take so long for players to initialize
    ScheduleEvent.AddInterval("global", HandlePlayerEventsMP, 0.3)
    
    if("TEAM_SINGLEPLAYER" in getroottable()) 
        // This session is running in P2MM, actively monitoring players.
        ScheduleEvent.AddInterval("global", TrackPlayerJoins, 1, 2)
} 
else {
    ScheduleEvent.AddInterval("global", HandlePlayerEventsSP, 0.5)
} 


// Global settings for the portals correct working
SetupLinkedPortals()
local globalDetector = _CreatePortalDetector("CheckAllIDs", true)
globalDetector.ConnectOutputEx("OnStartTouchPortal", function() {entLib.FromEntity(activator).SetTraceIgnore(false)})
globalDetector.ConnectOutputEx("OnEndTouchPortal", function() {entLib.FromEntity(activator).SetTraceIgnore(true)})


::_lib_version_ <- version

/*
 * Prints information about the PCapture library upon initialization.
 *
 * This includes the library name, version, author, and a link to the GitHub repository.
*/
printl("\n----------------------------------------")
printl("Welcome to " + _lib_version_)
printl("Author: laVashik Production") // The God of VScripts :P
printl("GitHub: https://github.com/IaVashik/PCapture-LIB")
printl("----------------------------------------\n")