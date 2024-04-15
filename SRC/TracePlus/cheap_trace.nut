// Haha, pseudo-constuctor-class
/*
 * Performs a cheap (fast but less accurate) trace.
 *
 * @param {Vector} startpos - The start position of the trace.
 * @param {Vector} endpos - The end position of the trace. 
 * @returns {CheapTraceResult} - The trace result object.
*/
 TracePlus["Cheap"] <- function(startpos, endpos) {
    local SCOPE = {}

    SCOPE.startpos <- startpos
    SCOPE.endpos <- endpos
    // SCOPE.type <- "CheapTrace"

    SCOPE.fraction <- TraceLine(startpos, endpos, null)
    local hitpos = startpos + (endpos - startpos) * SCOPE.fraction

    return TracePlus.Result.Cheap(SCOPE, hitpos)
}


/* 
 * Performs a cheap trace from the player's eyes. 
 *
 * @param {number} distance - The distance of the trace. 
 * @param {CBaseEntity|pcapEntity} player - The player entity.
 * @returns {CheapTraceResult} - The trace result object.
*/
TracePlus["FromEyes"]["Cheap"] <- function(distance, player) {
    // Calculate the start and end positions of the trace
    local startpos = player.EyePosition()
    local endpos = macros.GetEyeEndpos(player, distance)

    return TracePlus.Cheap(startpos, endpos)
}