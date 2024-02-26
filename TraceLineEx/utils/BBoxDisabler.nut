/*
* Disable entity by setting size to 0. 
*
* @param {Entity} ent - Entity to disable.
*/
function CorrectDisable(ent = null) {
    if(ent == null)
        ent = caller
    if(typeof ent != "pcapEntity")
        ent = entLib.FromEntity(ent)

    EntFireByHandle(ent, "Disable")
    ent.SetUserData("bboxInfo", ent.GetBBox())
    ent.SetBBox(Vector(), Vector())
}


/*
* Enable previously disabled entity.
*  
* @param {Entity} ent - Entity to enable. 
*/
function CorrectEnable(ent = null) {
    if(ent == null)
        ent = caller
    if(typeof ent != "pcapEntity")
        ent = entLib.FromEntity(ent)

    EntFireByHandle(ent, "Enable")
    local bbox = ent.GetUserData("bboxInfo")
    ent.SetBBox(bbox.min, bbox.max)
}