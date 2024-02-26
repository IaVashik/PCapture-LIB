// /*
// * Traceline through portals.
// *
// * @param {Vector} startpos - Start position.
// * @param {Vector} endpos - End position.
// * @param {Entity} ignoreEnts - Entity to ignore.
// * @returns {object} Trace result.
// */
// function bboxcast::portalTrace(startPos, endPos, ignoreEnts, note) {
//     for (local i = 0; i < 10; i++) { // todo?
//         local tracedata = Trace(startPos, endPos, ignoreEnts, note);
//         local hitPos = tracedata.hit
//         local hitEnt = entLib.FromEntity(tracedata.ent)
        
//         if(hitEnt == null || (hitEnt.GetClassname() != "prop_portal" && hitEnt.GetClassname() != "linked_portal_door"))
//             return tracedata

//         local partner = hitEnt.GetUserData("partner")

//         if (partner == null) 
//             return tracedata

//         // PortalFound.append(tracedata)

//         local ray = _applyPortal(startPos, hitPos, hitEnt, partner);
//         startPos = ray.startPos
//         endPos = ray.endPos
//         ignoreEnts.append(partner) //! MEGA BRUH
//     }

//     return Trace(startpos, endpos, ignoreEnts);
// }

// function bboxcast::_applyPortal(startPos, hitPos, portal, partner) {
//     local portalAngles = portal.GetAngles();
//     local partnerAngles = partner.GetAngles();
//     local offset = math.unrotateVector(hitPos - portal.GetOrigin(), portalAngles);
//     local dir = math.unrotateVector(hitPos - startPos, portalAngles);

//     if (offset.x > -1) {
//         offset += math.resizeVector(dir, offset.x + 1)
//     }

//     // offset.Cross(Vector(-1, -1, 1))
//     // dir.Cross(Vector(-1, -1, 1))

//     offset.x *= -1;
//     offset.y *= -1;
//     dir.x *= -1;
//     dir.y *= -1;

//     dir = math.rotateVector(dir, partnerAngles)
//     dir.Norm()

//     return {
//         startPos = partner.GetOrigin() + math.rotateVector(offset, partnerAngles),
//         endPos = partner.GetOrigin() + math.rotateVector(offset, partnerAngles) + dir * 4096
//     }
// }


// for(local portal; portal = entLib.FindByClassname("linked_portal_door", portal);) {
//     local partner = entLib.FromEntity(portal.GetPartnerInstance())
//     portal.SetUserData("partner", partner)
// }

// for(local portal; portal = entLib.FindByClassname("prop_portal", portal);) { // todo
//     local mdl = "models/portals/portal1.mdl"
//     if(portal.GetModelName().find("portal2") == null) 
//         mdl = "models/portals/portal2.mdl"
    
//     local partner = entLib.FindByModel(mdl)
//     portal.SetUserData("partner", partner) 
// }


