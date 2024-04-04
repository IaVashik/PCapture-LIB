/*+--------------------------------------------------------------------------------+
|                           PCapture Vscripts Library                               |
 +---------------------------------------------------------------------------------+
| Author:                                                                           |
|     One-of-a-Kind - laVashik :D                                                   |
 +---------------------------------------------------------------------------------+
| pcapture-lib.nut                                                                  |
|       The main file in the library. initializes required parts of the library     |
|    GitHud repo: https://github.com/IaVashik/PCapture-LIB                          |
+----------------------------------------------------------------------------------+ */

::VSEventLogs <- false
local version = "PCapture-Lib 2.0 experimental"

// `Self` must be in any case, even if the script is run directly by the interpreter
if (!("self" in this)) {
    self <- Entities.FindByClassname(null, "worldspawn")
} else {
    getroottable()["self"] <- self
}

if("_lib_version_" in getroottable()) {
    dev.warning("PCapture-Lib already initialized.")
    if(_lib_version_ != version) dev.error("Attempting to initialize different versions of the PCapture-Lib library!\nVersion " + _lib_version_ + " != " + version)
    return
}


IncludeScript("SRC/Utils/init.nut")
IncludeScript("SRC/Math/init.nut")
IncludeScript("SRC/IDT/init.nut")

// IncludeScript("SRC/TracePlus/init.nut")
IncludeScript("SRC/Animations/init.nut")
IncludeScript("SRC/Events/init.nut")
IncludeScript("SRC/GameEvents/init.nut")
IncludeScript("SRC/HUD/init.nut")



//* Default settings for bboxcast traces.
// ::defaultSettings <- TraceSettings.new()

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