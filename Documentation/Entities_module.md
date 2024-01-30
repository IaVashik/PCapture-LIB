# PCapture-Entities

This module provides an improved interface for interacting with entities.

## Class entLib


### CreateByClassname(classname, keyvalues)

Creates an entity by classname. 

```
local ent = entLib.CreateByClassname("prop_physics") 
```

Creates a "prop_physics" entity.

- `classname` (string): Entity classname
- `keyvalues` (table, *optional*): Initial keyvalues 

Returns a pcapEntity instance.

### FindByClassname(classname, start_ent) 

Finds an entity by classname starting search from the given entity.

```
local ent = entLib.FindByClassname("prop_physics")
local ent2 = entLib.FindByClassname("prop_physics", ent)
```

Finds a "prop_physics" entity starting search from null.

- `classname` (string): Classname to search for
- `start_ent` (CBaseEntity|pcapEntity): Starting entity for search

Returns found pcapEntity instance or null.

### FindByClassnameWithin(classname, origin, radius, start_ent)

Finds an entity by classname within a radius of a point.

```
local ent = entLib.FindByClassnameWithin("prop_physics", Vector(), 300)
```  

Finds a "prop_physics" entity within 300 units of world origin.

- `classname` (string): Classname to search for  
- `origin` (Vector): Center vector
- `radius` (int|float): Search radius  
- `start_ent` (CBaseEntity|pcapEntity, *optional*): Starting entity for search

Returns found pcapEntity instance or null.

### FindByName(targetname, start_ent)

Finds an entity by targetname starting search from the given entity.

```
local ent = entLib.FindByName("box01") 
```

Finds entity with name "box01".

- `targetname` (string): Name to search for
- `start_ent` (CBaseEntity|pcapEntity, *optional*): Starting entity for search

Returns found pcapEntity instance or null.

### FindByNameWithin(targetname, origin, radius, start_ent)

Finds an entity by targetname within a radius of a point.

```
local ent = entLib.FindByNameWithin("box01", Vector(), 300)
```

Finds entity named "box01" within 300 units of world origin.

- `targetname` (string): Name to search for
- `origin` (Vector): Center vector 
- `radius` (int|float): Search radius
- `start_ent` (CBaseEntity|pcapEntity, *optional*): Starting entity for search

Returns found pcapEntity instance or null.

### FindByModel(model, start_ent) 

Finds an entity by model starting search from the given entity.

```
local ent = entLib.FindByModel("models/props/cs_office/computer_case.mdl")
```

Finds entity with model "models/props/cs_office/computer_case.mdl".

- `model` (string): Model name
- `start_ent` (CBaseEntity|pcapEntity, *optional*): Starting entity for search

Returns found pcapEntity instance or null.

### FindByModelWithin(model, origin, radius, start_ent)

Finds an entity by model within a radius of a point.

```
local ent = entLib.FindByModelWithin("models/props/cs_office/computer_case.mdl", Vector(), 300) 
```

Finds entity with model "models/props/cs_office/computer_case.mdl" within 300 units of world origin.

- `model` (string): Model name  
- `origin` (Vector): Center vector
- `radius` (int|float): Search radius
- `start_ent` (CBaseEntity|pcapEntity, *optional*): Starting entity for search

Returns found pcapEntity instance or null.

### FindInSphere(origin, radius, start_ent)

Finds entities within a sphere defined by origin and radius.

```
local ents = entLib.FindInSphere(Vector(), 300)
```

Finds entities within 300 units of world origin.

- `origin` (Vector): Sphere center
- `radius` (int|float): Sphere radius 
- `start_ent` (CBaseEntity|pcapEntity, *optional*): Starting entity for search

Returns array of found pcapEntity instances.

### FromEntity(ent)

Converts a CBaseEntity into a pcapEntity object. 

```
local ent = Entities.FindByName(null, "box01") // CBaseEntity
local pcap = entLib.FromEntity(ent) // pcapEntity 
```

