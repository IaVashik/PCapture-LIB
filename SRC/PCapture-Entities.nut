/*+--------------------------------------------------------------------------------+
|                           PCapture Vscripts Library                               |
 +---------------------------------------------------------------------------------+
| Author:                                                                           |
|     One-of-a-Kind - laVashik :D                                                   |
 +---------------------------------------------------------------------------------+
| PCapture-entities.nut                                                             |
|       Improved Entities Module. Contains A VERY LARGE number                      |
|       of different functions that you just missed later!                          |
+----------------------------------------------------------------------------------+ */

if("entLib" in getroottable()) {
    dev.warning("entLib module initialization skipped. Module already initialized.")
    return
}

::pcapEntityCache <- {}

::entLib <- class {
    /* Creates an entity of the specified classname with the provided keyvalues.
    *
    * @param {string} classname - The classname of the entity.
    * @param {table} keyvalues - The key-value pairs for the entity.
    * @returns {pcapEntity} - The created entity object.
    */
    function CreateByClassname(classname, keyvalues = {}) {
        local new_entity = entLib.FromEntity(Entities.CreateByClassname(classname))
        foreach(key, value in keyvalues) {
            new_entity.SetKeyValue(key, value)
        }
        pcapEntityCache[CBaseEntity] <- new_entity
        return new_entity
    }

    function CreateProp(classname, origin, modelname, activity = 1, keyvalues = {}) {
        local new_entity = entLib.FromEntity(CreateProp(classname, origin, modelname, activity))
        foreach(key, value in keyvalues) {
            new_entity.SetKeyValue(key, value)
        }
        return new_entity
    }



    /* Finds an entity with the specified classname.
    *
    * @param {string} classname - The classname to search for.
    * @param {CBaseEntity} start_ent - The starting entity to search within.
    * @returns {pcapEntity} - The found entity object.
    */
    function FindByClassname(classname, start_ent = null) {
        if(start_ent && typeof start_ent == "pcapEntity")
            start_ent = start_ent.CBaseEntity
        local new_entity = Entities.FindByClassname(start_ent, classname)
        return entLib.__init(new_entity)
    }


    /* Finds an entity with the specified classname within a given radius from the origin.
    *
    * @param {string} classname - The classname to search for.
    * @param {Vector} origin - The origin position.
    * @param {int} radius - The search radius.
    * @param {CBaseEntity} start_ent - The starting entity to search within.
    * @returns {pcapEntity} - The found entity object.
    */
    function FindByClassnameWithin(classname, origin, radius, start_ent = null) {
        if(start_ent && typeof start_ent == "pcapEntity")
            start_ent = start_ent.CBaseEntity
        local new_entity = Entities.FindByClassnameWithin(start_ent, classname, origin, radius)
        return entLib.__init(new_entity)
    }


    /* Finds an entity with the specified targetname within the given starting entity.
    *
    * @param {string} targetname - The targetname to search for.
    * @param {CBaseEntity} start_ent - The starting entity to search within.
    * @returns {pcapEntity} - The found entity object.
    */
    function FindByName(targetname, start_ent = null) {
        if(start_ent && typeof start_ent == "pcapEntity")
            start_ent = start_ent.CBaseEntity
        local new_entity = Entities.FindByName(start_ent, targetname)
        return entLib.__init(new_entity)
    }


    /* Finds an entity with the specified targetname within a given radius from the origin.
    *
    * @param {string} targetname - The targetname to search for.
    * @param {Vector} origin - The origin position.
    * @param {int} radius - The search radius.
    * @param {CBaseEntity} start_ent - The starting entity to search within.
    * @returns {pcapEntity} - The found entity object.
    */
    function FindByNameWithin(targetname, origin, radius, start_ent = null) {
        if(start_ent && typeof start_ent == "pcapEntity")
            start_ent = start_ent.CBaseEntity
        local new_entity = Entities.FindByNameWithin(start_ent, targetname, origin, radius)
        return entLib.__init(new_entity)
    }


    /* Finds an entity with the specified model within the given starting entity.
    *
    * @param {string} model - The model to search for.
    * @param {CBaseEntity} start_ent - The starting entity to search within.
    * @returns {pcapEntity} - The found entity object.
    */
    function FindByModel(model, start_ent = null) {
        if(start_ent && typeof start_ent == "pcapEntity")
            start_ent = start_ent.CBaseEntity
        local new_entity = Entities.FindByModel(start_ent, model)
        return entLib.__init(new_entity)
    }


    /* Finds an entity with the specified model within a given radius from the origin.
    *
    * @param {string} model - The model to search for.
    * @param {Vector} origin - The origin position.
    * @param {int} radius - The search radius.
    * @param {CBaseEntity} start_ent - The starting entity to search within.
    * @returns {pcapEntity} - The found entity object.
    */
    function FindByModelWithin(model, origin, radius, start_ent = null) {
        if(start_ent && typeof start_ent == "pcapEntity")
            start_ent = start_ent.CBaseEntity
        local new_entity = null
        for(local ent; ent = Entities.FindByClassnameWithin(ent, "*", origin, radius);) {
            if(ent.GetModelName() == model && ent != start_ent) {
                new_entity = ent;
                break;
            }
        }

        return entLib.__init(new_entity)
    }


    /* Finds entities within a sphere defined by the origin and radius.
    *
    * @param {Vector} origin - The origin position of the sphere.
    * @param {int} radius - The radius of the sphere.
    * @param {CBaseEntity} start_ent - The starting entity to search within.
    * @returns {pcapEntity} - The found entity object.
    */
    function FindInSphere(origin, radius, start_ent = null) {
        if(start_ent && typeof start_ent == "pcapEntity")
            start_ent = start_ent.CBaseEntity
        local new_entity = Entities.FindInSphere(start_ent, origin, radius)
        return entLib.__init(new_entity)
    }


    function FromEntity(CBaseEntity) {
        if(typeof CBaseEntity == "pcapEntity")
            return CBaseEntity
        return entLib.__init(CBaseEntity)
    }

    /* Initializes an entity object.
    *
    * @param {CBaseEntity} entity - The entity object.
    * @param {string} type - The type of entity.
    * @returns {pcapEntity} - A new entity object.
    */
    function __init(CBaseEntity) {
        if(!CBaseEntity)
            return null

        if(CBaseEntity in pcapEntityCache) {
            return pcapEntityCache[CBaseEntity]
        } else {
            local pcapEnt = pcapEntity(CBaseEntity)
            pcapEntityCache[CBaseEntity] <- pcapEnt
            return pcapEnt
        }
    }
}


