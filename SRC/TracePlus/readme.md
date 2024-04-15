# TracePlus Module

The `TracePlus` module enhances the ray tracing capabilities in VScripts by providing more precise and feature-rich tracing functions, including support for portals and custom trace settings. It aims to improve the accuracy and flexibility of ray tracing operations in VScripts development.

## [TracePlus/settings.nut](settings.nut)

This file defines the `TracePlus.Settings` class, which encapsulates settings for ray traces.

### `TracePlus.Settings`

This class stores various settings that control the behavior of traces, such as which entities and models to ignore, the error tolerance for trace distances, and custom filter functions.

**Properties:**

* `ignoreClasses` (arrayLib): An array of entity classnames to ignore during traces.
* `priorityClasses` (arrayLib): An array of entity classnames to prioritize during traces.
* `ignoredModels` (arrayLib): An array of entity model names to ignore during traces.
* `errorTolerance` (number): The maximum allowed distance between a trace's start and hit positions. Traces exceeding this tolerance may be considered inaccurate.
* `shouldRayHitEntity` (function or null): A custom function to determine if a ray should hit an entity.
* `shouldIgnoreEntity` (function or null): A custom function to determine if an entity should be ignored during a trace.

**Methods:**

* `new(settingsTable)`: Creates a new `TracePlus.Settings` object with default values or from a table of settings.
* `SetIgnoredClasses(ignoreClassesArray)`: Sets the list of entity classnames to ignore during traces.
* `SetPriorityClasses(priorityClassesArray)`: Sets the list of entity classnames to prioritize during traces.
* `SetIgnoredModels(ignoredModelsArray)`: Sets the list of entity model names to ignore during traces.
* `SetErrorTolerance(tolerance)`: Sets the maximum allowed distance between trace start and hit positions.
* `AppendIgnoredClass(className)`: Appends an entity classname to the list of ignored classes.
* `AppendPriorityClasses(className)`: Appends an entity classname to the list of priority classes.
* `AppendIgnoredModel(modelName)`: Appends an entity model name to the list of ignored models.
* `GetIgnoreClasses()`: Returns the list of entity classnames to ignore during traces.
* `GetPriorityClasses()`: Returns the list of entity classnames to prioritize during traces.
* `GetIgnoredModels()`: Returns the list of entity model names to ignore during traces.
* `GetErrorTolerance()`: Returns the maximum allowed distance between trace start and hit positions.
* `SetCollisionFilter(filterFunction)`: Sets a custom function to determine if a ray should hit an entity.
* `SetIgnoreFilter(filterFunction)`: Sets a custom function to determine if an entity should be ignored during a trace.
* `GetCollisionFilter()`: Returns the custom collision filter function.
* `GetIgnoreFilter()`: Returns the custom ignore filter function.
* `ApplyCollisionFilter(entity, note)`: Applies the custom collision filter function to an entity.
* `ApplyIgnoreFilter(entity, note)`: Applies the custom ignore filter function to an entity.
* `UpdateIgnoreEntities(ignoreEntities, newEnt)`: Updates the list of entities to ignore during a trace, including the player entity.

**Example:**

```js
local traceSettings = TracePlus.Settings.new({
    ignoreClasses = arrayLib.new("trigger_multiple", "func_brush"),
    errorTolerance = 100
})
```

## [TracePlus/results.nut](results.nut)

This file defines classes representing the results of different types of traces, providing methods for accessing information about the trace and its outcome.

### `CheapTraceResult`

This class represents the result of a cheap (fast but less accurate) trace. It stores information about the trace, such as the start and end positions, hit position, hit fraction, and portal entry information.

**Properties:**

* `traceHandler` (table): The trace handler object containing trace information.
* `hitPos` (Vector): The hit position of the trace.
* `surfaceNormal` (Vector, optional): The impact normal of the surface hit by the trace (calculated on demand).
* `portalEntryInfo` (CheapTraceResult or null): Information about the portal the trace entered, if applicable.

**Methods:**

