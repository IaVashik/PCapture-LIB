
/*
* Perform trace from player's eyes.
*
* @param {float} distance - Trace distance.
* @param {Entity} ignoreEnts - Entity to ignore.  
* @param {object} settings - Trace settings.
* @param {Entity} player - Player entity.
* @returns {bboxcast} Resulting trace. 
*/
function bboxcast::TracePlayerEyes(distance, ignoreEnts = null, settings = ::defaultSettings, player = null) {
    // Get the player's eye position and forward direction
    if(player == null) 
        player = GetPlayerEx()
    if(!player) 
        return bboxcast(Vector(), Vector())
    if(typeof player != "pcapEntity") 
        player = pcapPlayer(player)

    // Calculate the start and end positions of the trace
    local startpos = player.EyePosition()
    local endpos = startpos + player.EyeForwardVector() * distance

    // Check if any entities should be ignored during the trace
    if (ignoreEnts) {
        // If ignoreEnts is an array, append the player entity to it
        if (typeof ignoreEnts == "array" || typeof ignoreEnts == "arrayLib") {
            ignoreEnts.append(player)
        }
        // If ignoreEnts is a single entity, create a new array with both the player and ignoreEnts
        else {
            ignoreEnts = [player, ignoreEnts]
        }
    }
    // If no ignoreEnts is provided, ignore the player only
    else {
        ignoreEnts = player
    }

    // Perform the bboxcast trace and return the trace result
    return bboxcast(startpos, endpos, ignoreEnts, settings)
}