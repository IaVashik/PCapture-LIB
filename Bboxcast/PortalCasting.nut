/*
* Traceline through portals.
*
* @param {Vector} startpos - Start position.
* @param {Vector} endpos - End position.
* @param {Entity} ignoreEnts - Entity to ignore.
* @returns {object} Trace result.
*/
function bboxcast::tryTeleportTrace(startpos, endpos, ignoreEnts) {
    for (local i = 0; i < 10; i++) { // todo?
        local tracedata = Trace(startpos, endpos, ignoreEnts);
        local hitPos = tracedata.hit
        local hitEnt = tracedata.ent
        
        local partner = hitEnt.GetUserData("partner")

        if (partner == null) 
            return tracedata

        // PortalFound.append(tracedata)

        local ray = _applyPortal(startPos, hitPos, portal, partner);
        startpos = ray.startPos
        endpos = ray.endPos
    }

    return Trace(startpos, endpos, ignoreEnts);
}

function bboxcast::_applyPortal(startPos, hitPos, portal, partner) {
    local portalAngles = portal.GetAngles();
    local partnerAngles = partner.GetAngles();
    local offset = math.unrotateVector(hitPos - portal.GetOrigin(), portalAngles);
    local dir = math.unrotateVector(hitPos - startPos, portalAngles);

    if (offset.x > -1) {
        offset += dir.resize(offset.x + 1);
    }

    offset *= Vector(-1, -1, 1)
    dir *= Vector(-1, -1, 1)

    return {
        startPos = partner.GetOrigin() + math.rotateVector(offset, partnerAngles),
        endPos = partner.GetOrigin() + math.rotateVector(offset, partnerAngles) + math.rotateVector(dir, partnerAngles) * 4096
    }
}


for(local portal; portal = entLib.FindByClassname("linked_portal_door", portal);) {
    local partner = entLib.FromEntity(portal.GetPartnerInstance())
    portal.SetUserData("partner", partner)
}

for(local portal; portal = entLib.FindByClassname("prop_portal", portal);) { // todo
    local mdl = "models/portals/portal1.mdl"
    if(portal.GetModelName().find("portal1") == null) 
        mdl = "models/portals/portal2.mdl"

    local partner = entLib.FindByModel(mdl)
    portal.SetUserData("partner", partner) 
}