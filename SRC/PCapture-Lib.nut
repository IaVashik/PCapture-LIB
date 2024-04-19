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

::LibDebugInfo <- false
::VSEventLogs <- false

local version = "PCapture-Lib 2.0 Stable"

// `Self` must be in any case, even if the script is run directly by the interpreter
if (!("self" in this)) {
    self <- Entities.FindByClassname(null, "worldspawn")
} else {
    getroottable()["self"] <- self
}

if("_lib_version_" in getroottable()) {
    printl("\n")
    dev.warning("PCapture-Lib already initialized.")
    if(_lib_version_ != version) {
        dev.error("Attempting to initialize different versions of the PCapture-Lib library!")
        dev.fprint("Version \"{}\" != \"{}\"", _lib_version_, version)
    }
    return
}


IncludeScript("SRC/Utils/init.nut")
IncludeScript("SRC/Math/init.nut")
IncludeScript("SRC/IDT/init.nut")

IncludeScript("SRC/TracePlus/init.nut")
IncludeScript("SRC/Animations/init.nut")
IncludeScript("SRC/ActionScheduler/init.nut")
IncludeScript("SRC/GameEvents/init.nut")
IncludeScript("SRC/HUD/init.nut")


::cwar <- List() // todo
::cerr <- List()

//* Default settings for bboxcast traces.

if(("dissolver" in getroottable()) == false) {
    ::dissolver <- entLib.CreateByClassname("env_entity_dissolver", {targetname = "@dissolver"})
} 

if(IsMultiplayer()) {
    RunScriptCode.setInterval(AttachEyeControlToPlayers, 5)
} else {
    AttachEyeControlToPlayers()
}

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