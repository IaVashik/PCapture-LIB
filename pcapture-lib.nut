/*+--------------------------------------------------------------------------------+
|                           PCapture Vscripts Library                               |
 +---------------------------------------------------------------------------------+
| Author:                                                                           |
|     One-of-a-Kind - laVashik :D                                                   |
 +---------------------------------------------------------------------------------+
| pcapture-lib.nut                                                                  |
|       The main file in the library. Initializes required parts of the library     |
|                                                                                   |
+----------------------------------------------------------------------------------+ */

if (!("self" in this)) {
    self <- Entities.FindByClassname(null, "worldspawn")
} else {
    getroottable()["self"] <- self
}

// Library files
IncludeScript("pcapture-lib/PCapture-math")
IncludeScript("pcapture-lib/PCapture-array")
IncludeScript("pcapture-lib/PCapture-utils")
IncludeScript("pcapture-lib/PCapture-Entities")
IncludeScript("pcapture-lib/PCapture-EventHandler")
IncludeScript("pcapture-lib/PCapture-bboxcast")
IncludeScript("pcapture-lib/PCapture-anims")
IncludeScript("pcapture-lib/PCapture-Improvements")

dissolver <- entLib.CreateByClassname("env_entity_dissolver", {targetname = "@dissolver"})