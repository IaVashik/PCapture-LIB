/*
 * Applies portal transformations to a trace, calculating a new start and end position for the trace after passing through the portal. 
 *
 * @param {Vector} startPos - The original start position of the trace. 
 * @param {Vector} hitPos - The hit position of the trace on the portal. 
 * @param {pcapEntity} portal - The portal entity. 
 * @param {pcapEntity} partnerPortal - The partner portal entity. 
 * @returns {table} - A table containing the new startPos and endPos for the trace after passing through the portal. 
*/ 
 local applyPortal = function(startPos, hitPos, portal, partnerPortal) {
    local portalAngles = portal.GetAngles();
    local partnerAngles = partnerPortal.GetAngles();
    local offset = math.vector.unrotate(hitPos - portal.GetOrigin(), portalAngles);
    local dir = math.vector.unrotate(hitPos - startPos, portalAngles);

    offset = Vector(offset.x * -1, offset.y * -1, offset.z)
    dir = Vector(dir.x * -1, dir.y * -1, dir.z)

    dir = math.vector.rotate(dir, partnerAngles)
    dir.Norm()

    local newStart = partnerPortal.GetOrigin() + math.vector.rotate(offset, partnerAngles)
    return {
        startPos = newStart,
        endPos = newStart + dir * 4096
    }
}


/*
 * Performs a cheap trace with portal support. 
 * 
 * @param {Vector} startPos - The start position of the trace.
 * @param {Vector} endPos - The end position of the trace.  
 * @returns {CheapTraceResult} - The trace result object, including information about portal entries.
*/
TracePlus["PortalCheap"] <- function(startPos, endPos) : (applyPortal) {
    local previousTraceData 
    // Portal castings
    for (local i = 0; i < MAX_PORTAL_CAST_DEPTH; i++) {
        local traceData = TracePlus.Cheap(startPos, endPos)
        traceData.portalEntryInfo = previousTraceData

        local hitPos = traceData.GetHitpos()

        // Find a nearby portal entity. 
        local portal = entLib.FindByClassnameWithin("prop_portal", hitPos, 1) 
        if(!portal)
            portal = entLib.FindByClassnameWithin("linked_portal_door", hitPos, 1)
        if(!portal)
            return traceData

        local normal = traceData.GetImpactNormal()
        if(normal.Dot(portal.GetForwardVector()) < 0.8)
            return traceData
        
        local partnerPortal = portal.GetPartnerInstance()
        if (partnerPortal == null) {
            return traceData 
        }

        // Calculate new start and end positions for the trace after passing through the portal. 
        local ray = applyPortal(startPos, hitPos, portal, partnerPortal);
        // Adjust the start position slightly to prevent the trace from getting stuck.  
        startPos = ray.startPos + partnerPortal.GetForwardVector() 
        endPos = ray.endPos
        previousTraceData = traceData
    }
    return previousTraceData
}

/*
 * Performs a cheap trace with portal support from the player's eyes. 
 *
 * @param {number} distance - The distance of the trace. 
 * @param {CBaseEntity|pcapEntity} player - The player entity.
 * @returns {CheapTraceResult} - The trace result object.
*/
 TracePlus["FromEyes"]["PortalCheap"] <- function(distance, player) {
    // Calculate the start and end positions of the trace
    local startpos = player.EyePosition()
    local endpos = macros.GetEyeEndpos(player, distance)

    return TracePlus.PortalCheap(startpos, endpos)
}


/*
 * Performs a bbox cast with portal support. 
 * 
 * @param {Vector} startPos - The start position of the trace.
 * @param {Vector} endPos - The end position of the trace.
 * @param {array|CBaseEntity|null} ignoreEntities - A list of entities or a single entity to ignore during the trace. (optional) 
 * @param {TraceSettings} settings - The settings to use for the trace. (optional, defaults to TracePlus.defaultSettings) 
 * @param {string|null} note - An optional note associated with the trace. 
 * @returns {BboxTraceResult} - The trace result object, including information about portal entries.
*/
TracePlus["PortalBbox"] <- function(startPos, endPos, ignoreEntities = null, settings = TracePlus.defaultSettings, note = null) : (applyPortal) {
    local previousTraceData 
    // Portal castings
    for (local i = 0; i < MAX_PORTAL_CAST_DEPTH; i++) {
        local traceData = TracePlus.Bbox(startPos, endPos, ignoreEntities, settings, note)
        traceData.portalEntryInfo = previousTraceData 

        local hitPos = traceData.GetHitpos()
        local portal = traceData.GetEntity()

        if(!portal || portal.GetClassname() != "linked_portal_door")
            portal = entLib.FindByClassnameWithin("prop_portal", hitPos, 1) // todo: i should optimize it...
        if(!portal) 
            return traceData 
        
        local partnerPortal = portal.GetPartnerInstance()
        if (partnerPortal == null) 
            return traceData 

        if(portal.GetClassname() == "prop_portal") {
            local normal = traceData.GetImpactNormal()
            if(normal.Dot(portal.GetForwardVector()) < 0.8)
                return traceData
        }
        
        ignoreEntities = TracePlus.Settings.UpdateIgnoreEntities(ignoreEntities, partnerPortal)

        // Calculate new start and end positions for the trace after passing through the portal.  
        local ray = applyPortal(startPos, hitPos, portal, partnerPortal);
        // Adjust the start position slightly to prevent the trace from getting stuck. 
        startPos = ray.startPos + partnerPortal.GetForwardVector() 
        endPos = ray.endPos
        previousTraceData = traceData 
    }
    return previousTraceData 
}