Converts a found CBaseEntity into a pcapEntity.

- `ent` (CBaseEntity): The CBaseEntity

Returns the corresponding pcapEntity object.

## Class pcapEntity

Represents an enhanced entity object.

### SetAbsAngles(angles) 

Sets rotation angles(Vector) of the entity.
> **Note:**
> Unlike `SetAngle()` accepts a vector rather than 3 float arguments

```
ent.SetAbsAngles(Vector(45, 0, 0)) 
// diffirence: ent.SetAngles(45, 0, 0)
```
Rotates entity to have pitch of 45 degrees.

- `angles` (Vector): Angle vector

### Destroy()

Destroys the entity.

```
ent.Destroy() 
```

Removes the entity.

### Kill(delay)

Kills the entity with a delay.

```
ent.Kill(0.5)
``` 

Kills the entity after 0.5 second delay.

- `delay` (int|float): Delay time in seconds

### Dissolve()

Dissolves the entity. 

```
ent.Dissolve()
```

Renders a dissolve effect on the entity.

### IsValid() 

Checks if the entity is valid.

```
if (ent.IsValid()) {
  // Entity is valid
}
```

Returns true if valid. 

### IsPlayer()

Checks if this entity is the player. 

```
if (ent.IsPlayer()) {
  // This is the player entity  
}
```

Returns true if it is the player.

### SetKeyValue(key, value)

Sets a key-value pair of the entity.  

```
ent.SetKeyValue("targetname", "box01") 
```

Sets the targetname to "box01".

- `key` (string): Key
- `value` (int|float|Vector|string): Value

### ddOutput(outputName, target, input, param = "", delay = 0, fires = -1) 

Sets outputs for the entity. 

```
ent.addOutput("OnDamaged", "self", "Kill", "", 0.5) 
```

Kills the entity 0.5 seconds after taking damage.

- `output` (string): Output name  
- `target` (string): Targets entities named
- `input` (string): Via this input
- `param` (string, *optional*): with a parameter ovveride of
- `delay` (int|float, *optional*): Delay in seconds
- `fires` (int, *optional*): Fire count 


### SetName(name) 

Sets name (targetname) of the entity.

```
ent.SetName("box01")
```

Sets entity targetname to "box01".

- `name` (string): New name

### SetParent(parent, delay)

Sets parent entity.

```
ent.SetParent(prop, 0.5)
```

Parents entity to "prop" after 0.5 second delay.

- `parent` (CBaseEntity|pcapEntity): Parent entity  
- `delay` (int|float, *optional*): Delay

### SetCollision(solid, delay)

Sets collision type of the entity. 

```
ent.SetCollision(0) 
```

Makes entity non-solid immediately.

- `solid` (int): Collision type
- `delay` (int|float, *optional*): Delay

> **Avaliable solids:**
> 0 - SOLID_NONE; 
> 1 - SOLID_BSP; 
> 2 - SOLID_BBOX; 
> 3 - SOLID_OBB; 
> 4 - SOLID_OBB_YAW; 
> 5 - SOLID_CUSTOM; 
> 6 - SOLID_VPHYSICS; 

