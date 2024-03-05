// Haha, pseudo-constuctor-class
::CheapTrace <- function(startpos, endpos) {
    local SCOPE = {}

    SCOPE.startpos <- startpos
    SCOPE.endpos <- endpos
    SCOPE.type <- "CheapTrace"

    SCOPE.fraction <- TraceLine(startpos, endpos, null)
    local hitpos = startpos + (endpos - startpos) * SCOPE.fraction

    return TraceResult(SCOPE, hitpos)
}