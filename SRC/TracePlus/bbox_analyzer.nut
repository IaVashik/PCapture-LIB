// Expensive/Precise TraceLine logic

// Класс для хранения данных об объекте
class BufferedEntity {
    entity = null;
    origin = null;
    isCubicBbox = null
    bboxMax = null;
    bboxMin = null;
    len = null

    constructor(entity) {
        this.entity = entLib.FromEntity(entity)
        this.origin = entity.GetOrigin()
        this.len = ( entity.GetBoundingMaxs() - entity.GetBoundingMins() ).Length() / 2

        this.isCubicBbox = floor((entity.GetBoundingMaxs() + entity.GetBoundingMins()).Length()) == 0
        if(this.isCubicBbox) { // bbox квадратный
            this.bboxMax = entity.GetBoundingMaxs() + this.origin
            this.bboxMin = entity.GetBoundingMins() + this.origin
        }
        else { // bbox прямоугольный
            this.bboxMax = this.entity.CreateAABB(7) + this.origin
            this.bboxMin = this.entity.CreateAABB(0) + this.origin
        }
    }
}

const JumpPercent = 0.25

/*
 * A class for performing precise trace line analysis. 
 * 
 * This class provides methods for tracing lines with more precision and considering entity priorities and ignore settings. 
*/
 ::TraceLineAnalyzer <- class {
    settings = null;
    hitpos = null;
    hitent = null;

    /*
     * Constructor for TraceLineAnalyzer.
     *
     * @param {Vector} startpos - The start position of the trace.
     * @param {Vector} endpos - The end position of the trace.
     * @param {array|CBaseEntity|null} ignoreEntities - A list of entities or a single entity to ignore during the trace. 
     * @param {TraceSettings} settings - The settings to use for the trace. 
     * @param {string|null} note - An optional note associated with the trace. 
    */ 
    constructor(startpos, endpos, ignoreEntities, settings, note) {
        if(typeof settings != "TraceSettings") throw("Invalid trace settings provided. Expected an instance of TracePlus.Settings")
        this.settings = settings
        
        local result = this.Trace(startpos, endpos, ignoreEntities, note)
        this.hitpos = result[0]
        this.hitent = result[1]
    }

    /*
     * Gets the hit position of the trace. 
     *
     * @returns {Vector} - The hit position. 
    */
    function GetHitpos() {
        return this.hitpos
    }

    /* 
     * Gets the entity hit by the trace. 
     *
     * @returns {CBaseEntity|null} - The hit entity, or null if no entity was hit.
    */
    function GetEntity() {
        return this.hitent
    }

    /* 
     * Performs a precise trace line analysis. 
     *
     * This method subdivides the trace into smaller segments and checks for entity collisions along the way, 
     * considering entity priorities and ignore settings.
     * 
     * @param {Vector} startPos - The start position of the trace.
     * @param {Vector} endPos - The end position of the trace.
     * @param {array|CBaseEntity|null} ignoreEntities - A list of entities or a single entity to ignore during the trace. 
     * @param {string|null} note - An optional note associated with the trace. 
     * @returns {array} - An array containing the hit position and the hit entity (or null). 
    */
    function Trace(startPos, endPos, ignoreEntities, note) array(hitPos, hitEnt) 
    /* 
     * Checks if an entity is a priority entity based on the trace settings.
     *
     * @param {string} entityClass - The classname of the entity. 
     * @returns {boolean} - True if the entity is a priority entity, false otherwise. 
    */
    function _isPriorityEntity() bool
    /* 
     * Checks if an entity should be ignored based on the trace settings. 
     *
     * @param {string} entityClass - The classname of the entity. 
     * @returns {boolean} - True if the entity should be ignored, false otherwise. 
    */
    function _isIgnoredEntity() bool
    /* 
     * Checks if the trace should consider a hit with the given entity.
     * 
     * @param {CBaseEntity} ent - The entity to check.
     * @param {array|CBaseEntity|null} ignoreEntities - A list of entities or a single entity to ignore during the trace. 
     * @param {string|null} note - An optional note associated with the trace. 
     * @returns {boolean} - True if the trace should consider the hit, false otherwise. 
    */
    function shouldHitEntity() bool
}


