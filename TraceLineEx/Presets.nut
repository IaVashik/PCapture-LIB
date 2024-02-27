::TracePresets <- {}

local GetEyeEndpos = function(player, distance) {
    if(typeof player != "pcapEntity") 
        player = pcapPlayer(player) //! TODO change in merge commit!

    return player.EyePosition() + player.EyeForwardVector() * distance
}


TracePresets["TracePlayerEyes"] <- function(distance, player, ignoreEnts = null, settings = ::defaultSettings) : (GetEyeEndpos) {
    // Calculate the start and end positions of the trace
    local startpos = player.EyePosition()
    local endpos = GetEyeEndpos(player, distance)

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
    return BboxCast(startpos, endpos, ignoreEnts, settings)
}


TracePresets["CheapTracePlayerEyes"] <- function(distance, player) : (GetEyeEndpos) {
    // Calculate the start and end positions of the trace
    local startpos = player.EyePosition()
    local endpos = GetEyeEndpos(player, distance)

    return CheapTrace(startpos, endpos)
}

TracePresets["CheapPortalTracePlayerEyes"] <- function(distance, player) : (GetEyeEndpos) {
    // Calculate the start and end positions of the trace
    local startpos = player.EyePosition()
    local endpos = GetEyeEndpos(player, distance)

    return PortalTrace(startpos, endpos)
}