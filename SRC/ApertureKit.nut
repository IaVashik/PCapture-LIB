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
IncludeScript("pcapture-lib/SRC/PCapture-Math")
IncludeScript("pcapture-lib/SRC/PCapture-Arrays")
IncludeScript("pcapture-lib/SRC/PCapture-Utils")
IncludeScript("pcapture-lib/SRC/PCapture-Entities")
IncludeScript("pcapture-lib/SRC/PCapture-EventHandler")
IncludeScript("pcapture-lib/SRC/PCapture-Anims")
IncludeScript("pcapture-lib/SRC/PCapture-Improvements")
// TracePlus files:
IncludeScript("pcapture-lib/SRC/TracePlus/TraceSettings")
IncludeScript("pcapture-lib/SRC/TracePlus/TraceResult")
IncludeScript("pcapture-lib/SRC/TracePlus/CheapTrace")
IncludeScript("pcapture-lib/SRC/TracePlus/TraceLineAnalyzer")
IncludeScript("pcapture-lib/SRC/TracePlus/BboxCasting")
IncludeScript("pcapture-lib/SRC/TracePlus/PortalCasting")
IncludeScript("pcapture-lib/SRC/TracePlus/Presets")
IncludeScript("pcapture-lib/SRC/TracePlus/utils/ImpactNormal")
IncludeScript("pcapture-lib/SRC/TracePlus/utils/BBoxDisabler")


// Other stuff
//* Default settings for bboxcast traces.
::defaultSettings <- TraceSettings.new()

if(("dissolver" in getroottable()) == false) {
    ::dissolver <- entLib.CreateByClassname("env_entity_dissolver", {targetname = "@dissolver"})
} 


function AttachEyeControlToPlayers() {
    for(local player; player = entLib.FindByClassname("player", player);) {
        if(player.GetUserData("Eye")) return
    
        local controlName = "eyeControl" + UniqueString()
        local eyeControlEntity = entLib.CreateByClassname("logic_measure_movement", {
            targetname = controlName, measuretype = 1}
        )
    
        local eyeName = "eyePoint" + UniqueString()
        local eyePointEntity = entLib.CreateByClassname("info_target", {targetname = eyeName})
    
        local playerName = player.GetName() == "" ? "!player" : player.GetName()
    
        EntFireByHandle(eyeControlEntity, "setmeasuretarget", playerName)
        EntFireByHandle(eyeControlEntity, "setmeasurereference", controlName);
        EntFireByHandle(eyeControlEntity, "SetTargetReference", controlName);
        EntFireByHandle(eyeControlEntity, "Settarget", eyeName);
        EntFireByHandle(eyeControlEntity, "Enable")
    
        player.SetUserData("Eye", eyePointEntity)
    }
}

AttachEyeControlToPlayers()
if(IsMultiplayer()) {
    RunScriptCode.setInterval(AttachEyeControlToPlayers, 5)
} 
