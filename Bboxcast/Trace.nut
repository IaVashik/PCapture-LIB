/*
* Perform the main trace.
*
* @param {Vector} startpos - Start position.
* @param {Vector} endpos - End position.
* @param {Entity} ignoreEnts - Entity to ignore.
* @returns {object} Trace result.
*/
function bboxcast::Trace(startpos, endpos, ignoreEnts, note) {
    // Get the hit position from the fast trace
    local hitpos = this.CheapTrace(startpos, endpos)
    // Calculate the distance between start and hit positions
    local dist = (hitpos - startpos).Length()
    // Calculate a distance coefficient for more precise tracing based on distance and error coefficient
    local dist_coeff = abs(dist / this.settings.GetErrorCoefficient()) + 1
    // Calculate the number of steps based on distance and distance coefficient
    local step = dist / 14 / dist_coeff

    // Iterate through each step
    for (local i = 0.0; i < step; i++) {
        // Calculate the ray position for the current step
        local rayPart = startpos + dist * (i / step)
        // Find the entity at the ray point
        // TODO!!! separate code! "*"
        for (local ent;ent = Entities.FindByClassnameWithin(ent, "*", rayPart, 5 * dist_coeff);) {
            if (ent && _hitEntity(ent, ignoreEnts, note)) {
                return {hit = rayPart, ent = ent}
            }
        }
    }

    return {hit = hitpos, ent = null}
}

// Check if an entity should be ignored based on the provided settings
/*
* Check if entity is a priority class.
*
* @param {string} entityClass - Entity class name.
* @returns {boolean} True if priority.
*/
function bboxcast::_isPriorityEntity(entityClass) {
    return settings.GetPriorityClass().find(entityClass) // todo!
}

/* 
* Check if entity is an ignored class.
*
* @param {string} entityClass - Entity class name.
* @returns {boolean} True if ignored.
*/
function bboxcast::_isIgnoredEntity(entityClass) {
    return settings.GetIgnoreClass().find(entityClass)
}

/*
* Check if entity should be ignored.
*
* @param {Entity} ent - Entity to check.
* @param {Entity|array} ignoreEnts - Entities being ignored. 
* @returns {boolean} True if should ignore.
*/
function bboxcast::_hitEntity(ent, ignoreEnts, note) {
    local classname = ent.GetClassname()

    // todo
    if(settings.customFilter && settings.customFilter(ent, note))
        return true

    // todo
    // if(settings.RunUserFilter2(ent, note))
    //     return false

    if (typeof ignoreEnts == "array" || typeof ignoreEnts == "arrayLib") { // todo
        foreach (mask in ignoreEnts) {
            if(typeof mask == "pcapEntity")
                mask = mask.CBaseEntity
            if (mask == ent) {
                return false;
            }
        }
    } 
    else if (ent == ignoreEnts) {
        return false;
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