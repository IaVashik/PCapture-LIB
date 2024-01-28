# PCapture-Entities

This module provides an improved interface for interacting with entities.

## Class entLib


### CreateByClassname(classname, keyvalues)

Creates an entity by classname. 

```
local ent = entLib.CreateByClassname("prop_physics") 
```

Creates a "prop_physics" entity.

- `classname` - Entity classname
- `keyvalues` - Initial keyvalues (optional) 

Returns a pcapEntity instance.

### FindByClassname(classname, start_ent) 

Finds an entity by classname starting search from the given entity.

```
local ent = entLib.FindByClassname("prop_physics")
```

Finds a "prop_physics" entity starting search from null.

- `classname` - Classname to search for
- `start_ent` - Starting entity for search (optional)

Returns found pcapEntity instance or null.

### FindByClassnameWithin(classname, origin, radius, start_ent)

Finds an entity by classname within a radius of a point.

```
local ent = entLib.FindByClassnameWithin("prop_physics", Vector(), 300)
```  

Finds a "prop_physics" entity within 300 units of world origin.

- `classname` - Classname to search for  
- `origin` - Center vector
- `radius` - Search radius  
- `start_ent` - Starting entity for search (optional)

Returns found pcapEntity instance or null.

### FindByName(targetname, start_ent)

Finds an entity by targetname starting search from the given entity.

```
local ent = entLib.FindByName("box01") 
```

Finds entity with name "box01".

- `targetname` - Name to search for
- `start_ent` - Starting entity for search (optional)

Returns found pcapEntity instance or null.

### FindByNameWithin(targetname, origin, radius, start_ent)

Finds an entity by targetname within a radius of a point.

```
local ent = entLib.FindByNameWithin("box01", Vector(), 300)
```

Finds entity named "box01" within 300 units of world origin.

- `targetname` - Name to search for
- `origin` - Center vector 
- `radius` - Search radius
- `start_ent` - Starting entity for search (optional)  

Returns found pcapEntity instance or null.

### FindByModel(model, start_ent) 

Finds an entity by model starting search from the given entity.

```
local ent = entLib.FindByModel("models/props/cs_office/computer_case.mdl")
```

Finds entity with model "models/props/cs_office/computer_case.mdl".

- `model` - Model name
- `start_ent` - Starting entity for search (optional)

Returns found pcapEntity instance or null.

### FindByModelWithin(model, origin, radius, start_ent)

Finds an entity by model within a radius of a point.

```
local ent = entLib.FindByModelWithin("models/props/cs_office/computer_case.mdl", Vector(), 300) 
```

Finds entity with model "models/props/cs_office/computer_case.mdl" within 300 units of world origin.

- `model` - Model name  
- `origin` - Center vector
- `radius` - Search radius
- `start_ent` - Starting entity for search (optional)

Returns found pcapEntity instance or null.

### FindInSphere(origin, radius, start_ent)

Finds entities within a sphere defined by origin and radius.

```
local ents = entLib.FindInSphere(Vector(), 300)
```

Finds entities within 300 units of world origin.

- `origin` - Sphere center
- `radius` - Sphere radius 
- `start_ent` - Starting entity for search (optional)  

Returns array of found pcapEntity instances.

### FromEntity(ent)

Converts a CBaseEntity into a pcapEntity object. 

```
local ent = Entities.FindByName(null, "box01") // CBaseEntity
local pcap = entLib.FromEntity(ent) // pcapEntity 
```

Converts a found CBaseEntity into a pcapEntity.

- `ent` - The CBaseEntity

Returns the corresponding pcapEntity object.

## Class pcapEntity

Represents an enhanced entity object.

### SetAbsAngles(angles) 

Sets rotation angles(Vector) of the entity.

```
ent.SetAbsAngles(Vector(45, 0, 0)) // diffirence: ent.SetAngles(45, 0, 0)
```

Rotates entity to have pitch of 45 degrees.

