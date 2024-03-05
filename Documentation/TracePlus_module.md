# Advanced TraceLine Library for Portal 2!

![version](https://img.shields.io/badge/TraceLinePlusPlus-v1.0.0-informational)

This small-library provides a set of utilities for performing trace operations in Source games. It includes various trace settings, tracers, and trace result handlers.

## Components

### TraceSettings

The `TraceSettings` class allows you to configure various settings that affect the behavior of trace operations. It includes the following properties and methods:

| Property/Method | Description |
| --- | --- |
| `ignoreClasses` | An array of class names to ignore during tracing. |
| `priorityClasses` | An array of class names to prioritize during tracing. |
| `ignoredModels` | An array of model names to ignore during tracing. |
| `errorTolerance` | The maximum error tolerance for tracing operations (in units). |
| `useCostlyNormalComputation` | A flag to enable/disable costly normal computation (unstable). |
| `shouldRayHitEntity` | A function to determine whether the ray should hit a specific entity. |
| `shouldIgnoreEntity` | A function to determine whether a specific entity should be ignored. |
| `new(table)` | Creates a new `TraceSettings` instance from a table. |
| `SetIgnoredClasses(array)` | Sets the array of ignored class names. |
| `SetPriorityClasses(array)` | Sets the array of priority class names. |
| `SetIgnoredModels(array)` | Sets the array of ignored model names. |
| `SetErrorTolerance(int)` | Sets the error tolerance for tracing operations. |
| `AppendIgnoredClass(string)` | Appends a class name to the ignored classes array. |
| `AppendPriorityClasses(string)` | Appends a class name to the priority classes array. |
| `AppendIgnoredModel(string)` | Appends a model name to the ignored models array. |
| `GetIgnoreClasses()` | Returns the array of ignored class names. |
| `GetPriorityClasses()` | Returns the array of priority class names. |
| `GetIgnoredModels()` | Returns the array of ignored model names. |
| `GetErrorTolerance()` | Returns the error tolerance for tracing operations. |
| `SetCollisionFilter(func)` | Sets the collision filter function. |
| `SetIgnoreFilter(func)` | Sets the ignore filter function. |
| `GetCollisionFilter()` | Returns the collision filter function. |
| `GetIgnoreFilter()` | Returns the ignore filter function. |
| `ApplyCollisionFilter(entity, note)` | Applies the collision filter to the specified entity and note. |
| `ApplyIgnoreFilter(entity, note)` | Applies the ignore filter to the specified entity and note. |
| `ToggleUseCostlyNormal(bool)` | Enables or disables costly normal computation. |

### Tracers

The library provides the following tracer functions:

- `CheapTrace(startpos, endpos)`: Performs a cheap trace operation and returns a `TraceResult`.
- `PortalTrace(startPos, endPos)`: Performs a portal trace operation and returns a `TraceResult`.
- `BboxCast(startpos, endpos, ignoreEnts = null, settings = defaultSettings, note = null)`: Performs a bounding box cast operation and returns a `BboxTraceResult`.
- `PortalBboxCast(startPos, endPos, ignoreEnts = null, settings = defaultSettings, note = null)`: Performs a portal bounding box cast operation and returns a `BboxTraceResult`.

### TraceResult

The `TraceResult` class represents the result of a trace operation. It provides the following properties and methods:

| Property/Method | Description |
| --- | --- |
| `GetStartPos()` | Returns the start position of the trace operation. |
| `GetEndPos()` | Returns the end position of the trace operation. |
| `GetHitpos()` | Returns the position where the trace hit something. |
| `GetFraction()` | Returns the fraction of the trace distance at which the hit occurred. |
| `DidHit()` | Returns a boolean indicating whether the trace hit something. |
| `GetDir()` | Returns the direction vector of the trace operation. |
| `GetPortalEntryInfo()` | Returns information about the portal entry, if applicable. |
| `GetAggregatedPortalEntryInfo()` | Returns an array of portal entry information for all portals crossed during the trace operation. |
| `GetImpactNormal()` | Returns the normal vector of the surface at the hit position. |

### BboxTraceResult

The `BboxTraceResult` class represents the result of a bounding box cast operation. It extends the `TraceResult` class and provides the following additional properties and methods:

| Property/Method | Description |
| --- | --- |
| `GetEntity()` | Returns the entity that was hit during the trace operation. |
| `GetEntityClassname()` | Returns the class name of the entity that was hit. |
| `GetIngoreEntities()` | Returns the array of entities that were ignored during the trace operation. |
| `GetTraceSettings()` | Returns the `TraceSettings` used for the trace operation. |
| `GetNote()` | Returns the note associated with the trace operation. |
| `DidHitWorld()` | Returns a boolean indicating whether the trace hit the world geometry. |

### Presets

The library includes several preset functions for performing trace operations from the player's eyes:

- `TracePresets.CheapTracePlayerEyes(distance, player)`: Performs a cheap trace from the player's eyes up to the specified distance.
- `TracePresets.CheapPortalTracePlayerEyes(distance, player)`: Performs a cheap portal trace from the player's eyes up to the specified distance.
- `TracePresets.TracePlayerEyes(distance, player, ignoreEnts = null, settings = defaultSettings)`: Performs a trace from the player's eyes up to the specified distance, with optional ignore entities and trace settings.
- `TracePresets.PortalTracePlayerEyes(distance, player, ignoreEnts = null, settings = defaultSettings)`: Performs a portal trace from the player's eyes up to the specified distance, with optional ignore entities and trace settings.

## Usage

To use this library, simply include it in your script and call the desired functions. For example:

```squirrel
// Import the library
IncludeScript(".../main")

// Create a trace settings object
local settings = TraceSettings.new({
    ignoreClass = arrayLib.new("player", "viewmodel", "func_"),
    errorCoefficient = 150,
    customFilter = function(ent, note) {return ent.GetHealth() == 17}
})
settings.SetPriorityClasses(["prop_physics"])

// Perform a trace from the player's eyes
local player = GetPlayer()
local distance = 1000
local result = TracePresets.PortalTracePlayerEyes(distance, player, null, settings)

if (result.DidHit()) {
    printl("Hit position: " + result.GetHitpos())
    printl("Hit entity: " + result.GetEntity().GetClassname())
} else {
    printl("No hit :<")
}
```

### More info about BboxCast & BboxTraceResult [you can find here](https://github.com/IaVashik/portal2-BBoxCast-v1/blob/main/README.md)