* `GetStartPos()`: Returns the start position of the trace as a Vector.
* `GetEndPos()`: Returns the end position of the trace as a Vector.
* `GetHitpos()`: Returns the hit position of the trace as a Vector.
* `GetFraction()`: Returns the fraction of the trace distance where the hit occurred (between 0 and 1).
* `DidHit()`: Returns `true` if the trace hit something, `false` otherwise.
* `GetDir()`: Returns the direction vector of the trace as a Vector.
* `GetPortalEntryInfo()`: Returns the portal entry information as a `CheapTraceResult` object, or `null` if no portal was entered.
* `GetAggregatedPortalEntryInfo()`: Returns an `arrayLib` containing all portal entry information for the trace, including nested portals, as `CheapTraceResult` objects.
* `GetImpactNormal()`: Calculates and returns the impact normal of the surface hit by the trace as a Vector.

**Example:**

```js
local startPos = Vector(0, 0, 0)
local endPos = Vector(100, 0, 0)
local traceResult = TracePlus.Cheap(startPos, endPos)

if (traceResult.DidHit()) {
    printl("Trace hit something at:" + traceResult.GetHitpos())
    local normal = traceResult.GetImpactNormal()
    // ... do something with the normal
}
```

### `BboxTraceResult`

This class represents the result of a bbox cast (trace with a bounding box). It extends the `CheapTraceResult` class and adds information about the hit entity and trace settings.

**Additional Properties:**

* `hitEnt` (CBaseEntity): The entity hit by the trace, or `null` if no entity was hit.

**Additional Methods:**

* `GetEntity()`: Returns the hit entity as a `pcapEntity` object, or `null` if no entity was hit.
* `GetEntityClassname()`: Returns the classname of the hit entity, or `null` if no entity was hit.
* `GetIngoreEntities()`: Returns the list of entities that were ignored during the trace.
* `GetTraceSettings()`: Returns the settings used for the trace as a `TraceSettings` object.
* `GetNote()`: Returns the optional note associated with the trace.
* `DidHitWorld()`: Returns `true` if the trace hit the world geometry (not an entity), `false` otherwise.

**Example:**

```js
local traceResult = TracePlus.Bbox(startPos, endPos)

if (traceResult.DidHit()) {
    local hitEntity = traceResult.GetEntity()
if (hitEntity) {
    printl("Trace hit entity:" + hitEntity.GetClassname())
} else {
    printl("Trace hit the world.")
}
}
```

## [TracePlus/cheap_trace.nut](cheap_trace.nut)

This file provides functions for performing cheap (fast but less accurate) traces.

### `TracePlus.Cheap(startPos, endPos)`

This function performs a cheap trace from the specified start and end positions. It uses the standard `TraceLine` function internally but returns a `CheapTraceResult` object with additional information.

**Parameters:**

* `startPos` (Vector): The start position of the trace.
* `endPos` (Vector): The end position of the trace.

**Returns:**

* (CheapTraceResult): The trace result object.

**Example:**

```js
local traceResult = TracePlus.Cheap(startPos, endPos)
if (traceResult.DidHit()) {
    // ...
}
```

### `TracePlus.FromEyes.Cheap(distance, player)`

This function performs a cheap trace from the player's eyes in the direction they are looking.

**Parameters:**

* `distance` (number): The distance of the trace.
* `player` (CBaseEntity or pcapEntity): The player entity.

**Returns:**

* (CheapTraceResult): The trace result object.

**Example:**

```js
local player = GetPlayerEx()
local traceResult = TracePlus.FromEyes.Cheap(100, player) // Trace 100 units in front of the player
```

## [TracePlus/bboxcast.nut](bboxcast.nut)

This file provides functions for performing bbox casts (traces with bounding boxes).

### `TracePlus.Bbox(startPos, endPos, ignoreEntities, settings, note)`

This function performs a bbox cast from the specified start and end positions. It uses a more precise algorithm than `TraceLine` to check for collisions with entities' bounding boxes.

**Parameters:**

* `startPos` (Vector): The start position of the trace.
* `endPos` (Vector): The end position of the trace.
* `ignoreEntities` (array, CBaseEntity, or null, optional): A list of entities or a single entity to ignore during the trace.
* `settings` (TraceSettings, optional): The settings to use for the trace (defaults to `TracePlus.defaultSettings`).
* `note` (string, optional): An optional note associated with the trace.

**Returns:**

* (BboxTraceResult): The trace result object.

**Example:**