More info [here](https://developer.valvesoftware.com/wiki/SetSolid()) 

### SetCollisionGroup(group)

Sets collision group of the entity.

```
ent.SetCollisionGroup(COLLISION_GROUP_WEAPON) // todo
```

Sets collision group to COLLISION_GROUP_WEAPON.

- `group` (int): Collision group number
Avaliable CollisionGroup [here](https://developer.valvesoftware.com/wiki/Collision_groups) 


### SetAnimation(name, delay) 

Starts animation on the entity. 

```
ent.SetAnimation("idle")
``` 

Starts playing "idle" animation.

- `name` (string): Animation name
- `delay` (int|float, *optional*): Delay 

### SetAlpha(opacity, delay)

Sets opacity of the entity.

```
ent.SetAlpha(128, 1)
```

Fades entity opacity to 128 over 1 second.

- `opacity` (int|float): Opacity 0-255
- `delay` (int|float, *optional*): Delay

### SetColor(color, delay)  

Sets color of the entity. 

```
ent.SetColor("0 255 0", 0)
ent.SetColor(Vector(125, 125, 125))
```

Sets entity color to green instantly.

- `color` (string|Vector): Color string or vector
- `delay` (int|float, *optional*): Delay

### SetSkin(skin, delay) 

Sets skin of the entity.

```  
ent.SetSkin(1, 0)
```

Changes entity skin to skin 1 immediately. 

- `skin` (int): Skin number 
- `delay` (int|float, *optional*): Delay

### SetDrawEnabled(enabled, delay)

Enables/disables rendering of the entity. 

```
ent.SetDrawEnabled(false, 0)
```

Makes entity not render instantly.

- `enabled` (bool): True or false
- `delay` (int|float, *optional*): Delay

### SetSpawnflags(flags) 

Sets spawnflags on the entity.

```
ent.SetSpawnflags(SF_PHYSPROP_START_ASLEEP) 
```

Sets entity to spawn asleep.

- `flags` (int): Spawnflags value

### SetModelScale(scale, delay)

Sets model scale of the entity.

```
ent.SetModelScale(2)
``` 

Scales entity model to twice size instantly.

- `scale` (int|float): Scale value
- `delay` (int|float, *optional*): Delay

### SetCenter(vector)

Sets center position of the entity.

```
ent.SetCenter(Vector(0, 0, 100))
```

Moves entity center to <0, 0, 100>.

- `vector` (Vector): New center vector

### SetBBox(min, max)

Sets bounding box of the entity. 

```
ent.SetBBox(Vector(-16 -16 -18), (16 16 18))
```

Resizes entity bounds.

- `min` (Vector): Minimum bounds 
- `max` (Vector): Maximum bounds

### SetUserData(name, value) 

Stores an arbitrary value associated with the entity.

```
ent.SetUserData("example", {a = 1, b = 2})
```

Saves a table associated with the entity.

- `name` (string): Name
- `value` (any): Value 

### GetUserData(name)

Gets a stored value by name.

```
local val = ent.GetUserData("example") // outputs: {a = 1, b = 2}
``` 

Retrieves previously stored data.

- `name` (string): Value name

Returns the value or null.

### GetBBox()

Gets bounding box of the entity.

```
local bbox = ent.GetBBox() 
```

Returns {min, max} table.

### GetAABB() 

Gets oriented bounding box of the entity.  

```
local aabb = ent.GetAABB()
```

Returns {min, max, center} table.

### GetIndex()

Gets edicts index.

```
local index = ent.GetIndex()
```

Returns entity *edicts index* number.

### GetKeyValue(key)

Gets entity keyvalue.

```
local tgt = ent.GetKeyValue("targetname") 
```

Retrieves "targetname" keyvalue.

- `key` (string): Key name

Returns value or null. // TODO!!!

### GetSpawnflags()

Gets spawnflags. 

```
local flags = ent.GetSpawnflags()
```

Returns spawnflags value or null.

### GetAlpha()

Gets opacity.

```
local alpha = ent.GetAlpha()
```

Returns 0-255 or 255 by default.

### GetColor() 

Gets color.

```
local clr = ent.GetColor() 
```

Returns color string or null.

### GetNamePrefix()

Gets name prefix. 

### GetNamePostfix() 

Gets name postfix.

#### And all the other methods from CBaseEntity


## **Note:** 
 There is a significant issue when attempting to compare pcapEntity instances with CBaseEntity instances:

```
local a = entLib.FindBy.... (player) // pcapEntity
local b = Entities.FindBy.... (player) // CBaseEntity
  
print(a == b) // false
```
 
Due to how entities are compared, it is impossible to directly compare across pcapEntity and CBaseEntity. The only solution is to normalize types using .CBaseEntity or entLib.FromEntity().
