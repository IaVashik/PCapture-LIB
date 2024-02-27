/*+--------------------------------------------------------------------------------+
|                           PCapture Vscripts Library                               |
 +---------------------------------------------------------------------------------+
| Author:                                                                           |
|     One-of-a-Kind - laVashik :D                                                   |
 +---------------------------------------------------------------------------------+
| pcapture-lib.nut                                                                  |
|       The main file in the library. Initializes required parts of the library     |
|    GitHud repo: https://github.com/IaVashik/PCapture-LIB                          |
+----------------------------------------------------------------------------------+ */

if (!("self" in this)) {
    self <- Entities.FindByClassname(null, "worldspawn")
} else {
    getroottable()["self"] <- self
}

// Library files
IncludeScript("pcapture-lib/PCapture-Math")
IncludeScript("pcapture-lib/PCapture-Arrays")
IncludeScript("pcapture-lib/PCapture-Utils")
IncludeScript("pcapture-lib/PCapture-Entities")
IncludeScript("pcapture-lib/PCapture-EventHandler")
IncludeScript("pcapture-lib/PCapture-Anims")
IncludeScript("pcapture-lib/PCapture-Improvements")

// TODO delete?
IncludeScript("pcapture-lib/TraceLineEx/main")

if(("dissolver" in getroottable()) == false) {
    ::dissolver <- entLib.CreateByClassname("env_entity_dissolver", {targetname = "@dissolver"})
} 