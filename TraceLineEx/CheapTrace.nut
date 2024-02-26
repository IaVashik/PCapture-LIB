::CheapTrace <- class {
    startpos = null;
    endpos = null;
    fraction = null;
    hitpos = null;
    surfaceNormal = null;

    constructor(startpos, endpos) {
        this.startpos = startpos
        this.endpos = endpos

        this.fraction = TraceLine(startpos, endpos, null)
        this.hitpos = startpos + (endpos - startpos) * this.fraction
    }

    
    function GetStartPos() {
        return this.startpos
    }

    function GetEndPos() {
        return this.endpos
    }

    function GetHitpos() {
        return this.hitpos
    }

    function DidHit() {
        return this.fraction
    }

    function GetDir() {
        return this.endpos - this.startpos
    }

    function GetImpactNormal() {
        // If the surface normal is already calculated, return it
        if(this.surfaceNormal)
            return this.surfaceNormal
        
        this.surfaceNormal = CalculateImpactNormal(this.startpos, this.hitpos)
        return this.surfaceNormal 
    } 
}