```js
local traceResult = TracePlus.Bbox(startPos, endPos, ignoreEntities, traceSettings)
if (traceResult.DidHit()) {
    // ...
}
```

### `TracePlus.FromEyes.Bbox(distance, player, ignoreEntities, settings)`

This function performs a bbox cast from the player's eyes in the direction they are looking.

**Parameters:**

* `distance` (number): The distance of the trace.
* `player` (CBaseEntity or pcapEntity): The player entity.
* `ignoreEntities` (array, CBaseEntity, or null, optional): A list of entities or a single entity to ignore during the trace.
* `settings` (TraceSettings, optional): The settings to use for the trace (defaults to `TracePlus.defaultSettings`).

**Returns:**

* (BboxTraceResult): The trace result object.

**Example:**

```js
local traceResult = TracePlus.FromEyes.Bbox(100, player, ignoreEntities)
if (traceResult.DidHit()) {
    // ...
}
```

## [TracePlus/portal_casting.nut](portal_casting.nut)

This file contains functions for handling portal interactions during traces.

### `TracePlus.PortalCheap(startPos, endPos)`

This function performs a cheap trace with portal support. It takes into account portal entities and adjusts the trace path accordingly.

**Parameters:**

* `startPos` (Vector): The start position of the trace.
* `endPos` (Vector): The end position of the trace.

**Returns:**

* (CheapTraceResult): The trace result object, including information about portal entries.

**Example:**

```js
local traceResult = TracePlus.PortalCheap(startPos, endPos)
if (traceResult.DidHit()) {
    // ...
}
```

### `TracePlus.FromEyes.PortalCheap(distance, player)`

This function performs a cheap trace with portal support from the player's eyes. It takes into account portal entities and adjusts the trace path accordingly.

**Parameters:**

* `distance` (number): The distance of the trace.
* `player` (CBaseEntity or pcapEntity): The player entity.

**Returns:**

* (CheapTraceResult): The trace result object, including information about portal entries.

**Example:**

```js
local traceResult = TracePlus.FromEyes.PortalCheap(1000, player)
if (traceResult.DidHit()) {
    local portalEntries = traceResult.GetAggregatedPortalEntryInfo()
    // ... process portal entry information
}
```


### `TracePlus.PortalBbox(startPos, endPos, ignoreEntities, settings, note)`

This function performs a bbox cast with portal support. It takes into account portal entities and adjusts the trace path accordingly.

**Parameters:**

* `startPos` (Vector): The start position of the trace.
* `endPos` (Vector): The end position of the trace.
* `ignoreEntities` (array, CBaseEntity, or null, optional): A list of entities or a single entity to ignore during the trace.
* `settings` (TraceSettings, optional): The settings to use for the trace (defaults to `TracePlus.defaultSettings`).
* `note` (string, optional): An optional note associated with the trace.

**Returns:**

* (BboxTraceResult): The trace result object, including information about portal entries.

**Example:**

```js
local traceResult = TracePlus.PortalBbox(startPos, endPos, ignoreEntities, traceSettings)
if (traceResult.DidHit()) {
    // ...
}
```

### `TracePlus.FromEyes.PortalBbox(distance, player, ignoreEntities, settings)`

This function performs a bbox cast with portal support from the player's eyes.

**Parameters:**

* `distance` (number): The distance of the trace.
* `player` (CBaseEntity or pcapEntity): The player entity.
* `ignoreEntities` (array, CBaseEntity, or null, optional): A list of entities or a single entity to ignore during the trace.
* `settings` (TraceSettings, optional): The settings to use for the trace (defaults to `TracePlus.defaultSettings`).

**Returns:**

* (BboxTraceResult): The trace result object, including information about portal entries.

**Example:**

```js
local traceResult = TracePlus.FromEyes.PortalBbox(1000, player, ignoreEntities)
if (traceResult.DidHit()) {
    // ...
}
```


### `FindPartnersForPortals()` (init-func)

This function finds and sets partner portals for linked portal doors and prop portals. It iterates through all entities of class "linked_portal_door" and "prop_portal" and attempts to find their corresponding partner portals. For linked portal doors, it retrieves the partner instance using `GetPartnerInstance()` and stores it as user data in both portals. For prop portals, it assumes the partner portal is the other prop_portal entity in the map and stores it as user data.