::pcapEntity <- class {
    CBaseEntity = null;
    EntityScope = null;

    /* Constructor for the entity object.
    *
    * @param {CBaseEntity} entity - The entity object.
    */
    constructor(entity = null) { 
        if(entity == null) return null

        if(typeof entity == "pcapEntity")
            entity = entity.CBaseEntity

        this.CBaseEntity = entity
        this.EntityScope = {}
        entity.ValidateScriptScope() // todo we need this shit?
    }


    function SetAngles(x, y, z) {
        x = x >= 360 ? 0 : x
        y = y >= 360 ? 0 : y
        z = z >= 360 ? 0 : z
        this.CBaseEntity.SetAngles(x, y, z)
    }

    /* Sets the angles of the entity.
    *
    * @param {Vector} vector - The angle vector.
    */
    function SetAbsAngles(vector) {
        this.CBaseEntity.SetAngles(vector.x, vector.y, vector.z)
    }


    /* Destroys the entity. */
    function Destroy() {
        this.CBaseEntity.Destroy()
        this.CBaseEntity = null
    }


    /* Kills the entity.
    *
    * @param {int|float} fireDelay - Delay in seconds before applying.
    */
    function Kill(fireDelay = 0) {
        EntFireByHandle(CBaseEntity, "kill", "", fireDelay)
        this.CBaseEntity = null // todo bug
    }


    function Dissolve() {
        if(this.GetName() == "")
            this.SetName(UniqueString("targetname"))
        dissolver.SetKeyValue("target", this.GetName())
        EntFireByHandle(dissolver, "dissolve")

        this.SetUserData("Dissolved", true)
    }


    /* Checks if the entity is valid.
    *
    * @returns {bool} - True if the entity is valid, false otherwise.
    */
    function IsValid() {
        return this.CBaseEntity && this.CBaseEntity.IsValid() && !this.GetUserData("Dissolved")
    }


    /* Checks if this entity is the player entity.
    * 
    * @returns {bool} - True if this entity is the player, false otherwise.
    */
    function IsPlayer() {
        return this.CBaseEntity.GetClassname() == "player"  // todo
    }


    function EyePosition() {
        if(this.IsPlayer()) return this.CBaseEntity.EyePosition()
    }

    function EyeAngles() {
        if(this.IsPlayer()) return this.GetUserData("Eye").GetAngles()
    }

    function EyeForwardVector() {
        if(this.IsPlayer()) return this.GetUserData("Eye").GetForwardVector()
    }


    /* Sets the key-value pair of the entity.  
    *
    * @param {string} key - The key of the key-value pair.
    * @param {int|float|Vector|string} value - The value of the key-value pair.
    */
    function SetKeyValue(key, value) {
        switch (typeof value) {
            case "integer":
                this.CBaseEntity.__KeyValueFromInt(key, value);
                break;
            case "float":
                this.CBaseEntity.__KeyValueFromFloat(key, value);
                break;
            case "Vector":
                this.CBaseEntity.__KeyValueFromVector(key, value);
                break;
            default:
                this.CBaseEntity.__KeyValueFromString(key, value.tostring());
        }

        this.SetUserData(key, value)
    }


    /* Sets the outputs of the entity.  (TODO improve description)
    *
    * @param {string} outputName - Output named
    * @param {string|CBaseEntity|pcapEntity} target - Targets entities named
    * @param {string} input - Via this input
    * @param {string} param - with a parameter ovveride of
    * @param {int|float} delay - Delay in seconds before applying. // todo
    * @param {int} fires - 
    */
    function addOutput(outputName, target, input, param = "", delay = 0, fires = -1) {
        if(typeof target == "instance" || typeof target == "pcapEntity")
            target = target.GetName()
        this.SetKeyValue(outputName, target + "\x001B" + input + "\x001B" + param + "\x001B" + delay + "\x001B" + fires)
    }

    /* TODO
    *
    * @param {string} outputName - Output named
    * @param {string} script - 
    * @param {int|float} delay - Delay in seconds before applying. // todo
    * @param {int} fires - 
    */
    function ConnectOutputEx(outputName, script, delay = 0, fires = -1) {
        if(typeof script == "function") {
            local funcName = "OutputFunc" + UniqueString()
            getroottable()[funcName] <- script
            script = funcName + "()"
        } 

        this.addOutput(outputName, self, "RunScriptCode", script, delay, fires)
    }


    function EmitSoundEx(sound_name, timeDelay = 0, eventName = this) {
        if(timeDelay == 0)
            return this.CBaseEntity.EmitSound(sound_name)
        CreateScheduleEvent(eventName, function():(CBaseEntity, sound_name) {
            CBaseEntity.EmitSound(sound_name)
        }, timeDelay)
    }


    /* Sets the targetname of the entity.
    *
    * @param {string} name - The targetname to be set.
    */
    function SetName(name) {
        this.SetKeyValue("targetname", name)
    }

    /* Sets the Unique targetname of the entity.
    *
    * @param {string} prefix - The prefix to be set.
    */
    function SetUniqueName(prefix = "a") {
        this.SetKeyValue("targetname", prefix + UniqueString())
    }


    /* Sets the parent of the entity.
    *
    * @param {string|CBaseEntity|pcapEntity} parent - The parent entity object.
    * @param {int|float} fireDelay - Delay in seconds before applying.
    */
    function SetParent(parentEnt, fireDelay = 0) {
        this.SetUserData("parent", parentEnt)
        if(typeof parentEnt == "pcapEntity" || typeof parentEnt == "instance") {
            if(parentEnt.GetName() == "") {
                parentEnt.SetName(UniqueString("parent"))
            }
            parentEnt = parentEnt.GetName()
        }
        
        EntFireByHandle(this.CBaseEntity, "SetParent", parentEnt, fireDelay)
    }


    /* Sets the collision of the entity.
    *
    * @param {int} solid - The type of collision.
    * @param {int|float} fireDelay - Delay in seconds before applying.
    */
    function SetCollision(solid, fireDelay = 0) {
        EntFireByHandle(this.CBaseEntity, "SetSolidtype", solid.tostring(), fireDelay, null, null)
        this.SetUserData("Solidtype", solid)
    }


    /* Sets the collision group of the entity.
    *
    * @param {int} collisionGroup - The collision group.
    */
    function SetCollisionGroup(collisionGroup) {
        this.SetKeyValue("CollisionGroup", collisionGroup)
        this.SetUserData("CollisionGroup", collisionGroup)
    }
    

    /* Start playing animation
    *
    * @param {string} animationName - Animation name.
    * @param {int|float} fireDelay - Delay in seconds before applying.
    */
    function SetAnimation(animationName, fireDelay) {
        EntFireByHandle(this.CBaseEntity, "SetAnimation", animationName, fireDelay)
        this.SetUserData("animation", animationName)
    }


    /* Sets the alpha of the entity.
    *
    * @param {int} opacity - The alpha value.
    * @param {int|float} fireDelay - Delay in seconds before applying.
    * Note: Don't forgot for "rendermode" use 5
    */
    function SetAlpha(opacity, fireDelay = 0) {
        EntFireByHandle(this.CBaseEntity, "Alpha", opacity.tostring(), fireDelay, null, null)
        this.SetUserData("alpha", opacity)
    }


    /* Sets the color of the entity.
    *
    * @param {string|Vector} colorValue - The color value.
    * @param {int|float} fireDelay - Delay in seconds before applying.
    */
    function SetColor(colorValue, fireDelay = 0) {
        if(typeof colorValue == "Vector") 
            colorValue = colorValue.toString()
        EntFireByHandle(this.CBaseEntity, "Color", colorValue, fireDelay, null, null)
        this.SetUserData("color", colorValue)
    }


    /* Sets the skin of the entity.
    *
    * @param {int} skin - The skin number.
    * @param {int|float} fireDelay - Delay in seconds before applying.
    */
    function SetSkin(skin, fireDelay = 0) {
        EntFireByHandle(this.CBaseEntity, "skin", skin.tostring(), fireDelay, null, null)
        this.SetUserData("skin", skin)
    }


    /* Sets whether the entity should be drawn or not. 
    *
    * @param {bool} isEnabled - True to enable drawing, false to disable.
    * @param {int|float} fireDelay - Delay in seconds before applying.
    */
    function SetDrawEnabled(isEnabled, fireDelay = 0) {
        if(isEnabled) {
            EntFireByHandle(this.CBaseEntity, "EnableDraw", "", fireDelay)
        }
        else {
            EntFireByHandle(this.CBaseEntity, "DisableDraw", "", fireDelay)
        }
        
    }

    /* Sets the spawnflags for the entity.
    *
    * @param {int} flag - The spawnflags value to set.
    */
    function SetSpawnflags(flag) {
        this.SetKeyValue("CollisionGroup", flag)
        this.SetUserData("spawnflags", flag)
    }


    /* Sets the scale of the entity.
    *
    * @param {int} scaleValue - The scale value.
    * @param {int|float} fireDelay - Delay in seconds before applying.
    */
    function SetModelScale(scaleValue, fireDelay = 0) {
        EntFireByHandle(this.CBaseEntity, "addoutput", "ModelScale " + scaleValue, fireDelay, null, null)
        this.SetUserData("ModelScale", scaleValue)
    }


    /* Sets the center of the entity.
    *
    * @param {Vector} vector - The center vector.
    */
    function SetCenter(vector) {
        local offset = this.CBaseEntity.GetCenter() - this.CBaseEntity.GetOrigin()
        this.CBaseEntity.SetAbsOrigin( vector - offset )
    }

    /* Sets the bounding box of the entity.
    *
    * @param {Vector|string} min - The minimum bounds vector or a string representation of the vector.
    * @param {Vector|string} max - The maximum bounds vector or a string representation of the vector.
    */
    function SetBBox(minBounds, maxBounds) {
        // Please specify the data type of `min` and `max` to improve the documentation accuracy.
        if (type(minBounds) == "string") {
            minBounds = StrToVec(minBounds)
        }
        if (type(maxBounds) == "string") {
            maxBounds = StrToVec(maxBounds)
        }

        this.CBaseEntity.SetSize(minBounds, maxBounds)
    }


    function SetContext(name, value, fireDelay = 0) {
        EntFireByHandle(this.CBaseEntity, "AddContext", (name + ":" + value), fireDelay)
        this.SetUserData(name, value)
    }
    
    /* Stores an arbitrary value associated with the entity.
    *
    * @param {string} name - The name of the value.  
    * @param {any} value - The value to store.
    */
    function SetUserData(name, value) {
        this.EntityScope[name.tolower()] <- value
    }


    /* Gets a stored user data value.
    *
    * @param {string} name - The name of the value to get.
    * @returns {any} - The stored value, or null if not found.
    */ 
    function GetUserData(name) {
        name = name.tolower()
        if(name in this.EntityScope)
            return this.EntityScope[name]
        return null
    }


    /* Gets the bounding box of the entity.
    *
    * @returns {table} - The minimum bounds and maximum bounds of the entity.
    */
    function GetBBox() {
        local max = GetBoundingMaxs()
        local min = GetBoundingMins()
        return {min = min, max = max}
    }


    /* Returns the axis-aligned bounding box (AABB) of the entity.
    *
    * @returns {table} - The minimum bounds, maximum bounds, and center of the entity.
    */ 
    function GetAABB() {
        local max = CreateAABB(7)
        local min = CreateAABB(0)
        local center = CreateAABB( 4)
        return {min = min, center = center, max = max}
    }


    /* Gets the index of the entity.
     *
     * @returns {int} - The index of the entity.
    */
    function GetIndex() {
        return this.CBaseEntity.entindex()
    }


    /* Gets the value of the key-value pair of the entity 
    * Note: only works if you used the SetKeyValue function!
    *
    * @param {string} key - The key of the key-value pair.
    * @returns {any} - The value of the key-value pair.
    */
    function GetKeyValue(key) {
        local value = this.GetUserData(key)
        if(value != null)
            return value

        switch(key) {
            case "model":
                return this.GetModelName()
                break
            case "health":
                return this.GetHealth()
                break
            case "targetname":
                return this.GetName()
                break
        }

        return null
    }


    /* Gets the spawnflags for the entity.
    * Note: only works if you used the SetKeyValue function!
    *
    * @returns {int|null} - The spawnflags value.
    */ 
    function GetSpawnflags() {
        return this.GetUserData("spawnflags")
    }


    /* Gets the alpha/opacity value of the entity.
    * Note: only works if you used the SetKeyValue function!
    * 
    * @returns {int|null} - The alpha value.
    */
    function GetAlpha() {
        local alpha = this.GetUserData("alpha")
        return alpha != null ? alpha : 255
    }


    /* Gets the color value of the entity.
    * Note: only works if you used the SetKeyValue function!
    *
    * @returns {string|null} - The color value.
    */
    function GetColor() {
        local color = this.GetUserData("color")
        return color ? color : "255 255 255"
    }


    function GetSkin() {
        local skin = this.GetUserData("skin")
        return skin ? skin : 0
    }


    /* Gets the prefix of the entity name.
    *
    * @returns {string} - The prefix of the entity name.
    */
    function GetNamePrefix() {
        return GetPrefix(this.GetName())
    }


    /* Gets the postfix of the entity name.
    *
    * @returns {string} - The postfix of the entity name.
    */
    function GetNamePostfix() {
        return GetPostfix(this.GetName())
    }


    /* Converts the entity object to a string.
    *
    * @returns {string} - The string representation of the entity.
    */
    function _tostring() {
        return "pcapEntity: " + this.CBaseEntity + ""
    }


    /* Returns the type of the entity object.
    *
    * @returns {string} - The type of the entity object.
    */
    function _typeof() {
        return "pcapEntity"
    }


    /* Gets the oriented bounding box of the entity.
    *
    * @param {int} stat - 0 for min bounds, 7 for max bounds, 4 for center bounds. 
    * @returns {Vector} - The bounds vector.
    */
    function CreateAABB(stat) { 
        local angles = this.GetAngles()
        if(stat == 4) 
            angles = Vector(45, 45, 45)

        local all_vertex = {
            v = this.getBBoxPoints()
            x = []
            y = []
            z = []
        }

        foreach(v in all_vertex.v)
        {
            all_vertex.x.append(v.x)
            all_vertex.y.append(v.y)
            all_vertex.z.append(v.z)
        }
        all_vertex.x.sort()
        all_vertex.y.sort()
        all_vertex.z.sort()
        
        if(stat == 4)
            return ( Vector(all_vertex.x[7], all_vertex.y[7], all_vertex.z[7]) - Vector(all_vertex.x[0], all_vertex.y[0], all_vertex.z[0]) ) * 0.5
        return Vector(all_vertex.x[stat], all_vertex.y[stat], all_vertex.z[stat])
    }


    /* Gets the 8 vertices of the axis-aligned bounding box.
    *
    * @returns {Array<Vector>} - The 8 vertices of the bounding box.  
    */
    function getBBoxPoints() {
        local BBmax = this.GetBoundingMaxs();
        local BBmin = this.GetBoundingMins();
        local angles = this.GetAngles()
    
        return [
            _GetVertex(BBmin, BBmin, BBmin, angles), _GetVertex(BBmin, BBmin, BBmax, angles),
            _GetVertex(BBmin, BBmax, BBmin, angles), _GetVertex(BBmin, BBmax, BBmax, angles),
            _GetVertex(BBmax, BBmin, BBmin, angles), _GetVertex(BBmax, BBmin, BBmax, angles),
            _GetVertex(BBmax, BBmax, BBmin, angles), _GetVertex(BBmax, BBmax, BBmax, angles)
        ]
    }


    /* Gets one vertex of the bounding box based on x, y, z bounds.
    * 
    * @param {Vector} x - The x bounds.
    * @param {Vector} y - The y bounds.  
    * @param {Vector} z - The z bounds.
    * @param {Vector} ang - The angle vector.
    * @returns {Vector} - The vertex.
    */
    function _GetVertex(x, y, z, ang) {
        // return rotate(Vector(x.x, y.y, z.z), ang)
        return math.rotateVector(Vector(x.x, y.y, z.z), ang)
    }
}

