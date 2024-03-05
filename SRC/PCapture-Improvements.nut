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


// Overwriting existing functions to improve them
if("_EntFireByHandle" in getroottable()) {
    dev.warning("Improvements module initialization skipped. Module already initialized.")
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


/*
* Retrieves a player entity with extended functionality.
* 
* @param {int} index - The index of the player (1-based).
* @returns {pcapEntity} - An extended player entity with additional methods.
*/
::GetPlayerEx <- function(index = 1) {
    if(IsMultiplayer()) {
        local idx = 1
        for(local player; player = Entities.FindByClassname(player, "player"); idx++) {
            if(idx == index) return player
        }
        return null
    }

    return entLib.FromEntity(GetPlayer()) 
}