- `angles` - Angle vector

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

- `delay` - Delay time in seconds

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

- `key` - Key
- `value` - Value

### ddOutput(outputName, target, input, param = "", delay = 0, fires = -1) 

Sets outputs for the entity. 

```
ent.addOutput("OnDamaged", "self", "Kill", "", 0.5) 
```

Kills the entity 0.5 seconds after taking damage.

- `output` - Output name  
- `target` - Target name
- `input` - Input name
- `param` - Parameter (optional)
- `delay` - Delay (optional)
- `fires` - Fire count (optional)


### SetName(name) 

Sets name (targetname) of the entity.

```
ent.SetName("box01")
```

Sets entity targetname to "box01".

- `name` - New name

### SetParent(parent, delay)

Sets parent entity.

```
ent.SetParent(prop, 0.5)
```

Parents entity to "prop" after 0.5 second delay.

- `parent` - Parent entity  
- `delay` - Delay

### SetCollision(solid, delay)

Sets collision type of the entity. 

```
ent.SetCollision(0, 0) 
```

Makes entity non-solid immediately.

- `solid` - Collision type
- `delay` - Delay

### SetCollisionGroup(group)

Sets collision group of the entity.

```
ent.SetCollisionGroup(COLLISION_GROUP_WEAPON) // todo
```

Sets collision group to COLLISION_GROUP_WEAPON.

- `group` - Collision group number

### SetAnimation(name, delay) 

Starts animation on the entity. 

```
ent.SetAnimation("idle")
``` 

Starts playing "idle" animation.

- `name` - Animation name
- `delay` - Delay 

### SetAlpha(opacity, delay)

Sets opacity of the entity.

```
ent.SetAlpha(128, 1)
```

Fades entity opacity to 128 over 1 second.

- `opacity` - Opacity 0-255
- `delay` - Delay

### SetColor(color, delay)  

Sets color of the entity. 

```
ent.SetColor("0 255 0", 0)
ent.SetColor(Vector(125, 125, 125))
```

Sets entity color to green instantly.

- `color` - Color string or vector
- `delay` - Delay

### SetSkin(skin, delay) 

Sets skin of the entity.

```  
ent.SetSkin(1, 0)
```

Changes entity skin to skin 1 immediately. 

- `skin` - Skin number 
- `delay` - Delay

### SetDrawEnabled(enabled, delay)

Enables/disables rendering of the entity. 

```
ent.SetDrawEnabled(false, 0)
```

Makes entity not render instantly.

- `enabled` - True or false
- `delay` - Delay

### SetSpawnflags(flags) 

Sets spawnflags on the entity.

```
ent.SetSpawnflags(SF_PHYSPROP_START_ASLEEP) 
```

Sets entity to spawn asleep.

- `flags` - Spawnflags value

### SetModelScale(scale, delay)

Sets model scale of the entity.

```
ent.SetModelScale(2)
``` 

Scales entity model to twice size instantly.

- `scale` - Scale value
- `delay` - Delay

### SetCenter(vector)

Sets center position of the entity.

```
ent.SetCenter(Vector(0, 0, 100))
```

Moves entity center to <0, 0, 100>.

- `vector` - New center vector

### SetBBox(min, max)

Sets bounding box of the entity. 

```
ent.SetBBox(Vector(-16 -16 -18), (16 16 18))
```

Resizes entity bounds.

- `min` - Minimum bounds 
- `max` - Maximum bounds

### SetUserData(name, value) 

Stores an arbitrary value associated with the entity.

```
ent.SetUserData("example", {a = 1, b = 2})
```

Saves a table associated with the entity.

- `name` - Name
- `value` - Value 

### GetUserData(name)

Gets a stored value by name.

```
local val = ent.GetUserData("example") // outputs: {a = 1, b = 2}
``` 

Retrieves previously stored data.

- `name` - Value name

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

- `key` - Key name

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