## [TracePlus/bbox_analyzer.nut](bbox_analyzer.nut)

This file defines the `TraceLineAnalyzer` class for precise trace line analysis.

### `TraceLineAnalyzer`

This class provides methods for tracing lines with more precision and considering entity priorities and ignore settings. It subdivides the trace into smaller segments and checks for entity collisions along the way, taking into account the trace settings. **It's required for the Bboxcast**

**Properties:**

* `settings` (TraceSettings): The settings to use for the trace.
* `hitPos` (Vector): The hit position of the trace.
* `hitEnt` (CBaseEntity): The entity hit by the trace, or `null` if no entity was hit.

**Methods:**

* `Trace(startPos, endPos, ignoreEntities, note)`: Performs a precise trace line analysis.
* `_isPriorityEntity(entityClass)`: Checks if an entity is a priority entity based on the trace settings.
* `_isIgnoredEntity(entityClass)`: Checks if an entity should be ignored based on the trace settings.
* `_hitEntity(ent, ignoreEntities, note)`: Checks if the trace should consider a hit with the given entity, taking into account the trace settings and ignore list.

## [TracePlus/calculate_normal.nut](calculate_normal.nut)

This file provides functions for calculating the impact normal of a surface hit by a trace.

### `CalculateImpactNormal(startPos, hitPos, traceResult)`

This function calculates the impact normal of a surface hit by a trace. It uses two additional traces to find intersection points near the hit position and then calculates the normal vector based on the cross product of the vectors formed by these points and the hit position.

**Parameters:**

* `startPos` (Vector): The start position of the original trace.
* `hitPos` (Vector): The hit position of the original trace.
* `traceResult` (TraceResult): The trace result object.

**Returns:**

* (Vector): The calculated impact normal vector.

**Explanation:**

1. **Trace Direction:** The function starts by calculating the normalized direction vector of the original trace, which points from the start position to the hit position.
2. **New Start Positions:** Two new start positions for additional traces are calculated by offsetting the original start position slightly along two perpendicular directions to the trace direction. This ensures that the additional traces will hit the surface at different points, allowing for the calculation of the normal vector.
3. **Additional Traces:** Two cheap traces are performed from the new start positions in the same direction as the original trace. The hit positions of these traces are stored as intersection points.
4. **Edge Vectors:** Two edge vectors are calculated by subtracting the hit position of the original trace from the hit positions of the two additional traces. These vectors represent two edges of the surface that was hit.
5. **Cross Product:** The cross product of the two edge vectors is calculated to obtain a vector that is perpendicular to both edges and thus represents the normal vector of the surface.
6. **Normalization:** The resulting normal vector is normalized to have a length of 1.
7. **Result:** The function returns the normalized normal vector, which represents the orientation of the surface hit by the trace.


### `CalculateImpactNormalFromBbox(startPos, hitPos, traceResult)`

This function calculates the impact normal of a surface hit by a trace using the bounding box of the hit entity. It provides a more accurate and efficient way to calculate normals compared to the traditional method of using additional traces and trigonometry.

**Parameters:**

* `startPos` (Vector): The start position of the trace.
* `hitPos` (Vector): The hit position of the trace.
* `traceResult` (BboxTraceResult): The trace result object containing information about the hit entity.

**Returns:**

* (Vector): The calculated impact normal vector.

**Explanation:**

1. **Hit Entity and BBox Vertices:** The function first retrieves the hit entity from the trace result object and then obtains the eight vertices of the entity's bounding box using the `pcapEntity.getBBoxPoints()` method.
2. **Trace Direction:** The direction vector of the trace is calculated by subtracting the start position from the hit position and normalizing the resulting vector.
3. **Closest Vertices:** The function then finds the three vertices of the bounding box that are closest to the hit position. These three vertices define the face of the bounding box that the trace hit.
4. **Face Normal Calculation:** The normal vector of the face is calculated using the cross product of two edge vectors of the face.
5. **Normal Direction Check:** The dot product of the face normal and the trace direction vector is calculated to determine if the normal vector is pointing in the correct direction (away from the trace). If the dot product is positive, the normal vector is inverted.
6. **Result:** The function returns the final calculated normal vector, which represents the orientation of the surface hit by the trace.