/*
 * Performs a precise trace line analysis. 
 *
 * This method subdivides the trace into smaller segments and checks for entity collisions along the way, 
 * considering entity priorities and ignore settings.
 * 
 * @param {Vector} startPos - The start position of the trace.
 * @param {Vector} endPos - The end position of the trace.
 * @param {array|CBaseEntity|null} ignoreEntities - A list of entities or a single entity to ignore during the trace. 
 * @param {string|null} note - An optional note associated with the trace. 
 * @returns {array} - An array containing the hit position and the hit entity (or null). 
*/
// todo dist_coeff сосат, теперь это legacy
function TraceLineAnalyzer::Trace(startPos, endPos, ignoreEntities, note = null) {
    // Get the hit position from the fast trace
    local hitPos = TracePlus.Cheap(startPos, endPos).GetHitpos()
    local dist = hitPos - startPos

    //* NEW LOGIC
    local entBuffer = List()
    local halfSegment = dist * JumpPercent * 0.5
    local segmentsLenght = halfSegment * 2
    local searchRadius = halfSegment.Length()
   
    // region old code
    // // Dirt Search
    // for(local segment = JumpPercent; segment < 1; segment += JumpPercent) {
    //     local segmentCenter = startPos + dist * segment // середина сегмента
    //     for (local ent;ent = Entities.FindByClassnameWithin(ent, "*", segmentCenter, searchRadius);) {
    //         if (ent && this.shouldHitEntity(ent, ignoreEntities, note)) {
    //             entBuffer.append(BufferedEntity(ent))
    //         }
    //     }
    //     // dev.drawbox(segmentCenter, Vector(0, 125, 255), 6)

    //     if(entBuffer.len() > 0) {
    //         // тут уже речь про верные, успешные сегменты, надо бы нейм поправить!
    //         local segmentStart = segmentCenter - halfSegment
    //         local segmentEnd = segmentCenter + halfSegment
    //         local segmentDist = segmentEnd - segmentStart
            
    //         local steps = searchRadius / 10 * 2
             
    //         // Deep search
    //         for (local i = 0.0; i <= steps; i++) {
    //             local rayPart = segmentStart + segmentDist * (i / steps)
    //             // dev.drawbox(rayPart, Vector(0, 200, 100), 6)
        
    //             foreach(entInfo in entBuffer.iter()) {
    //                 if(this.PointInBBox(rayPart, entInfo)) {
    //                     DebugDrawBox(rayPart, Vector(3,3,3) * -1, Vector(3,3,3), 0, 255, 0, 170, 6)
    //                     return [rayPart, entInfo.entity]
    //                 }
    //             }
    //         }

    //         entBuffer.clear()
    //     }
    // } 
    // endregion

    // dev.drawbox(startPos, Vector(255, 255, 255), 6)
    // dev.drawbox(hitPos, Vector(255, 255, 255), 6)
    for(local segment = 0; segment < 1; segment += JumpPercent) {
        // DIRT Search
        local segmentCenter = startPos + dist * (segment + JumpPercent * 0.5) // середина сегмента
        for (local ent;ent = Entities.FindByClassnameWithin(ent, "*", segmentCenter, searchRadius);) {
            if (ent && this.shouldHitEntity(ent, ignoreEntities, note)) {
                entBuffer.append(BufferedEntity(ent))
            }
        }
        // dev.drawbox(segmentCenter, Vector(255, 0, 0), 6)
        // DebugDrawLine(segmentCenter + halfSegment, segmentCenter - halfSegment, 255, 255, 255, false, 6)

        // Fast Search
        if(entBuffer.len() > 0) {
            local segmentStart = segmentCenter - halfSegment
            local segmentEnd = segmentCenter + halfSegment
            local steps = searchRadius / 15 // нахуй надо!! юзаем также по сегментации как выше!!!
            local closestPoint = null
            for (local i = 0.0; i <= steps && closestPoint == null; i++) {
                local rayPart = segmentStart + segmentsLenght * (i / steps)
                foreach(entInfo in entBuffer.iter()) {
                    local offset = rayPart - entInfo.origin
                    local dis = (rayPart - entInfo.origin).Length()
                    if(dis <= entInfo.len) {
                        // DebugDrawBox(rayPart, Vector(3,3,3) * -1, Vector(3,3,3), 255, 255, 0, 10, 6)
                        closestPoint = rayPart
                        break
                    }
                }
                // dev.drawbox(rayPart, Vector(255, 125, 0), 6)
            }

            // Deep Search
            if(closestPoint != null) {
                local len = segmentsLenght * 0.5
                local segmentStart = closestPoint
                local segmentEnd = segmentStart + len
                local steps = searchRadius / 5
                for (local i = 0.0; i <= steps; i++) {
                    local rayPart = segmentStart + len * (i / steps)
                    foreach(entInfo in entBuffer.iter()) {
                        if(this.PointInBBox(rayPart, entInfo)) {
                            // DebugDrawBox(rayPart, Vector(3,3,3) * -1, Vector(3,3,3), 0, 255, 0, 255, 6)
                            return [rayPart, entInfo.entity]
                        }
                    }
                    // dev.drawbox(rayPart, Vector(125, 200, 0), 6)
                }
            }
            // dev.info("DROP {} ents", entBuffer.len())
            // Очистка буфера
            entBuffer.clear() // TODO improve perfomance
        }
    }

    return [hitPos, null]
}

