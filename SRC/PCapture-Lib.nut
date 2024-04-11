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

local version = "PCapture-Lib 2.0 alpha"

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
IncludeScript("SRC/Events/init.nut")
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

printl("-----------------")
printl(_lib_version_)
printl("-----------------")