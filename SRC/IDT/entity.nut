::pcapEntity <- class {
    CBaseEntity = null;
    EntityScope = null;

    /* 
     * Constructor for the entity object.
     *
     * @param {CBaseEntity} entity - The entity object.
    */
    constructor(entity = null) { 
        if(typeof entity == "pcapEntity")
            entity = entity.CBaseEntity

        this.CBaseEntity = entity
        this.EntityScope = {}
        entity.ValidateScriptScope()
    }


    function SetAngles(x, y, z) {
        x = x >= 360 ? 0 : x
        y = y >= 360 ? 0 : y
        z = z >= 360 ? 0 : z
        this.CBaseEntity.SetAngles(x, y, z)
    }

    /*
     * Sets the angles of the entity.
     *
     * @param {Vector} angles - The angle vector.
    */
    function SetAbsAngles(angles) {
        this.CBaseEntity.SetAngles(angles.x, angles.y, angles.z)
    }


    // Destroys the entity. 
    function Destroy() {
        this.CBaseEntity.Destroy()
        this.CBaseEntity = null
    }


    /*
     * Kills the entity.
     *
     * @param {number} fireDelay - Delay in seconds before applying.
    */
    function Kill(fireDelay = 0) {
        EntFireByHandle(CBaseEntity, "kill", "", fireDelay)
        this.CBaseEntity = null
    }


    /*
     * Dissolves the entity using an env_entity_dissolver entity, creating a visual effect of the entity dissolving away.
     *
     * This method utilizes an env_entity_dissolver entity to create the dissolve effect. If the entity doesn't have a targetname, 
     * a unique targetname is assigned to it before initiating the dissolve process. 
     */
    function Dissolve() {
        if(this.GetName() == "")
            this.SetUniqueName("targetname")
        dissolver.SetKeyValue("target", this.GetName())
        EntFireByHandle(dissolver, "dissolve")

        this.SetUserData("Dissolved", true)
    }


    /*
     * Checks if the entity is valid.
     *
     * @returns {bool} - True if the entity is valid, false otherwise.
    */
    function IsValid() {
        return this.CBaseEntity && this.CBaseEntity.IsValid() && !this.GetUserData("Dissolved")
    }


    /*
     * Checks if this entity is the player entity.
     * 
     * @returns {bool} - True if this entity is the player, false otherwise.
    */
    function IsPlayer() {
        return this.CBaseEntity.GetClassname() == "player"
    }

    /*
     * Gets the eye position of the player entity.
     *
     * @returns {Vector|null} - The eye position as a Vector, or null if the entity is not a player.
     * 
     * This method retrieves the position from which the player's view is rendered. It is important to note that this method only works with player entities.
     * For non-player entities, it returns null. 
    */
     function EyePosition() {
        if(this.IsPlayer()) return this.CBaseEntity.EyePosition()
    }

    /*
     * Gets the eye angles of the player entity. 
     *
     * @returns {Vector|null} - The eye angles as a Vector representing pitch, yaw, and roll, or null if the entity is not a player.
     *
     * This method retrieves the orientation of the player's view. It is important to note that this method only works with player entities.
     * For non-player entities, it returns null. 
    */
    function EyeAngles() {
        if(this.IsPlayer()) return this.GetUserData("Eye").GetAngles()
    }

    /* 
     * Gets the forward vector from the player entity's eye position, indicating the direction the player is looking. 
     *
     * @returns {Vector|null} - The forward vector as a Vector, or null if the entity is not a player.
     *
     * This method retrieves the direction in which the player is facing. It is important to note that this method only works with player entities.
     * For non-player entities, it returns null.
    */
    function EyeForwardVector() {
        if(this.IsPlayer()) return this.GetUserData("Eye").GetForwardVector()
    }


    /*
     * Sets the key-value pair of the entity.  
     *
     * @param {string} key - The key of the key-value pair.
     * @param {int|float|Vector|string} value - The value of the key-value pair.
    */
    function SetKeyValue(key, value) {
        this.SetUserData(key, value)

        switch (typeof value) {
            case "integer":
                return this.CBaseEntity.__KeyValueFromInt(key, value);
            case "float":
                return this.CBaseEntity.__KeyValueFromFloat(key, value);
            case "Vector":
                return this.CBaseEntity.__KeyValueFromVector(key, value);
            case "string":
                return this.CBaseEntity.__KeyValueFromString(key, value);
        }
        
        return this.CBaseEntity.__KeyValueFromString(key, value.tostring());
    }


        /*
     * Connects an output of the entity to a target entity and input, allowing for parameter overrides, delays, and limited trigger counts.
     *
     * @param {string} outputName - The name of the output to connect.
     * @param {string|CBaseEntity|pcapEntity} target - The target entity or its targetname to connect the output to.
     * @param {string} input - The name of the input on the target entity to connect to.
     * @param {string} param - An optional parameter override for the input. (default: "")
     * @param {number} delay - An optional delay in seconds before triggering the input. (default: 0) 
     * @param {number} fires - The number of times the output should fire before becoming inactive. -1 indicates unlimited fires. (default: -1) 
     * 
     * This method provides a way to establish connections between entities, allowing them to trigger actions on each other based on outputs and inputs. 
    */
     function addOutput(outputName, target, input, param = "", delay = 0, fires = -1) {
        if(typeof target == "instance" || typeof target == "pcapEntity")
            target = target.GetName()
        this.SetKeyValue(outputName, target + "\x001B" + input + "\x001B" + param + "\x001B" + delay + "\x001B" + fires)
    }

    /* 
     * Connects an output of the entity to a script function or string, allowing for delays and limited trigger counts. 
     * 
     * @param {string} outputName - The name of the output to connect.
     * @param {string|function} script - The VScripts code or function name to execute when the output is triggered.
     * @param {number} delay - An optional delay in seconds before executing the script. (default: 0) 
     * @param {number} fires - The number of times the output should fire before becoming inactive. -1 indicates unlimited fires. (default: -1) 
     * 
     * This method provides a way to connect entity outputs directly to script code, allowing for custom actions to be performed when the output is triggered.
    */
    function ConnectOutputEx(outputName, script, delay = 0, fires = -1) {
        if(typeof script == "function") {
            local funcName = UniqueString("OutputFunc")
            getroottable()[funcName] <- script
            script = funcName + "()"
        }

        this.addOutput(outputName, this, "RunScriptCode", script, delay, fires)
    }


    /* 
     * Emits a sound with optional delay.
     *
     * @param {string} soundName - The name of the sound to play.
     * @param {number} timeDelay - Delay in seconds before playing the sound. (optional)
     * @param {string} eventName - The name of the event used for scheduling. (optional)
    */
    function EmitSoundEx(soundName, timeDelay = 0, eventName = this) {
        if(timeDelay == 0)
            return this.CBaseEntity.EmitSound(soundName)
        ScheduleEvent.Add(eventName, function():(CBaseEntity, soundName) {
            CBaseEntity.EmitSound(soundName)
        }, timeDelay)
    }


    /*
     * Sets the targetname of the entity.
     *
     * @param {string} name - The targetname to be set.
    */
    function SetName(name) {
        this.SetKeyValue("targetname", name)
    }

    /*
     * Sets a unique targetname for the entity using the provided prefix.
     *
     * @param {string} prefix - The prefix to be used for the unique targetname. (optional, default="u")
    */
    function SetUniqueName(prefix = "u") {
        this.SetKeyValue("targetname", UniqueString(prefix))
    }


    /*
     * Sets the parent of the entity.
     *
     * @param {string|CBaseEntity|pcapEntity} parent - The parent entity object or its targetname.
     * @param {number} fireDelay - Delay in seconds before applying.
    */
    function SetParent(parentEnt, fireDelay = 0) {
        this.SetUserData("parent", parentEnt)
        if(typeof parentEnt != "string") {
            if(parentEnt.GetName() == "") {
                parentEnt.SetUniqueName("parent")
            }
            parentEnt = parentEnt.GetName()
        }
        
        EntFireByHandle(this.CBaseEntity, "SetParent", parentEnt, fireDelay)
    }

    /*
     * Gets the parent of the entity.
     *
     * @returns {pcapEntity|null} - The parent entity object or null if no parent is set.
    */
    function GetParent() {
        return this.GetUserData("parent")
    }


    /*
     * Sets the collision of the entity.
     *
     * @param {number} solidType - The type of collision.
     * @param {number} fireDelay - Delay in seconds before applying.
    */
    function SetCollision(solidType, fireDelay = 0) {
        EntFireByHandle(this.CBaseEntity, "SetSolidtype", solidType.tostring(), fireDelay, null, null)
        this.SetUserData("Solidtype", solidType)
    }


    /*
     * Sets the collision group of the entity.
     *
     * @param {number} collisionGroup - The collision group.
    */
    function SetCollisionGroup(collisionGroup) {
        this.SetKeyValue("CollisionGroup", collisionGroup)
        this.SetUserData("CollisionGroup", collisionGroup)
    }
    

    /* 
     * Starts playing the specified animation.
     *
     * @param {string} animationName - The name of the animation to play.
     * @param {number} fireDelay - Delay in seconds before starting the animation.
    */
    function SetAnimation(animationName, fireDelay) {
        EntFireByHandle(this.CBaseEntity, "SetAnimation", animationName, fireDelay)
        this.SetUserData("animation", animationName)
    }


    /*
     * Sets the alpha (opacity) of the entity.
     *
     * @param {number} opacity - The alpha value (0-255).
     * @param {number} fireDelay - Delay in seconds before applying.
     * Note: Don't forget to set "rendermode" to 5 for alpha to work.
    */
    function SetAlpha(opacity, fireDelay = 0) {
        EntFireByHandle(this.CBaseEntity, "Alpha", opacity.tostring(), fireDelay, null, null)
        this.SetUserData("alpha", opacity)
    }


    /*
     * Sets the color of the entity.
     *
     * @param {string|Vector} colorValue - The color value as a string (e.g., "255 0 0") or a Vector.
     * @param {number} fireDelay - Delay in seconds before applying.
    */
    function SetColor(colorValue, fireDelay = 0) {
        if(typeof colorValue == "Vector") 
            colorValue = macros.VecToStr(colorValue)
        EntFireByHandle(this.CBaseEntity, "Color", colorValue, fireDelay, null, null)
        this.SetUserData("color", colorValue)
    }


    /*
     * Sets the skin of the entity.
     *
     * @param {number} skin - The skin number.
     * @param {number} fireDelay - Delay in seconds before applying.
    */
    function SetSkin(skin, fireDelay = 0) {
        EntFireByHandle(this.CBaseEntity, "skin", skin.tostring(), fireDelay, null, null)
        this.SetUserData("skin", skin)
    }


    /*
     * Sets whether the entity should be drawn or not. 
     *
     * @param {boolean} isEnabled - True to enable drawing, false to disable.
     * @param {number} fireDelay - Delay in seconds before applying.
    */
    function SetDrawEnabled(isEnabled, fireDelay = 0) {
        local action = isEnabled ? "EnableDraw" : "DisableDraw"
        EntFireByHandle(this.CBaseEntity, action, "", fireDelay)
        this.SetUserData("IsDraw", isEnabled)
    }

    /*
     * Checks if the entity is set to be drawn.
     * 
     * @returns {boolean} - True if the entity is set to be drawn, false otherwise.
    */
    function IsDrawEnabled() {
        return this.GetUserData("IsDraw")
    }

    /*
     * Sets whether the entity should be ignored during traces.
     * 
     * @param {boolean} isEnabled - True to ignore the entity during traces, false otherwise.
    */
    function SetTraceIgnore(isEnabled) {
        this.SetUserData("TracePlusIgnore", isEnabled)
    }

    /*
     * Sets the spawnflags for the entity.
     *
     * @param {number} flag - The spawnflags value to set.
    */
    function SetSpawnflags(flag) {
        this.SetKeyValue("CollisionGroup", flag)
        this.SetUserData("spawnflags", flag)
    }


    /*
     * Sets the scale of the entity's model.
     *
     * @param {number} scaleValue - The scale value.
     * @param {number} fireDelay - Delay in seconds before applying.
    */
    function SetModelScale(scaleValue, fireDelay = 0) {
        EntFireByHandle(this.CBaseEntity, "addoutput", "ModelScale " + scaleValue, fireDelay, null, null)
        this.SetUserData("ModelScale", scaleValue)
        EntFireByHandle(this, "SetBodyGroup", "1"); EntFireByHandle(this, "SetBodyGroup", "0", 0.02)
    }

    /*
     * Gets the current model scale of the entity.
     *
     * @returns {number} - The current model scale value.
    */
    function GetModelScale() {
        local res = this.GetUserData("ModelScale")
        return res ? res : 1
    }


    /*
     * Sets the center of the entity.
     *
     * @param {Vector} vector - The center vector.
    */
    function SetCenter(vector) {
        local offset = this.CBaseEntity.GetCenter() - this.CBaseEntity.GetOrigin()
        this.CBaseEntity.SetAbsOrigin( vector - offset )
    }

    /*
     * Sets the bounding box of the entity.
     *
     * @param {Vector|string} min - The minimum bounds vector or a string representation of the vector.
     * @param {Vector|string} max - The maximum bounds vector or a string representation of the vector.
    */
    function SetBBox(minBounds, maxBounds) {
        // Please specify the data type of `min` and `max` to improve the documentation accuracy.
        if (type(minBounds) == "string") {
            minBounds = macros.StrToVec(minBounds)
        }
        if (type(maxBounds) == "string") {
            maxBounds = macros.StrToVec(maxBounds)
        }

        this.CBaseEntity.SetSize(minBounds, maxBounds)
    }


    /*
     * Sets a context value for the entity.
     *
     * @param {string} name - The name of the context value.
     * @param {any} value - The value to set.
     * @param {number} fireDelay - Delay in seconds before applying.
    */
    function SetContext(name, value, fireDelay = 0) {
        EntFireByHandle(this.CBaseEntity, "AddContext", (name + ":" + value), fireDelay)
        this.SetUserData(name, value)
    }
    
    /* 
     * Stores an arbitrary value associated with the entity.
     *
     * @param {string} name - The name of the value.  
     * @param {any} value - The value to store.
    */
    function SetUserData(name, value) {
        this.EntityScope[name.tolower()] <- value
    }


    /*
     * Gets a stored user data value.
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


    /*
     * Gets the bounding box of the entity.
     *
     * @returns {table} - The minimum bounds and maximum bounds of the entity.
    */
    function GetBBox() {
        local max = GetBoundingMaxs()
        local min = GetBoundingMins()
        return {min = min, max = max}
    }


    /* 
     * Returns the axis-aligned bounding box (AABB) of the entity.
     *
     * @returns {table} - The minimum bounds, maximum bounds, and center of the entity.
    */ 
    function GetAABB() {
        local max = CreateAABB(7)
        local min = CreateAABB(0)
        local center = CreateAABB(4)
        return {min = min, center = center, max = max}
    }


    /* 
     * Gets the index of the entity.
     *
     * @returns {int} - The index of the entity.
    */
    function GetIndex() {
        return this.CBaseEntity.entindex()
    }


    /*
     * Gets the value of the key-value pair of the entity.
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


    /*
     * Gets the spawnflags for the entity.
     * Note: only works if you used the SetKeyValue function!
     *
     * @returns {int|null} - The spawnflags value.
    */ 
    function GetSpawnflags() {
        return this.GetUserData("spawnflags")
    }


    /*
     * Gets the alpha/opacity value of the entity.
     * Note: only works if you used the SetKeyValue function!
     * 
     * @returns {int|null} - The alpha value.
    */
    function GetAlpha() {
        local alpha = this.GetUserData("alpha")
        return alpha != null ? alpha : 255
    }


    /*
     * Gets the color value of the entity.
     * Note: only works if you used the SetKeyValue function!
     *
     * @returns {string|null} - The color value.
    */
    function GetColor() {
        local color = this.GetUserData("color")
        return color ? color : "255 255 255"
    }


    /*
     * Gets the skin of the entity.
     * Note: only works if you used the SetKeyValue function!
     *
     * @returns {number|null} - The skin number.
    */
    function GetSkin() {
        local skin = this.GetUserData("skin")
        return skin ? skin : 0
    }


    /*
     * Gets the prefix of the entity name.
     *
     * @returns {string} - The prefix of the entity name.
    */
    function GetNamePrefix() {
        return macros.GetPrefix(this.GetName())
    }


    /*
     * Gets the postfix of the entity name.
     *
     * @returns {string} - The postfix of the entity name.
    */
    function GetNamePostfix() {
        return macros.GetPostfix(this.GetName())
    }

    /*
     * Retrieves the partner instance of the entity, prioritizing the actual partner entity if available, and falling back to user-stored partner data if necessary.
     *
     * @returns {Entity|null} - The partner entity, or null if no partner is found.
     * 
     * This method first attempts to retrieve the actual partner entity using the `GetPartnerInstance` method of the underlying CBaseEntity.
     * If no partner entity is found, it then checks for a partner stored in the entity's user data under the key "partner". This can be useful in situations where the partner relationship is not directly established through entity properties but is managed through custom logic. 
    */
    function GetPartnerInstance() {
        if(this.CBaseEntity instanceof CLinkedPortalDoor)
            return entLib.FromEntity(this.CBaseEntity.GetPartnerInstance())
        return this.GetUserData("partner")
    }


    /*
     * Gets the oriented bounding box of the entity.
     *
     * @param {number} stat - 0 for min bounds, 7 for max bounds, 4 for center bounds. 
     * @returns {Vector} - The bounds vector.
    */
    function CreateAABB(stat) { 
        local angles = this.GetAngles()
        if(stat == 4) 
            angles = Vector(45, 45, 45)

        local all_vertex = this.getBBoxPoints()
        local x = array(8) // AVLTree() // todo FUCKING AVL!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        local y = array(8)
        local z = array(8)

        foreach(idx, vec in all_vertex) {
            x[idx] = vec.x
            y[idx] = vec.y
            z[idx] = vec.z
        }

        x.sort(); y.sort(); z.sort()
 
        if(stat == 4) // centered
            return ( Vector(x[7], y[7], z[7]) - Vector(x[0], y[0], z[0]) ) * 0.5
        return Vector(x[stat], y[stat], z[stat])
    }


    /*
     * Gets the 8 vertices of the axis-aligned bounding box.
     *
     * @returns {Array<Vector>} - The 8 vertices of the bounding box.  
    */
    function getBBoxPoints() {
        local max = this.GetBoundingMaxs();
        local min = this.GetBoundingMins();
        local angles = this.GetAngles()
    
        local getVertex = macros.GetVertex
        return [
            getVertex(max, min, min, angles), // 0 - Right-Bottom-Front
            getVertex(max, max, min, angles), // 1 - Right-Top-Front
            getVertex(min, max, min, angles), // 2 - Left-Top-Front
            getVertex(min, min, min, angles)  // 3 - Left-Bottom-Front 
            getVertex(min, min, max, angles), // 4 - Left-Bottom-Back
            getVertex(min, max, max, angles), // 5 - Left-Top-Back
            getVertex(max, max, max, angles), // 6 - Right-Top-Back
            getVertex(max, min, max, angles), // 7 - Right-Bottom-Back
        ]
    }

    /*
     * Gets the faces of the entity's bounding box as an array of triangle vertices.
     *
     * @returns {array} - An array of 12 Vector triplets, where each triplet represents the three vertices of a triangle face.
     * 
    */
     function getBBoxFaces() {
        local vertices = this.getBBoxPoints()
        return [
            /* Bottom face triangles */ 
            macros.GetTriangle(vertices[0], vertices[3], vertices[4]), // Face 0: Right-Bottom-Front, Left-Bottom-Front, Left-Bottom-Back
            macros.GetTriangle(vertices[0], vertices[4], vertices[7]), // Face 1: Right-Bottom-Front, Left-Bottom-Back, Right-Bottom-Back

            /* Top face triangles */ 
            macros.GetTriangle(vertices[1], vertices[2], vertices[5]), // Face 2: Right-Top-Front, Left-Top-Front, Left-Top-Back
            macros.GetTriangle(vertices[1], vertices[5], vertices[6]), // Face 3: Right-Top-Front, Left-Top-Back, Right-Top-Back

            /* Left face triangles */ 
            macros.GetTriangle(vertices[3], vertices[2], vertices[5]), // Face 4: Left-Bottom-Front, Left-Top-Front, Left-Top-Back 
            macros.GetTriangle(vertices[3], vertices[5], vertices[4]), // Face 5: Left-Bottom-Front, Left-Top-Back, Left-Bottom-Back

            /* Right face triangles */ 
            macros.GetTriangle(vertices[0], vertices[1], vertices[6]), // Face 6: Right-Bottom-Front, Right-Top-Front, Right-Top-Back
            macros.GetTriangle(vertices[0], vertices[6], vertices[7]), // Face 7: Right-Bottom-Front, Right-Top-Back, Right-Bottom-Back

            /* Front face triangles */ 
            macros.GetTriangle(vertices[0], vertices[1], vertices[2]), // Face 8: Right-Bottom-Front, Right-Top-Front, Left-Top-Front 
            macros.GetTriangle(vertices[0], vertices[2], vertices[3]), // Face 9: Right-Bottom-Front, Left-Top-Front, Left-Bottom-Front

            /* Back face triangles */
            macros.GetTriangle(vertices[7], vertices[6], vertices[5]), // Face 10: Right-Bottom-Back, Right-Top-Back, Left-Top-Back 
            macros.GetTriangle(vertices[7], vertices[5], vertices[4])  // Face 11: Right-Bottom-Back, Left-Top-Back, Left-Bottom-Back 
        ]
    }

    /*
     * Checks if this entity is equal to another entity based on their entity indices.
     *
     * @param {pcapEntity} other - The other entity to compare.
     * @returns {boolean} - True if the entities are equal, false otherwise.
    */
    function isEqually(other) return this.entindex() == other.entindex()

    /*
     * Converts the entity object to a string.
     *
     * @returns {string} - The string representation of the entity.
    */
    function _tostring() return "pcapEntity: " + this.CBaseEntity + ""

    /*
     * Returns the type of the entity object.
     *
     * @returns {string} - The type of the entity object.
    */
    function _typeof() return "pcapEntity"
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
function pcapEntity::ValidateScriptScope() return this.CBaseEntity.ValidateScriptScope()
function pcapEntity::EyePosition() return this.CBaseEntity.EyePosition()
function pcapEntity::entindex() return this.CBaseEntity.entindex()

function pcapEntity::SetAbsOrigin(vector) this.CBaseEntity.SetAbsOrigin(vector)
function pcapEntity::SetForwardVector(vector) this.CBaseEntity.SetForwardVector(vector)
function pcapEntity::SetHealth(health) this.CBaseEntity.SetHealth(health)
function pcapEntity::SetMaxHealth(health) this.CBaseEntity.SetMaxHealth(health)
function pcapEntity::SetModel(model_name) this.CBaseEntity.SetModel(model_name)
function pcapEntity::SetOrigin(vector) this.CBaseEntity.SetOrigin(vector)