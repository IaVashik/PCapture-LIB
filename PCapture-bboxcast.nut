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
::defaultSettings <- {  //  TODO make as a class
    ignoreClass = arrayLib.new("info_target", "viewmodel", "weapon_", "func_illusionary", "info_particle_system",
    "trigger_", "phys_", "env_sprite", "point_", "vgui_", "physicsclonearea", "env_beam", "func_breakable"),
    priorityClass = arrayLib.new("linked_portal_door"),
    customFilter = null,      // function(ent) {return false},
    ErrorCoefficient = 500,
    // enablePortalTracing = false 
}

/*
* A class for performing bbox-based ray tracing in Portal 2.
*/
class bboxcast {
    startpos = null;
    endpos = null;
    hitpos = null;
    hitent = null;
    surfaceNormal = null;
    ignoreEnt = null;
    traceSettings = null;
    PortalFound = [];

    /*
    * Constructor.
    *
    * @param {Vector} startpos - Start position.
    * @param {Vector} endpos - End position.
    * @param {CBaseEntity|array} ignoreEnt - Entity to ignore. 
    * @param {object} settings - Trace settings.
    */
    constructor(startpos, endpos, ignoreEnt = null, settings = ::defaultSettings) {
        this.startpos = startpos;
        this.endpos = endpos;
        this.ignoreEnt = ignoreEnt
        this.traceSettings = _checkSettings(settings)
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
        return _GetDist(startpos, hitpos) / _GetDist(startpos, endpos)
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
        local dir = (this.hitpos - this.startpos).normalize()

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
        // if(this.GetEntity()) {
        //     local normalSetting = {
        //         ignoreClass = ["*"],
        //         priorityClass = [this.GetEntity().GetClassname()],
        //         ErrorCoefficient = 3000,
        //     }
        //     intersectionPoint1 = bboxcast(newStart1, newStart1 + dir * 8000, this.ignoreEnt, normalSetting).GetHitpos()
        //     intersectionPoint2 = bboxcast(newStart2, newStart2 + dir * 8000, this.ignoreEnt, normalSetting).GetHitpos()
        // }
        // else {
            intersectionPoint1 = _TraceEnd(newStart1, newStart1 + dir * 8000)
            intersectionPoint2 = _TraceEnd(newStart2, newStart2 + dir * 8000)
        // }

        // Calculate two edge vectors from intersection point to hitpos
        local edge1 = intersectionPoint1 - intersectionPoint;
        local edge2 = intersectionPoint2 - intersectionPoint;

        // Calculate the cross product of the two edges to find the normal vector
        this.surfaceNormal = edge2.Cross(edge1).normalize()

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
        local hitpos = _TraceEnd(startpos, endpos)
        // Calculate the distance between start and hit positions
        local dist = hitpos - startpos
        // Calculate a distance coefficient for more precise tracing based on distance and error coefficient
        local dist_coeff = abs(dist.Length() / traceSettings.ErrorCoefficient) + 1
        // Calculate the number of steps based on distance and distance coefficient
        local step = dist.Length() / 14 / dist_coeff

        // Iterate through each step
        for (local i = 0.0; i < step; i++) {
            // Calculate the ray position for the current step
            local Ray_part = startpos + dist * (i / step)
            // Find the entity at the ray point
            for (local ent;ent = Entities.FindByClassnameWithin(ent, "*", Ray_part, 5 * dist_coeff);) {
                if (ent && _checkEntityIsIgnored(ent, ignoreEnt)) {
                    return {hit = Ray_part, ent = ent}
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
        return traceSettings.priorityClass.find(entityClass)
    }

    /* 
    * Check if entity is an ignored class.
    *
    * @param {string} entityClass - Entity class name.
    * @returns {boolean} True if ignored.
    */
    function _isIgnoredEntity(entityClass) {
        return traceSettings.ignoreClass.find(entityClass) && !_isPriorityEntity(entityClass)
    }

    /*
    * Check if entity should be ignored.
    *
    * @param {Entity} ent - Entity to check.
    * @param {Entity|array} ignoreEnt - Entities being ignored. 
    * @returns {boolean} True if should ignore.
    */
    function _checkEntityIsIgnored(ent, ignoreEnt) {

        if(typeof ignoreEnt == "PCapLib-Entities")
            ignoreEnt = ignoreEnt.CBaseEntity

        local classname = ent.GetClassname()

        if(traceSettings.customFilter && traceSettings.customFilter(ent))
            return false

        if (type(ignoreEnt) == "array") {
            foreach (mask in ignoreEnt) {
                if(typeof mask == "PCapLib-Entities")
                    mask = mask.CBaseEntity
                if (mask == ent) {
                    return false;
                }
            }
        } 
        else if (ent == ignoreEnt) {
            return false;
        }

        if (traceSettings.ignoreClass.find("*")) {
            if(!_isPriorityEntity(classname))
                return false
        }
        else {
            if (_isIgnoredEntity(classname)) {
                return false
            }
            else {
                local classType = split(classname, "_")[0] + "_"
                if(_isIgnoredEntity(classType))
                    return false
            }
        }


        return true
    }

    // Calculate the distance between two points
    function _GetDist(start, end) {
        return (start - end).Length()
    }

    // Internal function
    function _TraceEnd(startpos,endpos) {
        return startpos + (endpos - startpos) * (TraceLine(startpos, endpos, null))
    }

    function _checkSettings(inputSettings) {
        // Check if settings is already in the correct format
        if (inputSettings.len() == 5)
            return inputSettings
            
        // Check and assign default values if missing
        if (!("ignoreClass" in inputSettings)) {
            inputSettings["ignoreClass"] <- ::defaultSettings["ignoreClass"]
        }
        if (!("priorityClass" in inputSettings)) {
            inputSettings["priorityClass"] <- ::defaultSettings["priorityClass"]
        }   
        if (!("ErrorCoefficient" in inputSettings)) {
            inputSettings["ErrorCoefficient"] <- ::defaultSettings["ErrorCoefficient"]
        }
        if (!("customFilter" in inputSettings)) {
            inputSettings["customFilter"] <- ::defaultSettings["customFilter"]
        }
    
        // Convert arrays to tables
        if(typeof inputSettings["ignoreClass"] == "array")
            inputSettings["ignoreClass"] = arrayLib(inputSettings["ignoreClass"])
        if(typeof inputSettings["priorityClass"] == "array")
            inputSettings["priorityClass"] = arrayLib(inputSettings["priorityClass"]) 
    
        return inputSettings
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
function bboxcast::TracePlayerEyes(distance, ignoreEnt = null, settings = ::defaultSettings, player = null) { // TODO эксперементальная поддержка CO-OP!
    // Get the player's eye position and forward direction
    if(player == null) 
        player = entLib.FromEntity(GetPlayer())
    if(!player) return bboxcast(Vector(0, 0, 0), Vector(1, 1, 1))
    
    local eyePointEntity = player.GetUserData("Eye")
    local eyePosition = eyePointEntity.GetOrigin()
    local eyeDirection = eyePointEntity.GetForwardVector()

    // Calculate the start and end positions of the trace
    local startpos = eyePosition
    local endpos = eyePosition + eyeDirection * distance

    // Check if any entities should be ignored during the trace
    if (ignoreEnt) {
        // If ignoreEnt is an array, append the player entity to it
        if (type(ignoreEnt) == "array") {
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
disabled_entity <- {}

/*
* Disable entity by setting size to 0. 
*
* @param {Entity} ent - Entity to disable.
*/
function CorrectDisable(ent = null) {
    if(!ent)
        ent = caller
    if(typeof ent == "string")
        ent = Entities.FindByName(null, ent)

    EntFireByHandle(ent, "Disable", "", 0, null, null)
    local entIndex = ent.entindex.tostring()
    if( !(entIndex in disabled_entity)) {
        disabled_entity[entIndex] <- {min = ent.GetBoundingMins(), max = ent.GetBoundingMaxs()}
    }
    ent.SetSize(Vector(), Vector())
}


/*
* Enable previously disabled entity.
*  
* @param {Entity} ent - Entity to enable. 
*/
function CorrectEnable(ent = null) {
    if(!ent)
        ent = caller
    if(typeof ent == "string")
        ent = Entities.FindByName(null, ent)

    EntFireByHandle(ent, "Enable", "", 0, null, null)
    local entIndex = ent.entindex.tostring()
    if( entIndex in disabled_entity ) {
        local BBox = disabled_entity[entIndex]
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
