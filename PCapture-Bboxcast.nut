/*+--------------------------------------------------------------------------------+
|                           PCapture Vscripts Library                               |
 +---------------------------------------------------------------------------------+
| Author:                                                                           |
|     One-of-a-Kind - laVashik :D                                                   |
 +---------------------------------------------------------------------------------+
| PCapture-bboxcast.nut                                                             |
|       Improved BBoxCast. More info here:                                          |
|       https://github.com/IaVashik/portal2-BBoxCast                                |
+----------------------------------------------------------------------------------+ */

if("bboxcast" in getroottable()) {
    dev.warning("Animate module initialization skipped. Module already initialized.")
    return
}

/*
* Default settings for bboxcast traces.
*/  
::defaultSettings <- TraceSettings.new()

/*
* A class for performing bbox-based ray tracing in Portal 2.
*/
::bboxcast <- class {
    startpos = null;
    endpos = null;
    ignoreEnt = null;
    settings = null;

    hitpos = null;
    hitent = null;
    surfaceNormal = null;

    PortalFound = [];

    /*
    * Constructor.
    *
    * @param {Vector} startpos - Start position.
    * @param {Vector} endpos - End position.
    * @param {CBaseEntity|pcapEntity|array|arrayLib} ignoreEnt - Entity to ignore. 
    * @param {object} settings - Trace settings.
    */
    constructor(startpos, endpos, ignoreEnt = null, settings = defaultSettings) {
        this.startpos = startpos;
        this.endpos = endpos;
        this.ignoreEnt = ignoreEnt
        this.settings = settings

        local result = this.Trace(startpos, endpos, ignoreEnt)
        this.hitpos = result.hit
        this.hitent = result.ent
    }

    /*
    * Get the starting position.
    *
    * @returns {Vector} Start position.
    */
    function GetStartPos() {
        return startpos
    }

    /*
    * Get the ending position.
    * 
    * @returns {Vector} End position.
    */
    function GetEndPos() {
        return endpos
    }

     /*
    * Get the hit position.
    *
    * @returns {Vector} Hit position. 
    */
    function GetHitpos() {
        return hitpos
    }

    /*
    * Get the hit entity.
    *
    * @returns {Entity} Hit entity.
    */
    function GetEntity() {
        return entLib.FromEntity(hitent)
    }

    /*
    * Get entities to ignore.
    *
    * @returns {Entity|array} Ignored entities.
    */
    function GetIngoreEntities() {
        return ignoreEnt
    }

    /*
    * Check if the trace hit anything.
    *
    * @returns {boolean} True if hit.
    */
    function DidHit() {
        return GetFraction() != 1
    }

    /*
    * Check if the trace hit the world.
    *
    * @returns {boolean} True if hit world.
    */
    function DidHitWorld() {
        return (!hitent && DidHit())
    }

    /*
    * Get the fraction of the path traversed.
    *
    * @returns {float} Path fraction.
    */
    function GetFraction() {
        return this._GetDist(startpos, hitpos) / this._GetDist(startpos, endpos)
    }

    /*
    * Get the direction.
    *
    * @returns {Vector} Direction.
    */
    function GetDir() {
        return this.endpos - this.startpos
    }

    /*
    * Get the surface normal at the impact point.
    *
    * @returns {Vector} Surface normal. 
    */
    function GetImpactNormal() { 
        // If the surface normal is already calculated, return it
        if(surfaceNormal)
            return surfaceNormal

        local intersectionPoint = this.hitpos

        // Calculate the normalized direction vector from startpos to hitpos
        local dir = (this.hitpos - this.startpos)
        dir.Norm()

        // Calculate offset vectors perpendicular to the trace direction
        local perpDir = Vector(-dir.y, dir.x, 0)
        local offset1 = perpDir
        local offset2 = dir.Cross(offset1)

        // Calculate new start positions for two additional traces
        local newStart1 = this.startpos + offset1
        local newStart2 = this.startpos + offset2

        // Perform two additional traces to find intersection points
        local intersectionPoint1
        local intersectionPoint2
        if(this.GetEntity()) { // TODO
            local normalSetting = {
                ignoreClass = ["*"],
                priorityClass = [this.GetEntity().GetClassname()],
                ErrorCoefficient = 3000,
            }
            intersectionPoint1 = this.Trace(newStart1, newStart1 + dir * 8000, this.ignoreEnt).hit
            intersectionPoint2 = this.Trace(newStart1, newStart2 + dir * 8000, this.ignoreEnt).hit
        }
        else {
            intersectionPoint1 = this.CheapTrace(newStart1, newStart1 + dir * 8000)
            intersectionPoint2 = this.CheapTrace(newStart2, newStart2 + dir * 8000)
        }

        // Calculate two edge vectors from intersection point to hitpos
        local edge1 = intersectionPoint1 - intersectionPoint;
        local edge2 = intersectionPoint2 - intersectionPoint;

        // Calculate the cross product of the two edges to find the normal vector
        local normal = edge2.Cross(edge1)
        normal.Norm()

        this.surfaceNormal = normal

        return this.surfaceNormal
    }



    /*
    * Perform the main trace.
    *
    * @param {Vector} startpos - Start position.
    * @param {Vector} endpos - End position.
    * @param {Entity} ignoreEnt - Entity to ignore.
    * @returns {object} Trace result.
    */
    function Trace(startpos, endpos, ignoreEnt) {
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
            // TODO!!!
            for (local ent;ent = Entities.FindByClassnameWithin(ent, "*", rayPart, 5 * dist_coeff);) {
                if (ent && _hitEntity(ent, ignoreEnt)) {
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
    function _isPriorityEntity(entityClass) {
        return settings.GetPriorityClass().find(entityClass) // todo!
    }

    /* 
    * Check if entity is an ignored class.
    *
    * @param {string} entityClass - Entity class name.
    * @returns {boolean} True if ignored.
    */
    function _isIgnoredEntity(entityClass) {
        return settings.GetIgnoreClass().find(entityClass)
    }

    /*
    * Check if entity should be ignored.
    *
    * @param {Entity} ent - Entity to check.
    * @param {Entity|array} ignoreEnt - Entities being ignored. 
    * @returns {boolean} True if should ignore.
    */
    function _hitEntity(ent, ignoreEnt, note) {
        local classname = ent.GetClassname()

        // todo
        if(settings.RunUserFilter(ent, note))
            return true

        // todo
        // if(settings.RunUserFilter2(ent, note))
        //     return false

        if (typeof ignoreEnt == "array" || typeof ignoreEnt == "arrayLib") { // todo
            foreach (mask in ignoreEnt) {
                if(typeof mask == "pcapEntity")
                    mask = mask.CBaseEntity
                if (mask == ent) {
                    return false;
                }
            }
        } 
        else if (ent == ignoreEnt) {
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

    // Calculate the distance between two points // todo
    function _GetDist(start, end) {
        return (start - end).Length()
    }

    function CheapTrace(startpos,endpos) {
        return startpos + (endpos - startpos) * (TraceLine(startpos, endpos, null))
    }


    // Convert the bboxcast object to string representation
    function _tostring() {
        return "Bboxcast 2.0 | \nstartpos: " + startpos + ", \nendpos: " + endpos + ", \nhitpos: " + hitpos + ", \nent: " + hitent + "\n========================================================="
    }
}

// PRESETS

/*
* Perform trace from player's eyes.
*
* @param {float} distance - Trace distance.
* @param {Entity} ignoreEnt - Entity to ignore.  
* @param {object} settings - Trace settings.
* @param {Entity} player - Player entity.
* @returns {bboxcast} Resulting trace. 
*/
function bboxcast::TracePlayerEyes(distance, ignoreEnt = null, settings = ::defaultSettings, player = null) {
    // Get the player's eye position and forward direction
    if(player == null) 
        player = GetPlayerEx()
    if(!player) 
        return bboxcast(Vector(), Vector())
    if(typeof player != "pcapEntity") 
        player = entLib.FromEntity(player)
    
    local eyePointEntity = player.GetUserData("Eye")
    local eyePosition = eyePointEntity.GetOrigin()
    local eyeDirection = eyePointEntity.GetForwardVector()

    // Calculate the start and end positions of the trace
    local startpos = eyePosition
    local endpos = eyePosition + eyeDirection * distance

    // Check if any entities should be ignored during the trace
    if (ignoreEnt) {
        // If ignoreEnt is an array, append the player entity to it
        if (type(ignoreEnt) == "array" || typeof ignoreEnt == "arrayLib") {
            ignoreEnt.append(player)
        }
        // If ignoreEnt is a single entity, create a new array with both the player and ignoreEnt
        else {
            ignoreEnt = [player, ignoreEnt]
        }
    }
    // If no ignoreEnt is provided, ignore the player only
    else {
        ignoreEnt = player
    }

    // Perform the bboxcast trace and return the trace result
    return bboxcast(startpos, endpos, ignoreEnt, settings)
}



/*
* Store disabled entities' bounding boxes.
*/   
__disabled_entity <- {}

/*
* Disable entity by setting size to 0. 
*
* @param {Entity} ent - Entity to disable.
*/
function CorrectDisable(ent = null) : (__disabled_entity) {
    if(!ent)
        ent = caller
    if(typeof ent == "string")
        ent = Entities.FindByName(null, ent)

    EntFireByHandle(ent, "Disable", "", 0, null, null)
    local entIndex = ent.entindex.tostring()
    if( !(entIndex in __disabled_entity)) {
        __disabled_entity[entIndex] <- {min = ent.GetBoundingMins(), max = ent.GetBoundingMaxs()}
    }
    ent.SetSize(Vector(), Vector())
}


/*
* Enable previously disabled entity.
*  
* @param {Entity} ent - Entity to enable. 
*/
function CorrectEnable(ent = null) : (__disabled_entity) {
    if(!ent)
        ent = caller
    if(typeof ent == "string")
        ent = Entities.FindByName(null, ent)

    EntFireByHandle(ent, "Enable", "", 0, null, null)
    local entIndex = ent.entindex.tostring()
    if( entIndex in __disabled_entity ) {
        local BBox = __disabled_entity[entIndex]
        ent.SetSize(BBox.min, BBox.max)
    }
}


for(local player; player = entLib.FindByClassname("player", player);) {
    if(player.GetUserData("Eye")) return

    eyeControlEntity <- Entities.CreateByClassname( "logic_measure_movement" )
    local controlName = "eyeControl" + UniqueString()
    eyeControlEntity.__KeyValueFromString("targetname", controlName)
    eyeControlEntity.__KeyValueFromInt("measuretype", 1)

    eyePointEntity <- Entities.CreateByClassname( "info_target" )
    local eyeName = "eyePoint" + UniqueString()
    eyePointEntity.__KeyValueFromString("targetname", eyeName)

    local playerName = player.GetName() == "" ? "!player" : player.GetName()

    EntFireByHandle(eyeControlEntity, "setmeasuretarget", playerName, 0, null, null)
    EntFireByHandle(eyeControlEntity, "setmeasurereference", controlName, 0, null, null);
    EntFireByHandle(eyeControlEntity, "SetTargetReference", controlName, 0, null, null);
    EntFireByHandle(eyeControlEntity, "Settarget", eyeName, 0, null, null);
    EntFireByHandle(eyeControlEntity, "Enable", "", 0, null, null)

    player.SetUserData("Eye", eyePointEntity)
}
