if("GetPlayerEx" in getroottable()) {
    return
}

/*
* Limits frametime to avoid zero values.
*
* @returns {number} Clamped frametime
*/
local _frametime = FrameTime
/*
 * Returns the current frame time, ensuring it is never zero. 
 * 
 * This function overrides the standard FrameTime function to prevent issues that can arise from zero frame times. 
 * If the frame time is zero, it returns a small default value (0.016). 
 *
 * @returns {number} - The current frame time. 
*/
::FrameTime <- function() : (_frametime) {
    local tick = _frametime()
    if(tick == 0)
        return 0.016
    return tick
}

local _UniqueString = UniqueString
/*
 * Generates a unique string with the specified prefix. 
 * 
 * This function overrides the standard UniqueString function to include a prefix in the generated string. 
 *
 * @param {string} prefix - The prefix to use for the unique string. (optional, default="u") 
 * @returns {string} - The generated unique string. 
*/ 
::UniqueString <- function(prefix = "u") : (_UniqueString) {
    return prefix + "_" + _UniqueString().slice(0, -1)
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
/*
 * Triggers an entity's input with optional delay and activator/caller. 
 *
 * This function overrides the standard EntFireByHandle function to handle pcapEntity objects and extract the underlying CBaseEntity objects. 
 * It also allows specifying an activator and caller entity. 
 *
 * @param {CBaseEntity|pcapEntity} target - The target entity to trigger the input on. 
 * @param {string} action - The name of the input to trigger. 
 * @param {string} value - The value to pass to the input. (optional)
 * @param {number} delay - The delay in seconds before triggering the input. (optional)
 * @param {CBaseEntity|pcapEntity} activator - The activator entity (the entity that triggered the input). (optional)
 * @param {CBaseEntity|pcapEntity} caller - The caller entity (the entity that called the function). (optional) 
*/
::EntFireByHandle <- function(target, action, value = "", delay = 0, activator = null, caller = null) : (_EntFireByHandle) {
    // Extract the underlying entity from the pcapEntity wrapper 
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

/* 
 * Gets an array of all players in the game. 
 *
 * @returns {array} - An array of pcapEntity objects representing the players. 
*/
::GetPlayers <- function() { // -> array
    return AllPlayers
}


/* 
 * Attaches eye control entities to all players in the game. 
 *
 * This function creates logic_measure_movement and info_target entities for each player to track their eye position and angles. 
 * It is called automatically at the initialization of the library and periodically in multiplayer games. 
*/
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