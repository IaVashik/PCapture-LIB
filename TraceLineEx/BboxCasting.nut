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
    constructor(startpos, endpos, ignoreEnts = null, settings = defaultSettings, note = null) {
        this.startpos = startpos;
        this.endpos = endpos;
        this.ignoreEnts = ignoreEnts
        this.settings = settings

        local result = TraceLineAnalyzer(this, settings, note)
        // settings.portalTracing ? this.portalTrace(startpos, endpos, ignoreEnts, note) : this.Trace(startpos, endpos, ignoreEnts, note)
        this.hitpos = result.GetHitpos()
        this.hitent = result.GetEntity()
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
        return entLib.FromEntity(this.hitent)
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
    function GetImpactNormal() {
        // If the surface normal is already calculated, return it
        if(this.surfaceNormal)
            return this.surfaceNormal
        
        local withEntity = null
        if(this.hitent) 
            withEntity = this.ignoreEnts

        this.surfaceNormal = CalculateImpactNormal(this.startpos, this.hitpos, withEntity)
        return this.surfaceNormal
    } 

    /*
    * Get the direction.
    *
    * @returns {Vector} Direction.
    */
    function GetDir() {
        return this.endpos - this.startpos
    }

    // Convert the bboxcast object to string representation
    function _tostring() {
        return "Bboxcast 2.0 | \nstartpos: " + startpos + ", \nendpos: " + endpos + ", \nhitpos: " + hitpos + ", \nent: " + hitent + "\n========================================================="
    }
}

IncludeScript("pcapture-lib/Bboxcast/Trace")
IncludeScript("pcapture-lib/Bboxcast/PortalCasting")
IncludeScript("pcapture-lib/Bboxcast/ImpactNormal")
IncludeScript("pcapture-lib/Bboxcast/Presets")