/* 
 * Performs a bbox cast with portal support from the player's eyes. 
 *
 * @param {number} distance - The distance of the trace. 
 * @param {CBaseEntity|pcapEntity} player - The player entity.
 * @param {array|CBaseEntity|null} ignoreEntities - A list of entities or a single entity to ignore during the trace. (optional)
 * @param {TraceSettings} settings - The settings to use for the trace. (optional, defaults to TracePlus.defaultSettings) 
 * @returns {BboxTraceResult} - The trace result object. 
*/
 TracePlus["FromEyes"]["PortalBbox"] <- function(distance, player, ignoreEntities = null, settings = TracePlus.defaultSettings) {
    // Calculate the start and end positions of the trace
    local startPos = player.EyePosition()
    local endPos = macros.GetEyeEndpos(player, distance)
    ignoreEntities = TracePlus.Settings.UpdateIgnoreEntities(ignoreEntities, player)

    // Perform the bboxcast trace and return the trace result
    return TracePlus.PortalBbox(startPos, endPos, ignoreEntities, settings)
}



/* 
 * Finds and sets partner portals for linked portal doors and prop portals. 
 * 
 * This function iterates through all entities of class "linked_portal_door" and "prop_portal" and attempts to find their corresponding partner portals. 
 * For linked portal doors, it retrieves the partner instance using GetPartnerInstance() and stores it as user data in both portals. 
 * For prop portals, it assumes the partner portal is the other prop_portal entity in the map and stores it as user data. 
 *
 * Additionally, for linked portal doors, the function extracts bounding box information from the model name (assuming a specific naming convention) 
 * and sets the bounding box of the portal accordingly. 
 * 
 * This function is called automatically at the initialization of the TracePlus module to ensure portal information is available for portal traces. 
 * 
*/
 ::FindPartnersForPortals <- function() {
    // Iterate through all linked_portal_door entities.  
    for(local portal; portal = entLib.FindByClassname("linked_portal_door", portal);) {
        // Skip if the portal already has a partner set. 
        if(portal.GetPartnerInstance())
            continue
    
        // Get the partner portal entity using GetPartnerInstance().  
        local partner = portal.GetPartnerInstance()
        // Store the partner portal as user data in both portals.  
        portal.SetUserData("partner", partner)
    
        // Skip if the portal model name is empty (no bounding box information available).  
        if(portal.GetModelName() == "")
            continue
        
        // Extract bounding box dimensions from the model name (assuming a specific format). 
        local wpInfo = split(portal.GetModelName(), " ")
        // Rotate the bounding box dimensions based on the portal's angles.  
        local wpBBox = math.vector.rotateVector(Vector(5, wpInfo[0].tointeger(), wpInfo[1].tointeger()), portal.GetAngles())
        wpBBox = math.vector.abs(wpBBox)
        // Set the bounding box of the portal using the calculated dimensions.  
        portal.SetBBox(wpBBox * -1, wpBBox) 
    }
    
    // Iterate through all prop_portal entities.  
    for(local portal; portal = entLib.FindByClassname("prop_portal", portal);) { 
        // Skip if the portal already has a partner set. 
        if(portal.GetPartnerInstance())
            continue
    
        // Determine the model name of the partner portal based on the current portal's model. 
        local mdl = "models/portals/portal1.mdl"
        if(portal.GetModelName().find("portal2") == null) 
            mdl = "models/portals/portal2.mdl"
        
        // Find the partner portal entity based on the determined model name.  
        local partner = entLib.FindByModel(mdl)
        // Store the partner portal as user data in the current portal.  
        portal.SetUserData("partner", partner) 
    }
}

FindPartnersForPortals()