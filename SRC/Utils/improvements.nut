/*+--------------------------------------------------------------------------------+
|                           PCapture Vscripts Library                               |
 +---------------------------------------------------------------------------------+
| Author:                                                                           |
|     One-of-a-Kind - laVashik :D                                                   |
 +---------------------------------------------------------------------------------+
| PCapture-Improvements.nut                                                         |
|       Overrides and improves existing standard VScripts functions.                |
|                                                                                   |
+----------------------------------------------------------------------------------+ */

if("_EntFireByHandle" in getroottable()) {
    return
}

/*
* Limits frametime to avoid zero values.
*
* @returns {number} Clamped frametime
*/
local _frametime = FrameTime
::FrameTime <- function() : (_frametime) {
    local tick = _frametime()
    if(tick == 0)
        return 0.016
    return tick
}

local _UniqueString = UniqueString
::UniqueString <- function(prefix = "u") : (_UniqueString) {
    return prefix + "_" + _UniqueString()
}

/*
* Wrapper for EntFireByHandle to handle PCapLib objects.
*
* @param {CBaseEntity|pcapEntity} target - Target entity.
* @param {string} action - Action.
* @param {string} value - Action value. (optional)
* @param {number} delay - Delay in seconds. (optional)
* @param {CBaseEntity|pcapEntity} activator - Activator entity. (optional)
* @param {CBaseEntity|pcapEntity} caller - Caller entity. (optional)
*/
local _EntFireByHandle = EntFireByHandle
::EntFireByHandle <- function(target, action, value = "", delay = 0, activator = null, caller = null) : (_EntFireByHandle) {
    /* Extract the underlying entity from the pcapEntity wrapper */
    if (typeof target == "pcapEntity")
        target = target.CBaseEntity
    if (typeof activator == "pcapEntity")
        activator = activator.CBaseEntity
    if (typeof caller == "pcapEntity")
        caller = target.CBaseEntity

    _EntFireByHandle(target, action, value, delay, activator, caller)
}

::AllPlayers <- array(3)

/*
* Retrieves a player entity with extended functionality.
*
* @param {int} index - The index of the player (1-based).
* @returns {pcapEntity} - An extended player entity with additional methods.
*/
::GetPlayerEx <- function(index = 1) {
    if(IsMultiplayer()) {
        foreach(idx, player in AllPlayers){
            if(idx == index) return player
        }
        return null
    }

    return entLib.FromEntity(GetPlayer())
}

::GetPlayers <- function() { // -> array
    return AllPlayers
}


function AttachEyeControlToPlayers() {
    for(local player; player = entLib.FindByClassname("player", player);) {
        if(player.GetUserData("Eye")) return

        local controlName = UniqueString("eyeControl")
        local eyeControlEntity = entLib.CreateByClassname("logic_measure_movement", {
            targetname = controlName, measuretype = 1}
        )

        local eyeName = UniqueString("eyePoint")
        local eyePointEntity = entLib.CreateByClassname("info_target", {targetname = eyeName})

        local playerName = player.GetName() == "" ? "!player" : player.GetName()

        EntFireByHandle(eyeControlEntity, "setmeasuretarget", playerName)
        EntFireByHandle(eyeControlEntity, "setmeasurereference", controlName);
        EntFireByHandle(eyeControlEntity, "SetTargetReference", controlName);
        EntFireByHandle(eyeControlEntity, "Settarget", eyeName);
        EntFireByHandle(eyeControlEntity, "Enable")

        player.SetUserData("Eye", eyePointEntity)
        AllPlayers.append(player)
    }
}