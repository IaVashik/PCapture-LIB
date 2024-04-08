// Haha, pseudo-constuctor-class
TracePlus["Cheap"] <- function(startpos, endpos) {
    local SCOPE = {}

    SCOPE.startpos <- startpos
    SCOPE.endpos <- endpos
    // SCOPE.type <- "CheapTrace"

    SCOPE.fraction <- TraceLine(startpos, endpos, null)
    local hitpos = startpos + (endpos - startpos) * SCOPE.fraction

    return TracePlus.Result.Cheap(SCOPE, hitpos)
}


TracePlus["FromEyes"]["Cheap"] <- function(distance, player) {
    // Calculate the start and end positions of the trace
    local startpos = player.EyePosition()
    local endpos = macros.GetEyeEndpos(player, distance)

    return this.Cheap(startpos, endpos)
}

TracePlus["FromEyes"]["PortalCheap"] <- function(distance, player) {
    // Calculate the start and end positions of the trace
    local startpos = player.EyePosition()
    local endpos = macros.GetEyeEndpos(player, distance)

    return this.PortalCheap(startpos, endpos)
}