::TraceLineAnalyzer <- class {
    settings = null;
    hitpos = null;
    hitent = null;

    constructor(startpos, endpos, ignoreEnts, settings, note) {
        this.settings = settings // todo
        
        local result = this.Trace(startpos, endpos, ignoreEnts, note)
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
    function Trace(startpos, endpos, ignoreEnts, note) array(hitpos, hitent) 
    function _isPriorityEntity() bool
    function _isIgnoredEntity() bool
    function _hitEntity() bool
}


function TraceLineAnalyzer::Trace(startpos, endpos, ignoreEnts, note) {
    // Get the hit position from the fast trace
    local hitpos = CheapTrace(startpos, endpos).GetHitpos()
    // Calculate the distance between start and hit positions
    local dist = hitpos - startpos
    // Calculate a distance coefficient for more precise tracing based on distance and error coefficient
    local dist_coeff = abs(dist.Length() / settings.GetErrorTolerance()) + 1
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
    return settings.GetIgnoreClasses().search(function(val):(entityClass) {
        return entityClass.find(val) >= 0
    }) != null
}

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
* @param {Entity|array} ignoreEnts - Entities being ignored. 
* @returns {boolean} True if should ignore.
*/
function TraceLineAnalyzer::_hitEntity(ent, ignoreEnts, note) { // todo rename
    // todo
    if(settings.ApplyIgnoreFilter(ent, note))
        return false

    if(settings.ApplyCollisionFilter(ent, note))
        return true


    if(ignoreEnts) { // TODO пускай всегда будет массивом, а трейсеры будут оборачивать одиночек, хуле нет)
        // Processing for arrays
        local type = typeof ignoreEnts
        if (type == "array" || type == "arrayLib") {
            foreach (mask in ignoreEnts) {
                if(this._eqEnts(mask, ent)) return false
            }
        } 
        
        else if(this._eqEnts(ignoreEnts, ent)) return false
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

function TraceLineAnalyzer::_eqEnts(ent1, ent2) {
    if(typeof ent1 == "pcapEntity")
        ent1 = ent1.CBaseEntity
    return ent1 == ent2
}