::TracePresets <- {}

local GetEyeEndpos = function(player, distance) {
    if(typeof player != "pcapEntity") 
        player = entLib.FromEntity(player)

    return player.EyePosition() + player.EyeForwardVector() * distance
}

::addInIgnoreList <- function(ignoreEnts, newEnt) {
    // Check if any entities should be ignored during the trace
    if (ignoreEnts) {
        // If ignoreEnts is an array, append the player entity to it
        if (typeof ignoreEnts == "array" || typeof ignoreEnts == "arrayLib") {
            ignoreEnts.append(newEnt)
        }
        // If ignoreEnts is a single entity, create a new array with both the player and ignoreEnts
        else {
            ignoreEnts = [newEnt, ignoreEnts]
        }
    }
    // If no ignoreEnts is provided, ignore the player only
    else {
        ignoreEnts = newEnt
    }
    return ignoreEnts
}


TracePresets["TracePlayerEyes"] <- function(distance, player, ignoreEnts = null, settings = ::defaultSettings) : (GetEyeEndpos, addInIgnoreList) {
    // Calculate the start and end positions of the trace
    local startpos = player.EyePosition()
    local endpos = GetEyeEndpos(player, distance)

    ignoreEnts = addInIgnoreList(ignoreEnts, player)

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

TracePresets["PortalTracePlayerEyes"] <- function(distance, player, ignoreEnts = null, settings = ::defaultSettings) : (GetEyeEndpos, addInIgnoreList) {
    // Calculate the start and end positions of the trace
    local startpos = player.EyePosition()
    local endpos = GetEyeEndpos(player, distance)
    ignoreEnts = addInIgnoreList(ignoreEnts, player)

    // Perform the bboxcast trace and return the trace result
    return PortalBboxCast(startpos, endpos, ignoreEnts, settings)
}