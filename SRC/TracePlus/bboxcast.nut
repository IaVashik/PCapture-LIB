/*
 * Performs a bbox cast (trace with bounding box) from the specified start and end positions. 
 *
 * @param {Vector} startPos - The start position of the trace.
 * @param {Vector} endPos - The end position of the trace.
 * @param {array|CBaseEntity|null} ignoreEntities - A list of entities or a single entity to ignore during the trace. (optional)
 * @param {TraceSettings} settings - The settings to use for the trace. (optional, defaults to TracePlus.defaultSettings) 
 * @param {string|null} note - An optional note associated with the trace. 
 * @returns {BboxTraceResult} - The trace result object. 
*/
 TracePlus["Bbox"] <- function(startPos, endPos, ignoreEntities = null, settings = TracePlus.defaultSettings, note = null) {
    local SCOPE = {} // TODO potential place for improvement
    
    SCOPE.startpos <- startPos;
    SCOPE.endpos <- endPos;
    SCOPE.ignoreEntities <- ignoreEntities 
    SCOPE.settings <- settings
    SCOPE.note <- note
    // SCOPE.type <- "BboxCast"

    local result = TraceLineAnalyzer(startPos, endPos, ignoreEntities, settings, note)
    
    return TracePlus.Result.Bbox(SCOPE, result.GetHitpos(), result.GetEntity())
}

/*
 * Performs a bbox cast from the player's eyes. 
 *
 * @param {number} distance - The distance of the trace. 
 * @param {CBaseEntity|pcapEntity} player - The player entity.
 * @param {array|CBaseEntity|null} ignoreEntities - A list of entities or a single entity to ignore during the trace. (optional)
 * @param {TraceSettings} settings - The settings to use for the trace. (optional, defaults to TracePlus.defaultSettings) 
 * @returns {BboxTraceResult} - The trace result object. 
*/
TracePlus["FromEyes"]["Bbox"] <- function(distance, player, ignoreEntities = null, settings = TracePlus.defaultSettings) {
    // Calculate the start and end positions of the trace
    local startPos = player.EyePosition()
    local endPos = macros.GetEyeEndpos(player, distance)

    ignoreEntities = TracePlus.Settings.UpdateIgnoreEntities(ignoreEntities, player)

    // Perform the bboxcast trace and return the trace result
    return TracePlus.Bbox(startPos, endPos, ignoreEntities, settings)
}