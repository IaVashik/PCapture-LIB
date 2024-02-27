::BboxCast <- function(startpos, endpos, ignoreEnts = null, settings = defaultSettings, note = null) {
    local SCOPE = {}
    
    SCOPE.startpos <- startpos;
    SCOPE.endpos <- endpos;
    SCOPE.ignoreEnts <- ignoreEnts
    SCOPE.settings <- settings
    SCOPE.type <- "BboxCast"

    local result = TraceLineAnalyzer(SCOPE, settings, note)
    
    return BboxTraceResult(SCOPE, result.GetHitpos(), result.GetEntity())
}