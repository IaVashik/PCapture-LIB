::TraceResult <- class {
    traceHandler = null;
    hitpos = null;

    surfaceNormal = null;

    constructor(traceHandler, hitpos) {
        this.traceHandler = traceHandler
        this.hitpos = hitpos
    }

    function GetStartPos() {
        return this.traceHandler.startpos
    }

    function GetEndPos() {
        return this.traceHandler.endpos
    }

    function GetHitpos() {
        return this.hitpos
    }

    function DidHit() {
        return this.traceHandler.fraction != 1
    }

    function GetDir() {
        return (this.GetEndPos() - this.GetStartPos())
    }

    function GetImpactNormal() {
        // If the surface normal is already calculated, return it
        if(this.surfaceNormal)
            return this.surfaceNormal
        
        this.surfaceNormal = CalculateImpactNormal(this.GetStartPos(), this.hitpos)
        return this.surfaceNormal 
    } 

    function _typeof() return "TraceResult"
}



// Don't forget, the class extension is broken in VScripts
// Valvo's, I hate u :<
::BboxTraceResult <- class {
    traceHandler = null;
    hitpos = null;
    hitent = null;

    surfaceNormal = null;

    constructor(traceHandler, hitpos, hitent) {
        this.traceHandler = traceHandler
        this.hitpos = hitpos
        this.hitent = hitent
    }

    function GetStartPos() {
        return this.traceHandler.startpos
    }

    function GetEndPos() {
        return this.traceHandler.endpos
    }

    function GetHitpos() {
        return this.hitpos
    }

    function GetEntity() {
        return entLib.FromEntity(this.hitent)
    }

    function GetIngoreEntities() {
        return this.traceHandler.ignoreEnts
    }

    function DidHit() {
        return this.GetFraction() != 1
    }

    function DidHitWorld() {
        return !this.hitent && DidHit()
    }

    function GetFraction() {
        return GetDist(this.GetStartPos(), this.GetHitpos()) / GetDist(this.GetStartPos(), this.GetEndPos())
    }

    function GetDir() {
        return (this.GetEndPos() - this.GetStartPos())
    }

    // todo
    function GetImpactNormal() {
        // If the surface normal is already calculated, return it
        if(this.surfaceNormal)
            return this.surfaceNormal
        
        local withEntity = null
        if(this.hitent) 
            withEntity = this.GetIngoreEntities()

        this.surfaceNormal = CalculateImpactNormal(this.GetStartPos(), this.hitpos, withEntity)
        return this.surfaceNormal
    } 

    function _typeof() return "TraceResult"
} 