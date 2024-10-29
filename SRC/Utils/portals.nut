/*
 * Creates a `func_portal_detector` entity with specified key-value pairs and settings for portal detection.
 * 
 * This function is not part of the public API.
*/
::_CreatePortalDetector <- function(extraKey, extraValue) {
    local detector = entLib.CreateByClassname("func_portal_detector", {solid = 3, CollisionGroup = 10})
    detector.SetKeyValue(extraKey, extraValue)
    detector.SetBBox(Vector(32000, 32000, 32000) * -1, Vector(32000, 32000, 32000))
    detector.SetTraceIgnore(true)
    EntFireByHandle(detector, "Enable")
    
    return detector
}

/*
 * Initializes a portal pair for portal casting (tracing lines through portals). 
 * 
 * This function creates a detector entity with a specific `LinkageGroupID` and connects its `OnStartTouchPortal`
 *  to a script function that sets the activator entity's health to the portal's `LinkageGroupID`. 
 * This allows for identifying the paired portal during portal traces. 
 * 
 * @param {number} id - The ID of the portal pair.
*/
::InitPortalPair <- function(id) {
    local detector = _CreatePortalDetector("LinkageGroupID", id)

    // The "free variables" syntax is different in Sq2 and Sq3, which is why I try to avoid executing it
    detector.ConnectOutputEx("OnStartTouchPortal", compilestring("activator.SetHealth(" + id + ")"))
}

/*
 * Initializes linked portal doors for portal tracing.
 * This function is not part of the public API.
 * 
 * This function iterates through all entities of class "linked_portal_door" and performs the following actions:
 * 1. Check if this entity has been processed before. 
 * 2. Extracts bounding box dimensions from the portal's model name (assuming a specific naming convention).
 * 3. Rotates the bounding box dimensions based on the portal's angles. 
 * 4. Sets the bounding box of the portal using the calculated dimensions. 
 * 
 * This function is called automatically at the initialization.
*/
::SetupLinkedPortals <- function() {
    // Iterate through all linked_portal_door entities.  
    for(local portal; portal = entLib.FindByClassname("linked_portal_door", portal);) {
        // Skip if the portal already processed
        if(portal.GetUserData("processed"))
            continue
    
        portal.SetInputHook("Open", function() {entLib.FromEntity(self).SetTraceIgnore(false)})
        portal.SetInputHook("Close", function() {entLib.FromEntity(self).SetTraceIgnore(true)})

        local partner = portal.GetPartnerInstance()
    
        // Skip if the portal model name is empty (no bounding box information available).  
        if(portal.GetModelName() == "") 
            continue
        
        // Extract bounding box dimensions from the model name (assuming a specific format). 
        local wpInfo = split(portal.GetModelName(), " ")
        // Rotate the bounding box dimensions based on the portal's angles.  
        local wpBBox = math.vector.rotate(Vector(5, wpInfo[0].tointeger(), wpInfo[1].tointeger()), portal.GetAngles()) 
        wpBBox = math.vector.abs(wpBBox) 
        // Set the bounding box of the portal using the calculated dimensions.  
        portal.SetBBox(wpBBox * -1, wpBBox)
        portal.SetUserData("processed", true)
    }
}

/*
 * Finds the partner portal for a given `prop_portal` entity.
 * 
 * @param {pcapEntity} portal - The `prop_portal` entity to find the partner for. 
 * @returns {pcapEntity|null} - The partner portal entity, or `null` if no partner is found. 
*/
::FindPartnerForPropPortal <- function(portal) {
    // Determine the model name of the partner portal based on the current portal's model. 
    local mdl = "models/portals/portal1.mdl"
    if(portal.GetModelName().find("portal2") == null)
        mdl = "models/portals/portal2.mdl"
    
    // Find the partner portal entity based on the determined model name.  
    local portalPairId = portal.GetHealth()
    for(local partner; partner = entLib.FindByModel(mdl, partner);) { 
        local partnerPairId = partner.GetHealth() 
        if(portalPairId != partnerPairId || partner.GetUserData("TracePlusIgnore"))
            continue
        
        return partner 
    }

    return null
}

/*
 * Checks if the given entity is a blue portal.
 *
 * @param {pcapEntity} ent - The entity to check.
 * @returns {boolean} - True if the entity is a blue portal, false otherwise.
*/
::IsBluePortal <- function(ent) { 
    return ent.GetModelName().find("portal2") == null
}