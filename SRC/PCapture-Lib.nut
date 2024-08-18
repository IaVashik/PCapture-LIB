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

local version = "PCapture-Lib 3.0 Debug"

// `Self` must be in any case, even if the script is run directly by the interpreter
if (!("self" in this)) {
    self <- Entities.FindByClassname(null, "worldspawn")
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

IncludeScript("SRC/Math/init.nut")
IncludeScript("SRC/IDT/init.nut")
IncludeScript("SRC/Utils/init.nut")

::LibLogger <- LoggerLevels.Info
const ALWAYS_PRECACHED_MODEL = "models/weapons/w_portalgun.mdl"

IncludeScript("SRC/TracePlus/init.nut")
IncludeScript("SRC/Animations/init.nut")
IncludeScript("SRC/ActionScheduler/init.nut")
IncludeScript("SRC/GameEvents/init.nut")
IncludeScript("SRC/HUD/init.nut")
// IncludeScript("SRC/_FEATURES/features")


/*
 * This code initializes "eyes" for all players to enable retrieving their coordinates and viewing directions,
 * serving as a workaround due to the lack of the EyeForward function in Portal 2.
 *
 * If the session is multiplayer, it reinitializes the eyes after 1 second to ensure players are properly set up,
 * as players initialize with a slight delay of 1-2 seconds in multiplayer mode.
 *
 * Additionally, if running in the Portal 2 Multiplayer Mod (P2MM), it sets up a repeated initialization every second,
 * to accommodate new players joining the session dynamically.
*/
AttachEyeControlToPlayers()
if(IsMultiplayer()) 
    ScheduleEvent.Add("global", AttachEyeControlToPlayers, 2)
if(IsMultiplayer() && "TEAM_SINGLEPLAYER" in getroottable()) 
    ScheduleEvent.AddInterval("global", AttachEyeControlToPlayers, 1, 2)


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
printl("Author: laVashik Production") // The Grand Archmage :P
printl("GitHub: https://github.com/IaVashik/PCapture-LIB")
printl("----------------------------------------\n")