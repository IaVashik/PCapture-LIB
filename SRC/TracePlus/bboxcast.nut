TracePlus["Bbox"] <- function(startpos, endpos, ignoreEnts = null, settings = defaultSettings, note = null) {
    local SCOPE = {} // TODO potential place for improvement
    
    SCOPE.startpos <- startpos;
    SCOPE.endpos <- endpos;
    SCOPE.ignoreEnts <- ignoreEnts
    SCOPE.settings <- settings
    SCOPE.note <- note
    // SCOPE.type <- "BboxCast"

    local result = TraceLineAnalyzer(startpos, endpos, ignoreEnts, settings, note) // TODO :<
    
    return TracePlus.Result.Bbox(SCOPE, result.GetHitpos(), result.GetEntity())
}

TracePlus["FromEyes"]["Bbox"] <- function(distance, player, ignoreEnts = null, settings = ::defaultSettings) { //! BUG TODO: defaultSettings
    // Calculate the start and end positions of the trace
    local startpos = player.EyePosition()
    local endpos = macros.GetEyeEndpos(player, distance)

    ignoreEnts = this.Settings.UpdateIgnoreEnts(ignoreEnts, player)

    // Perform the bboxcast trace and return the trace result
    return BboxCast(startpos, endpos, ignoreEnts, settings)
}

TracePlus["FromEyes"]["PortalBbox"] <- function(distance, player, ignoreEnts = null, settings = ::defaultSettings) {
    // Calculate the start and end positions of the trace
    local startpos = player.EyePosition()
    local endpos = macros.GetEyeEndpos(player, distance)
    ignoreEnts = this.Settings.UpdateIgnoreEnts(ignoreEnts, player)

    // Perform the bboxcast trace and return the trace result
    return PortalBboxCast(startpos, endpos, ignoreEnts, settings)
}