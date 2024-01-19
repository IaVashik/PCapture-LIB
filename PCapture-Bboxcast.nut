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
    ignoreEnts = null;
    settings = null;

    hitpos = null;
    hitent = null;
    surfaceNormal = null;

    // PortalFound = [];

    /*
    * Constructor.
    *
    * @param {Vector} startpos - Start position.
    * @param {Vector} endpos - End position.
    * @param {CBaseEntity|pcapEntity|array|arrayLib} ignoreEnts - Entity to ignore. 
    * @param {object} settings - Trace settings.
    */
    constructor(startpos, endpos, ignoreEnts = null, settings = defaultSettings, note) {
        this.startpos = startpos;
        this.endpos = endpos;
        this.ignoreEnts = ignoreEnts
        this.settings = settings

        local result = settings.portalTracing ? this.portalTrace(startpos, endpos, ignoreEnts, note) : this.Trace(startpos, endpos, ignoreEnts, note)
        this.hitpos = result.hit
        this.hitent = result.ent
    }

    /*
    * Get the starting position.
    *
    * @returns {Vector} Start position.
    */
    function GetStartPos() {
        return this.startpos
    }

    /*
    * Get the ending position.
    * 
    * @returns {Vector} End position.
    */
    function GetEndPos() {
        return this.endpos
    }

     /*
    * Get the hit position.
    *
    * @returns {Vector} Hit position. 
    */
    function GetHitpos() {
        return this.hitpos
    }

    /*
    * Get the hit entity.
    *
    * @returns {pcapEntity} Hit entity. // todo docx 
    */
    function GetEntity() {
        return this.hitent
    }

    /*
    * Get entities to ignore.
    *
    * @returns {Entity|array} Ignored entities.
    */
    function GetIngoreEntities() {
        return this.ignoreEnts
    }

    /*
    * Check if the trace hit anything.
    *
    * @returns {boolean} True if hit.
    */
    function DidHit() {
        return this.GetFraction() != 1
    }

    /*
    * Check if the trace hit the world.
    *
    * @returns {boolean} True if hit world.
    */
    function DidHitWorld() {
        return !this.hitent && DidHit()
    }

    /*
    * Get the fraction of the path traversed.
    *
    * @returns {float} Path fraction.
    */
    function GetFraction() {
        return GetDist(this.startpos, this.hitpos) / GetDist(this.startpos, this.endpos)
    }

    // todo
    function GetImpactNormal() Vector 

    /*
    * Get the direction.
    *
    * @returns {Vector} Direction.
    */
    function GetDir() {
        return this.endpos - this.startpos
    }

    //TODO 

    function CheapTrace(startpos, endpos) Vector
    function Trace(startpos, endpos, ignoreEnts) table
    function _hitEntity(ent, ignoreEnts, note) bool
    function _isIgnoredEntity(entityClass) bool
    function _isPriorityEntity(entityClass) bool
    // Convert the bboxcast object to string representation
    function _tostring() {
        return "Bboxcast 2.0 | \nstartpos: " + startpos + ", \nendpos: " + endpos + ", \nhitpos: " + hitpos + ", \nent: " + hitent + "\n========================================================="
    }
}