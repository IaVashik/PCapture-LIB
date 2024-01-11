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
IncludeScript("pcapture-lib/PCapture-Math")
IncludeScript("pcapture-lib/PCapture-Arrays")
IncludeScript("pcapture-lib/PCapture-Utils")
IncludeScript("pcapture-lib/PCapture-Entities")
IncludeScript("pcapture-lib/PCapture-EventHandler")
IncludeScript("pcapture-lib/PCapture-Bboxcast")
IncludeScript("pcapture-lib/PCapture-Anims")
IncludeScript("pcapture-lib/PCapture-Improvements")

dissolver <- entLib.CreateByClassname("env_entity_dissolver", {targetname = "@dissolver"})