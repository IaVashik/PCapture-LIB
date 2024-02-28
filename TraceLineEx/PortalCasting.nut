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
        if(normal.Dot(portal.GetForwardVector()) < 0.8)
            return tracedata
        
        local partner = portal.GetUserData("partner")
        if (partner == null) {
            return tracedata
        }

        local ray = applyPortal(startPos, hitPos, portal, partner);
        startPos = ray.startPos + partner.GetForwardVector() // A small hack to keep tracing from getting stuck
        endPos = ray.endPos
        previousTracedata = tracedata
    }
    return previousTracedata
}


::PortalBboxCast <- function(startPos, endPos, ignoreEnts = null, settings = defaultSettings, note = null) : (applyPortal) {
    local previousTracedata
    // Portal castings
    for (local i = 0; i < 10; i++) { // todo?
        local tracedata = BboxCast(startPos, endPos, ignoreEnts, settings, note)
        tracedata.portalEntryInfo = previousTracedata

        local hitPos = tracedata.GetHitpos()
        local portal = tracedata.GetEntity()

        if(!portal || portal.GetClassname() != "linked_portal_door")
            portal = entLib.FindByClassnameWithin("prop_portal", hitPos, 1) // todo: i should optimize it...
        if(!portal)
            return tracedata
        
        local partner = portal.GetUserData("partner")
        if (partner == null) 
            return tracedata

        if(portal.GetClassname() == "prop_portal") {
            local normal = tracedata.GetImpactNormal()
            if(normal.Dot(portal.GetForwardVector()) < 0.8)
                return tracedata
        } else { // todo
            ignoreEnts = addInIgnoreList(ignoreEnts, partner)
        }

        local ray = applyPortal(startPos, hitPos, portal, partner);
        startPos = ray.startPos + partner.GetForwardVector() // A small hack to keep tracing from getting stuck
        endPos = ray.endPos
        previousTracedata = tracedata
    }
    return previousTracedata
}



// TODO comment
::FindPartnersForPortals <- function() {
    for(local portal; portal = entLib.FindByClassname("linked_portal_door", portal);) {
        if(portal.GetUserData("partner"))
            continue
    
        local partner = entLib.FromEntity(portal.GetPartnerInstance())
        portal.SetUserData("partner", partner)
    
        if(portal.GetModelName() == "")
            continue
        
        local wpInfo = split(portal.GetModelName(), " ")
        local wpBBox = math.rotateVector(Vector(5, wpInfo[0].tointeger(), wpInfo[1].tointeger()), portal.GetAngles())
        wpBBox.x = abs(wpBBox.x); // TODO добавить abs для векторов
        wpBBox.y = abs(wpBBox.y);
        wpBBox.z = abs(wpBBox.z);
        portal.SetBBox(wpBBox * -1, wpBBox) 
    }
    
    for(local portal; portal = entLib.FindByClassname("prop_portal", portal);) { // todo
        if(portal.GetUserData("partner"))
            continue
    
        local mdl = "models/portals/portal1.mdl"
        if(portal.GetModelName().find("portal2") == null) 
            mdl = "models/portals/portal2.mdl"
        
        local partner = entLib.FindByModel(mdl)
        portal.SetUserData("partner", partner) 
    }
}

FindPartnersForPortals() // tood?