function pcapEntity::ConnectOutput(output, funcName) this.CBaseEntity.ConnectOutput(output, funcName)
function pcapEntity::DisconnectOutput(output, funcName) this.CBaseEntity.DisconnectOutput(output, funcName)
function pcapEntity::EmitSound(sound_name) this.CBaseEntity.EmitSound(sound_name)
function pcapEntity::PrecacheSoundScript(sound_name) this.CBaseEntity.PrecacheSoundScript(sound_name)
function pcapEntity::IsSequenceFinished() return this.CBaseEntity.IsSequenceFinished()
function pcapEntity::SpawnEntity() this.CBaseEntity.SpawnEntity()

function pcapEntity::GetAngles() return this.CBaseEntity.GetAngles()
function pcapEntity::GetAngularVelocity() return this.CBaseEntity.GetAngularVelocity()
function pcapEntity::GetBoundingMaxs() return this.CBaseEntity.GetBoundingMaxs()
function pcapEntity::GetBoundingMins() return this.CBaseEntity.GetBoundingMins()
function pcapEntity::GetCenter() return this.CBaseEntity.GetCenter()
function pcapEntity::GetClassname() return this.CBaseEntity.GetClassname()
function pcapEntity::GetForwardVector() return this.CBaseEntity.GetForwardVector()
function pcapEntity::GetHealth() return this.CBaseEntity.GetHealth()
function pcapEntity::GetLeftVector() return this.CBaseEntity.GetLeftVector()
function pcapEntity::GetMaxHealth() return this.CBaseEntity.GetMaxHealth()
function pcapEntity::GetModelKeyValues() return this.CBaseEntity.GetModelKeyValues()
function pcapEntity::GetModelName() return this.CBaseEntity.GetModelName()
function pcapEntity::GetName() return this.CBaseEntity.GetName()
function pcapEntity::GetOrigin() return this.CBaseEntity.GetOrigin()
function pcapEntity::GetScriptId() return this.CBaseEntity.GetScriptId()
function pcapEntity::GetUpVector() return this.CBaseEntity.GetUpVector()
function pcapEntity::GetPartnername() return this.CBaseEntity.GetPartnername()
function pcapEntity::GetPartnerInstance() return this.CBaseEntity.GetPartnerInstance()
function pcapEntity::ValidateScriptScope() return this.CBaseEntity.ValidateScriptScope()
function pcapEntity::EyePosition() return this.CBaseEntity.EyePosition()

function pcapEntity::SetAbsOrigin(vector) this.CBaseEntity.SetAbsOrigin(vector)
function pcapEntity::SetForwardVector(vector) this.CBaseEntity.SetForwardVector(vector)
function pcapEntity::SetHealth(health) this.CBaseEntity.SetHealth(health)
function pcapEntity::SetMaxHealth(health) this.CBaseEntity.SetMaxHealth(health)
function pcapEntity::SetModel(model_name) this.CBaseEntity.SetModel(model_name)
function pcapEntity::SetOrigin(vector) this.CBaseEntity.SetOrigin(vector)


// add CBaseEnts check with pcapEntity