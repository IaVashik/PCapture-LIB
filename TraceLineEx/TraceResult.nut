::TraceResult <- class {
    traceHandler = null;
    hitpos = null;

    surfaceNormal = null;
    portalEntryInfo = null;

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

    function GetFraction() {
        return this.traceHandler.fraction
    }

    function DidHit() {
        return this.traceHandler.fraction != 1
    }

    function GetDir() {
        return (this.GetEndPos() - this.GetStartPos())
    }

    function GetPortalEntryInfo() {
        return this.portalEntryInfo
    }

    function GetAggregatedPortalEntryInfo() {
        local arr = arrayLib([])
        arr.append(trace)
        for(local trace = this; trace = trace.portalEntryInfo;) {
            arr.append(trace)
        }
        return arr
    }

    function GetImpactNormal() {
        // If the surface normal is already calculated, return it
        if(this.surfaceNormal)
            return this.surfaceNormal
        
        this.surfaceNormal = CalculateImpactNormal(this.GetStartPos(), this.hitpos, this)
        return this.surfaceNormal 
    } 

    function _typeof() return "TraceResult"
    function _tostring() {
        return "TraceResult | startpos: " + GetStartPos() + ", endpos: " + GetEndPos() + ", fraction: " + GetFraction() + ", hitpos: " + GetHitpos()
    }
}



// Don't forget, the class extension is broken in VScripts
// Valvo's, I hate u :<
::BboxTraceResult <- class {
    traceHandler = null;
    hitpos = null;
    hitent = null;

    surfaceNormal = null;
    portalEntryInfo = null;

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
        if(this.hitent && this.hitent.IsValid())
            return entLib.FromEntity(this.hitent)
    }

    function GetEntityClassname() {
        return this.hitent ? this.GetEntity().GetClassname() : null 
    }

    function GetIngoreEntities() {
        return this.traceHandler.ignoreEnts
    }

    function GetTraceSettings() {
        return this.traceHandler.settings
    }

    function GetNote() {
        return this.traceHandler.note
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

    function GetPortalEntryInfo() {
        return this.portalEntryInfo
    }

    function GetAggregatedPortalEntryInfo() {
        local arr = arrayLib([])
        arr.append(this)
        for(local trace = this; trace = trace.portalEntryInfo;) {
            arr.append(trace)
        }
        return arr.reverse()
    }

    // todo
    function GetImpactNormal() {
        // If the surface normal is already calculated, return it
        if(this.surfaceNormal)
            return this.surfaceNormal

        this.surfaceNormal = CalculateImpactNormal(this.GetStartPos(), this.hitpos, this)
        return this.surfaceNormal
    } 

    function _typeof() return "BboxTraceResult"
    function _tostring() {
        return "TraceResult | startpos: " + GetStartPos() + ", endpos: " + GetEndPos() + ", hitpos: " + GetHitpos() + ", entity: " + GetEntity()
    }
} 