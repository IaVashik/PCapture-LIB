::TraceLineAnalyzer <- class {
    bboxcastInstance = null
    settings = null;

    hitpos = null;
    hitent = null;

    constructor(bboxcast, settings, note) {
        this.bboxcastInstance = bboxcast
        this.settings = settings

        local result = this.Trace(bboxcastInstance, note)
        this.hitpos = result[0]
        this.hitent = result[1]
    }

    function GetHitpos() {
        return this.hitpos
    }

    function GetEntity() {
        return this.hitent
    }

    // todo add args
    function Trace(bboxcastInstance, note) array(hitpos, hitent) 
    function _isPriorityEntity() bool
    function _isIgnoredEntity() bool
    function _hitEntity() bool
}


function TraceLineAnalyzer::Trace(bboxcastInstance, note) {
    local startpos = bboxcastInstance.startpos
    local endpos = bboxcastInstance.endpos
    local ignoreEnts = bboxcastInstance.ignoreEnts

    // Get the hit position from the fast trace
    local hitpos = CheapTrace(startpos, endpos).GetHitpos()
    // Calculate the distance between start and hit positions
    local dist = hitpos - startpos
    // Calculate a distance coefficient for more precise tracing based on distance and error coefficient
    local dist_coeff = abs(dist.Length() / settings.GetErrorCoefficient()) + 1
    // Calculate the number of steps based on distance and distance coefficient
    local step = dist.Length() / 14 / dist_coeff

    // Iterate through each step
    for (local i = 0.0; i < step; i++) {
        // Calculate the ray position for the current step
        local rayPart = startpos + dist * (i / step)
        // Find the entity at the ray point
        // TODO!!! separate code! "*"
        for (local ent;ent = Entities.FindByClassnameWithin(ent, "*", rayPart, 5 * dist_coeff);) { // todo what about this shit?
            if (ent && this._hitEntity(ent, ignoreEnts, note)) {
                return [rayPart, ent] // no tuple? :>
            }
        }
    }

    return [hitpos, null]
}

// Check if an entity should be ignored based on the provided settings
/*
* Check if entity is a priority class.
*
* @param {string} entityClass - Entity class name.
* @returns {boolean} True if priority.
*/
function TraceLineAnalyzer::_isPriorityEntity(entityClass) {
    return settings.GetPriorityClass().find(entityClass) // todo!
}

/* 
* Check if entity is an ignored class.
*
* @param {string} entityClass - Entity class name.
* @returns {boolean} True if ignored.
*/
function TraceLineAnalyzer::_isIgnoredEntity(entityClass) {
    return settings.GetIgnoreClass().find(entityClass)
}

/*
* Check if entity should be ignored.
*
* @param {Entity} ent - Entity to check.
* @param {Entity|array} ignoreEnts - Entities being ignored. 
* @returns {boolean} True if should ignore.
*/
function TraceLineAnalyzer::_hitEntity(ent, ignoreEnts, note) {
    local classname = ent.GetClassname()

    // todo
    if(settings.customFilter && settings.customFilter(ent, note))
        return true

    // todo
    // if(settings.RunUserFilter2(ent, note))
    //     return false
    if(ignoreEnts) {
        if (typeof ignoreEnts == "array" || typeof ignoreEnts == "arrayLib") { // todo
            foreach (mask in ignoreEnts) {
                if(typeof mask == "pcapEntity")
                    mask = mask.CBaseEntity
                if (mask == ent) {
                    return false;
                }
            }
        } 
        else if (ent == ignoreEnts.CBaseEntity) {
            return false;
        }
    }

    if (_isIgnoredEntity(classname) && !_isPriorityEntity(classname)) {
        return false
    }
    else {  //! critical todo
        local classType = split(classname, "_")[0] + "_"
        if(_isIgnoredEntity(classType) && !_isPriorityEntity(classname))
            return false
    }

    return true
}