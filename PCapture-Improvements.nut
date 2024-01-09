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
_frametime <- FrameTime
function FrameTime() {
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
_EntFireByHandle <- EntFireByHandle
function EntFireByHandle(target, action, value = "", delay = 0, activator = null, caller = null) {
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
function GetPlayerEx(index = 1) { // TODO
    return pcapPlayer(GetPlayer())
}

class pcapPlayer extends pcapEntity {
    function EyePosition() {
        return this.CBaseEntity.EyePosition()
    }

    function EyeAngles() {
        return this.GetUserData("Eye").GetAngles()
    }

    function EyeForwardVector() {
        return this.GetUserData("Eye").GetForwardVector()
    }
}