function TraceLineAnalyzer::PointInBBox(point, entInfo) {
    local max = entInfo.bboxMax
    local min = entInfo.bboxMin

    return (
        point.x >= min.x && point.x <= max.x &&
        point.y >= min.y && point.y <= max.y &&
        point.z >= min.z && point.z <= max.z
    )
}

// Check if an entity should be ignored based on the provided settings
/*
* Check if entity is a priority class.
*
* @param {string} entityClass - Entity class name.
* @returns {boolean} True if priority.
*/
function TraceLineAnalyzer::_isPriorityEntity(entityClass) {
    if(settings.GetPriorityClasses().len() == 0) 
        return false
    return settings.GetPriorityClasses().search(function(val):(entityClass) {
        return entityClass.find(val) >= 0
    }) != null
}

/* 
* Check if entity is an ignored class.
*
* @param {string} entityClass - Entity class name.
* @returns {boolean} True if ignored.
*/
function TraceLineAnalyzer::_isIgnoredEntity(entityClass) {
    if(settings.GetIgnoreClasses().len() == 0) 
        return false
    if(settings.GetIgnoreClasses().contains("*"))
        return true
    return settings.GetIgnoreClasses().search(function(val):(entityClass) {
        return entityClass.find(val) >= 0
    }) != null
}

/* 
* Check if the entity model is in the list of ignored models.
*
* @param {string} entityModel - The model name of the entity.
* @returns {boolean} True if the model is ignored, false otherwise. 
*/
function TraceLineAnalyzer::_isIgnoredModels(entityModel) {
    if(settings.GetIgnoredModels().len() == 0 || entityModel == "") 
        return false
    return settings.GetIgnoredModels().search(function(val):(entityModel) {
        return entityModel.find(val) >= 0
    }) != null
}

/*
* Check if entity should be ignored.
*
* @param {Entity} ent - Entity to check.
* @param {Entity|array} ignoreEntities - Entities being ignored. 
* @returns {boolean} True if should ignore.
*/
function TraceLineAnalyzer::shouldHitEntity(ent, ignoreEntities, note) { 
    // if(ent.GetUserData("TracePlusIgnore")) // todo 
    //     return false
    
    if(settings.ApplyIgnoreFilter(ent, note))
        return false

    if(settings.ApplyCollisionFilter(ent, note))
        return true

    if(ignoreEntities) {
        // Processing for arrays
        local type = typeof ignoreEntities 
        if (type == "array" || type == "arrayLib") {
            foreach (mask in ignoreEntities) {
                if(ent.entindex() == mask.entindex()) return false 
            }
        } 
        else if(type == "List") {
            foreach (mask in ignoreEntities.iter()) {
                if(ent.entindex() == mask.entindex()) return false 
            }
        }
        // (ignoreEntities instanceof CBaseEntity || type == "pcapEntity") 
        else if(ent.entindex() == ignoreEntities.entindex()) return false
    }

    local classname = ent.GetClassname()
    if (_isIgnoredEntity(classname) && !_isPriorityEntity(classname)) {
        return false
    }
    
    if(_isIgnoredModels(ent.GetModelName())) {
        return false
    }

    return true
}