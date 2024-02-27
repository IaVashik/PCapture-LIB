local applyPortal = function (startPos, hitPos, portal, partner) {
    local portalAngles = portal.GetAngles();
    local partnerAngles = partner.GetAngles();
    local offset = math.unrotateVector(hitPos - portal.GetOrigin(), portalAngles);
    local dir = math.unrotateVector(hitPos - startPos, portalAngles);

    offset = Vector(offset.x * -1, offset.y * -1, offset.z)
    dir = Vector(dir.x * -1, dir.y * -1, dir.z)

    dir = math.rotateVector(dir, partnerAngles)
    dir.Norm()

    local newStart = partner.GetOrigin() + math.rotateVector(offset, partnerAngles)
    return {
        startPos = newStart,
        endPos = newStart + dir * 4096
    }
}



::PortalTrace <- function(startPos, endPos) : (applyPortal) {
    local previousTracedata
    // Portal castings
    for (local i = 0; i < 10; i++) { // todo?
        local tracedata = CheapTrace(startPos, endPos)
        tracedata.portalEntryInfo = previousTracedata

        local hitPos = tracedata.GetHitpos()

        local portal = entLib.FindByClassnameWithin("prop_portal", hitPos, 1) // todo: i should optimize it...
        if(!portal)
            portal = entLib.FindByClassnameWithin("linked_portal_door", hitPos, 1)
        if(!portal)
            return tracedata

        local normal = tracedata.GetImpactNormal()
        if(normal.Dot(portal.GetForwardVector()) < 0.9)
            return tracedata
        
        local partner = portal.GetUserData("partner")

        if (partner == null) 
            return tracedata

        local ray = applyPortal(startPos, hitPos, portal, partner);
        startPos = ray.startPos + partner.GetForwardVector() // A small hack to keep tracing from getting stuck
        endPos = ray.endPos
        previousTracedata = tracedata
    }
    // 

    return previousTracedata
}


::PortalBboxCast <- function(startpos, endpos, ignoreEnts = null, settings = defaultSettings, note = null) : (applyPortal) {

}



// TODO comment
for(local portal; portal = entLib.FindByClassname("linked_portal_door", portal);) {
    local partner = entLib.FromEntity(portal.GetPartnerInstance())
    portal.SetUserData("partner", partner)
}

for(local portal; portal = entLib.FindByClassname("prop_portal", portal);) { // todo
    local mdl = "models/portals/portal1.mdl"
    if(portal.GetModelName().find("portal2") == null) 
        mdl = "models/portals/portal2.mdl"
    
    local partner = entLib.FindByModel(mdl)
    portal.SetUserData("partner", partner) 
}