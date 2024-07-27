# Utils Module

The `Utils` module provides a collection of utility functions for script execution, debugging, file operations, and working with entities in VScripts. It aims to simplify common tasks and enhance the development experience.

## [Utils/debug.nut](debug.nut)

This file contains functions for debugging and logging messages to the console, as well as visualizing entity bounding boxes.

### LoggerLevels
The `LoggerLevels` class defines different levels of logging. The available levels are:
- `Trace` (1)
- `Debug` (5)
- `Info` (10)
- `Warning` (30)
- `Error` (60)
- `Off` (1000)

To use these levels, you need to set the `LibLogger` variable after initializing the library. For example:
```js
LibLogger = LoggerLevels.Trace
```

#### Developer Mode
All logging functions only work if the console command `developer` is set to a value higher than 0.

### dev

The `dev` table contains various debugging utility functions.

#### `DrawEntityBBox(ent, time)`

This function draws the bounding box of an entity using `DebugDrawBox` for the specified duration. It is helpful for visualizing the extents of an entity and debugging collision issues.

**Parameters:**

* `ent` (CBaseEntity or pcapEntity): The entity to draw the bounding box for.
* `time` (number): The duration in seconds to display the bounding box.

**Example:**

```js
local myEntity = entLib.FindByClassname("prop_physics")
dev.DrawEntityBBox(myEntity, 5) // Draw the bounding box for 5 seconds
```

#### `drawbox(vector, color, time)`

This function draws a box at the specified position with the given color and duration. It is useful for visualizing points or areas in the game world.

**Parameters:**

* `vector` (Vector): The position of the center of the box.
* `color` (Vector): The color of the box as a Vector with components (r, g, b).
* `time` (number, optional): The duration in seconds to display the box (default is 0.05 seconds).

**Example:**

```js
dev.drawbox(Vector(0, 0, 100), Vector(255, 0, 0), 2) // Draw a red box for 2 seconds
```

#### `trace(msg, ...)`

This function logs a trace message to the console if trace logging is enabled. It is intended for internal use within the PCapture-Lib and is not recommended for use outside the library.

**Parameters:**

* `msg` (string): The trace message string containing `{}` placeholders.
* `...` (any): Additional arguments to substitute into the placeholders.

**Example:**

```js
dev.trace("Trace message with value: {}", someValue)
```

#### `debug(msg, ...)`

This function logs a debug message to the console if debug logging is enabled.

**Parameters:**

* `msg` (string): The debug message string containing `{}` placeholders.
* `...` (any): Additional arguments to substitute into the placeholders.

**Example:**

```js
dev.debug("This is a {} message with value: {}", "debug", someValue)
```

#### `info(msg, ...)`

This function logs an info message to the console if info logging is enabled.

**Parameters:**

* `msg` (string): The info message string containing `{}` placeholders.
* `...` (any): Additional arguments to substitute into the placeholders.

**Example:**

```js
dev.info("Information message with value: {}", someValue)
```

#### `warning(msg, ...)`

This function displays a warning message in a specific format, including the function name and line number where the warning originated.

**Parameters:**

* `msg` (string): The warning message string containing `{}` placeholders.
* `...` (any): Additional arguments to substitute into the placeholders.

**Example:**

```js
if (someCondition) {
    dev.warning("Unexpected condition encountered! Value: {}", someValue)
}
```

#### `error(msg, ...)`

This function displays an error message in a specific format, including the function name and line number where the error occurred. It is used to indicate critical errors that prevent the script from functioning correctly.

**Parameters:**

* `msg` (string): The error message string containing `{}` placeholders.
* `...` (any): Additional arguments to substitute into the placeholders.

**Example:**

```js
if (!someEntity.IsValid()) {
    dev.error("Entity is invalid! Entity ID: {}", someEntity.GetID())
}
```

## [Utils/file.nut](file.nut)

This file defines the `File` class for reading from and writing to files. Due to the way file operations are handled in VScripts, there is a specific requirement when reading data from a file: **a one-tick delay is needed after calling `updateInfo()` before accessing the file contents.** This ensures that the file has been properly read and the data is available in the cache array.

### `File(path)`

**Constructor**

This creates a new `File` object for the specified file path. The file extension ".log" is automatically added if it is not already present in the path. A cache array is also created in the global scope to store the lines of the file.

**Parameters:**

* `path` (string): The path to the file, relative to the `cfg` directory.

**Example:**

```js
local myFile = File("my_data") // Creates a File object for "cfg/my_data.log"
```

### `write(text)`

This method appends the given text to the end of the file.

**Parameters:**

* `text` (string): The text to append to the file.

**Example:**

```js
myFile.write("This is some data to write to the file.")
```


#### `readlines()`

This method reads all lines from the file and returns them as an array of strings. The cache array is updated with the contents of the file. **Remember to call `updateInfo()` followed by a one-tick delay before using this method to ensure the data is available.**

**Returns:**

* (array): An array of strings, where each string is a line from the file.

**Example:**

```js
local file = File("MyFile")
file.updateInfo()
// We need a 1 tick delay
RunScriptCode.delay(function() : (file) {
local lines = file.readlines()
foreach (line in lines) {
printl(line)
}
}, 0.01)
```

#### `read()`

This method reads the entire contents of the file and returns it as a single string. **Remember to call `updateInfo()` followed by a one-tick delay before using this method to ensure the data is available.**

**Returns:**

* (string): The contents of the file as a string.

**Example:**

```js
local file = File("MyFile")
file.updateInfo()
// We need a 1 tick delay
RunScriptCode.delay(function() : (file) {
    local content = file.read()
    printl(content)
}, 0.01)
```

#### `clear()`

This method clears the contents of the file by emptying the cache array and writing an empty array to the file.

**Example:**

```js
myFile.clear() // Clear the contents of the file
```

#### `updateInfo()`

This method updates information about the file by executing it as a script. This is necessary to ensure that the cache array is populated with the latest contents of the file before reading from it.

**Example:**

```js
local file = File("MyFile")
file.updateInfo() // Update the file information
```

## [Utils/improvements.nut](improvements.nut)

This file overrides and improves existing VScripts functions to provide additional functionality or prevent potential issues.

### `FrameTime()`

This function overrides the standard `FrameTime` function to ensure that the returned frame time is never zero. This prevents issues that can arise from zero frame times in some situations. If the frame time is zero, it returns a small default value of 0.016 seconds.

**Returns:**

* (number): The current frame time in seconds.

**Example:**

```js
local deltaTime = FrameTime() // Get the current frame time, ensuring it is not zero
```

### `UniqueString(prefix)`

This function overrides the standard `UniqueString` function to include a prefix in the generated unique string. This can be useful for creating unique names for entities or other objects.

**Parameters:**

* `prefix` (string, optional): The prefix to use for the unique string (default is "u").

**Returns:**

* (string): The generated unique string with the specified prefix.

**Example:**

```js
local uniqueName = UniqueString("my_entity_") // Generates a unique name starting with "my_entity_"
```

### `EntFireByHandle(target, action, value, delay, activator, caller)`

This function overrides the standard `EntFireByHandle` function to handle `pcapEntity` objects and extract the underlying `CBaseEntity` objects. It also allows specifying an activator and caller entity, which can be useful for tracking the source of entity inputs.

**Parameters:**

* `target` (CBaseEntity or pcapEntity): The target entity to trigger the input on.
* `action` (string): The name of the input to trigger.
* `value` (string, optional): The value to pass to the input (default is an empty string).
* `delay` (number, optional): The delay in seconds before triggering the input (default is 0).
* `activator` (CBaseEntity or pcapEntity, optional): The activator entity (the entity that triggered the input).
* `caller` (CBaseEntity or pcapEntity, optional): The caller entity (the entity that called the function).

**Example:**

```js
local myEntity = entLib.FindByClassname("prop_physics")
local triggerEntity = entLib.FindByClassname("trigger_once")
EntFireByHandle(myEntity, "Kill", "", 0, triggerEntity) // Kill the entity with the trigger as the activator
```

### `GetPlayerEx(index)`

This function retrieves a player entity with extended functionality as a `pcapEntity` object. It provides a more convenient way to access player information and methods compared to the standard `GetPlayer` function.

**Parameters:**

* `index` (number, optional): The index of the player (0-based, default is 0).

**Returns:**

* (pcapEntity): The `pcapEntity` object representing the player, or `null` if the player is not found.

**Example:**

```js
local player = GetPlayerEx()
printl(player.EyePosition()) // Print the player's eye position
```

### `GetPlayers()`

This function returns an array of all players in the game as `pcapEntity` objects.

**Returns:**

* (array): An array of `pcapEntity` objects representing the players in the game.

**Example:**

```js
local players = GetPlayers()
foreach (player in players) {
    printl(player.GetName()) // Print the name of each player
}
```

### `AttachEyeControlToPlayers()` (Init-func)

This function attaches eye control entities to all players in the game. It creates `logic_measure_movement` and `info_target` entities for each player to track their eye position and angles. This information can then be accessed using the `EyePosition`, `EyeAngles`, and `EyeForwardVector` methods of the `pcapEntity` class. This function is called automatically during library initialization and periodically in multiplayer games to ensure that eye control entities are attached to any new players that join the game.

**Example:**

```js
AttachEyeControlToPlayers() // Attach eye control entities to all players
```

## [Utils/portals.nut](portals.nut)

### `::InitPortalPair(id)`
Initializes a portal pair for portal casting (TracePlus Portal Casting). 

By default, this function automatically initializes pair IDs in multiplayer. However, if you are using portal frames with unique pair IDs or custom logic that adds multiple different pair IDs to the game (such as multiportals), you must manually initialize `InitPortalPair` for proper operation with TracePlus Portal Casting.

**Parameters:**

* `id` (number): The ID of the portal pair.

**Example:**

```js
// Initialize a portal pair with ID 1
InitPortalPair(1)
// Initialize a portal pair with ID 2
InitPortalPair(4)
```

### `::IsBluePortal(ent)`
Checks if the given entity is a blue portal.

**Parameters:**

* `ent` (pcapEntity): The entity to check.

**Returns:**

* (boolean): `True` if the entity is a blue portal, `False` is a orange portal.

**Example:**

```js
local portal = entLib.FindByClassname("prop_portal")
if (IsBluePortal(portal)) {
    printl("This is a blue portal")
} else {
    printl("This is a orange portal")
}
```

### `::FindPartnerForPropPortal(portal)`
Finds the partner portal for a given `prop_portal` entity.

**Parameters:**

* `portal` (pcapEntity): The `prop_portal` entity to find the partner for.

**Returns:**

* (pcapEntity|null): The partner portal entity, or `null` if no partner is found.

### `::_CreatePortalDetector(extraKey, extraValue)`
Creates a `func_portal_detector` entity with specified key-value pairs and settings for portal detection.

**This function is not part of the public API.**

**Parameters:**

* `extraKey` (string): The key for the additional setting.
* `extraValue` (any): The value for the additional setting.

**Returns:**

* (entity): The created `func_portal_detector` entity.

### `::SetupLinkedPortals()`
Initializes linked portal doors for portal tracing.

**This function is not part of the public API and called automatically at initialization.**

This function iterates through all entities of class `linked_portal_door` and performs the following actions:
1. Finds the partner portal entity using `GetPartnerInstance()`.
2. Extracts bounding box dimensions from the portal's model name (assuming a specific naming convention).
3. Rotates the bounding box dimensions based on the portal's angles.
4. Sets the bounding box of the portal using the calculated dimensions.

## [Utils/macros.nut](macros.nut)

This file contains various macro functions that provide shortcuts for common operations, such as precaching sounds, retrieving values from tables, printing iterable objects, calculating distances, converting between strings and vectors, and getting entity name prefixes and postfixes. These macros aim to reduce code duplication and improve readability.

### `macros.Precache(soundPath)`

This macro precaches a sound script or a list of sound scripts for later use. Precaching ensures that the sounds are loaded into memory and can be played without delay.

**Parameters:**

* `soundPath` (string, array, or arrayLib): The path to the sound script or a list of paths to sound scripts, relative to the `sound` directory.

**Example:**

```js
macros.Precache("my_sound.wav") // Precache a single sound
macros.Precache(["sound1.wav", "sound2.wav"]) // Precache multiple sounds
```

### `macros.GetSoundDuration(soundName)`

This function retrieves the duration of a sound by its name. It is useful for determining how long a sound will play, which can be used for synchronization or timing purposes in scripts.

**Parameters:**

* `soundName` (string): The name of the sound.

**Returns:**

* `number`: The duration of the sound in seconds.

**Example:**

```js
local duration = macros.GetSoundDuration("my_sound.wav")
printl("The duration of the sound is " + duration + " seconds.")
```


#### `format(msg, ...)`

This function formats a message string by replacing placeholders (`{}`) with values from the provided arguments. It is similar to the `string.format` function in other programming languages and is used for creating formatted output.

**Parameters:**

* `msg` (string): The message string containing placeholders (`{}`).
* `...` (any): Additional arguments to substitute into the placeholders.

**Example:**

```js
local name = "Vashik"
local age = 20
local message = macros.format("My name is {} and I am {} years old.", name, age)
printl(message) // Output: "My name is Vashik and I am 20 years old."
```

#### `fprint(msg, ...)`

This function combines the functionality of `macros.format` and `printl`. It formats a message string with placeholders and then prints the formatted message to the console.

**Parameters:**

* `msg` (string): The message string containing placeholders (`{}`).
* `...` (any): Additional arguments to substitute into the placeholders.

**Example:**

```js
local health = 100
macros.fprint("Player health: {}", health) // Output: "Player health: 100"
```


### `macros.GetFromTable(table, key, defaultValue)`

This macro retrieves a value from a table using the specified key. If the key is not found in the table, it returns a default value. This provides a concise way to access table values without having to check for key existence explicitly.

**Parameters:**

* `table` (table): The table to retrieve the value from.
* `key` (any): The key of the value to get.
* `defaultValue` (any, optional): The default value to return if the key is not found (defaults to `null`).

**Example:**

```js
local settings = {
    health = 100,
    speed = 500
}
local healthValue = macros.GetFromTable(settings, "health") // Get the "health" value (100)
local armorValue = macros.GetFromTable(settings, "ammo", 0) // Get the "ammo" value, defaulting to 0 if not found
```

### `macros.GetKeys`

Returns a list of all keys from the provided table.

**Parameters:**

* `table` (object): The table from which to extract the keys.

**Returns:**

* `List`: A list containing all the keys from the provided table.

**Example:**

```js
local myTable = {a = 1, b = 2, c = 3}
local keys = macros.GetKeys(myTable)
printl(keys)  // Outputs: List of keys: ["a", "b", "c"]
```

### `macros.GetValues`

Returns a list of all values from the provided table.

**Parameters:**

* `table` (object): The table from which to extract the values.

**Returns:**

* `List`: A list containing all the values from the provided table.

**Example:**

```js
local myTable = {a = 1, b = 2, c = 3}
local values = macros.GetValues(myTable)
printl(values)  // Outputs: List of values: [1, 2, 3]
```

### `InvertTable(table)`
Inverts a table, swapping keys and values.

**Parameters:**

* `table` (table): The table to invert.

**Returns:**

* (table): A new table with keys and values swapped.

**Example:**

```js
local myTable = {"a": 1, "b": 2, "c": 3}
local invertedTable = macros.InvertTable(myTable)
printl(invertedTable) // Output: {1: "a", 2: "b", 3: "c"}
```


### `macros.PrintIter(iterable)`

This macro prints the keys and values of an iterable object to the console. It is useful for inspecting the contents of arrays, tables, and other iterable data structures.

**Parameters:**

* `iterable` (iterable): The iterable object to print.

**Example:**

```js
local myTable = {
    name = "Bob",
    age = 42
}
macros.PrintIter(myTable) // Output: "name: Bob", "age: 42"
```


### `Range(start, end, step)`
Generates a list of numbers within a specified range.

**Parameters:**

* `start` (number): The starting value of the range.
* `end` (number): The ending value of the range.
* `step` (number, optional): The increment between each value in the range (default is 1).

**Returns:**

* (List): A list of numbers within the specified range.

**Example:**

```js
local rangeList = macros.Range(1, 5)
printl(rangeList) // Output: List[1, 2, 3, 4, 5]

local rangeListWithStep = macros.Range(1, 10, 2)
printl(rangeListWithStep) // Output: List[1, 3, 5, 7, 9]
```

### `RangeIter(start, end, step)`
Generates an iterator that yields numbers within a specified range.

**Parameters:**

* `start` (number): The starting value of the range.
* `end` (number): The ending value of the range.
* `step` (number, optional): The increment between each value in the range (default is 1).

**Yields:**

* (number): The next number in the range.

**Example:**

```js
foreach(num in macros.RangeIter(1, 5)) {
    printl(num) // Output: 1 2 3 4 5
}

foreach(num in macros.RangeIter(1, 10, 2)) {
    printl(num) // Output: 1 3 5 7 9
}
```

### `macros.GetDist(vec1, vec2)`

This macro calculates the distance between two vectors.

**Parameters:**

* `vec1` (Vector): The first vector.
* `vec2` (Vector): The second vector.

**Returns:**

* (number): The distance between the two vectors.

**Example:**

```js
local startPos = Vector(0, 0, 0)
local endPos = Vector(10, 10, 0)
local distance = macros.GetDist(startPos, endPos) // Calculate the distance between the two points
```

### `macros.StrToVec(str)`

This macro converts a string representation of a vector (e.g., "x y z") to a `Vector` object.

**Parameters:**

* `str` (string): The string representation of the vector.

**Returns:**

* (Vector): The `Vector` object corresponding to the string representation.

**Example:**

```js
local colorString = "255 128 0"
local colorVector = macros.StrToVec(colorString) // Convert the color string to a Vector
```

### `macros.VecToStr(vec)`

This macro converts a `Vector` object to a string representation (e.g., "x y z").

**Parameters:**

* `vec` (Vector): The `Vector` object to convert.

**Returns:**

* (string): The string representation of the vector.

**Example:**

```js
local position = Vector(10, 20, 30)
local positionString = macros.VecToStr(position) // Convert the position vector to a string
```

### `macros.isEqually(val1, val2)` (TODO! more examples)

This macro checks if two values are equal, handling different data types appropriately. It uses the appropriate equality comparison for each type, including using the `isEqually` method for `Quaternion`, `Matrix`, and `pcapEntity` objects.

**Parameters:**

* `val1` (any): The first value to compare.
* `val2` (any): The second value to compare.

**Returns:**

* (boolean): True if the values are considered equal, false otherwise.

**Example:**

```js
local vec1 = Vector(1, 2, 3)
local vec2 = Vector(1, 2, 3)
if (macros.isEqually(vec1, vec2)) {
    // The vectors are equal
}
```

### `macros.GetPrefix(name)`

This macro gets the prefix of an entity name, assuming the name is formatted with a "-" separator between the prefix and the rest of the name. If no "-" is found, it returns the original name.

**Parameters:**

* `name` (string): The entity name.

**Returns:**

* (string): The prefix of the entity name, or the original name if no "-" is found.

**Example:**

```js
local entityName = "my_prefix-123"
local prefix = macros.GetPrefix(entityName) // prefix will be "my_prefix-"
```

### `macros.GetPostfix(name)`

This macro gets the postfix of an entity name, assuming the name is formatted with a "-" separator between the prefix and the rest of the name. If no "-" is found, it returns the original name.

**Parameters:**

* `name` (string): The entity name.

**Returns:**

* (string): The postfix of the entity name, or the original name if no "-" is found.

**Example:**

```js
local entityName = "my_prefix-123"
local postfix = macros.GetPostfix(entityName) // postfix will be "-123"
```

### `macros.GetEyeEndpos(player, distance)`

This macro calculates the end position of a ray cast from the player's eyes based on the given distance.

**Parameters:**

* `player` (CBaseEntity or pcapEntity): The player entity.
* `distance` (number): The distance of the ray cast.

**Returns:**

* (Vector): The end position of the ray cast.

**Example:**

```js
local player = GetPlayerEx()
local endPos = macros.GetEyeEndpos(player, 100) // Calculate the end position of a ray cast 100 units in front of the player's eyes
```

### `macros.GetVertex(x, y, z, ang)`

This macro calculates the position of a vertex of a bounding box based on the provided x, y, z bounds and the rotation angles of the bounding box. It is used internally by the `pcapEntity.getBBoxPoints()` method to retrieve the eight vertices of an entity's axis-aligned bounding box (AABB) in world coordinates.

**Parameters:**

* `x` (Vector): A Vector representing the minimum and maximum extents of the bounding box along the x-axis.
* `y` (Vector): A Vector representing the minimum and maximum extents of the bounding box along the y-axis.
* `z` (Vector): A Vector representing the minimum and maximum extents of the bounding box along the z-axis.
* `ang` (Vector): A Vector representing the Euler angles (pitch, yaw, roll) of the bounding box's rotation.

**Returns:**

* (Vector): The position of the vertex in world coordinates.

**Explanation:**

1. **Vertex Construction:** The macro first constructs a Vector using the x, y, and z components extracted from the input `x`, `y`, and `z` Vectors. This creates a Vector representing the vertex's position relative to the center of the bounding box, before any rotation is applied.
2. **Rotation:** The macro then uses the `math.vector.rotate` function to rotate the constructed vertex Vector by the specified `ang` Euler angles. This transforms the vertex's position from the bounding box's local coordinate system to world coordinates, taking into account the bounding box's rotation.
3. **Result:** The resulting Vector represents the final position of the vertex in the game world.

**Example:**

```js
// ... (assuming you have BBmin, BBmax, and angles for a bounding box)
local vertex = macros.GetVertex(BBmin, BBmin, BBmax, angles)
// This calculates the position of the vertex at the left-bottom-back corner of the bounding box in world coordinates.
```

### `macros.GetTriangle()`

This macro function creates a representation of a triangle from three given vertices. It calculates the centroid (center of mass) of the triangle and returns a table containing the centroid and the three vertices.

**Parameters:**

* `v1` (Vector): The first vertex of the triangle.
* `v2` (Vector): The second vertex of the triangle.
* `v3` (Vector): The third vertex of the triangle.

**Returns:**

* (table): A table containing two properties:
* `origin` (Vector): The centroid (center of mass) of the triangle.
* `vertices` (array): An array containing the three vertices of the triangle as Vector objects.

**Example:**

```js
local triangle = macros.GetTriangle(v1, v2, v3)
printl("Triangle centroid:", triangle.origin)
printl("Triangle vertices:", triangle.vertices)
```


### `macros.BuildAnimateFunction(name, propertySetterFunc)`

This function creates a new animation function for animating a property of one or more entities. It simplifies the creation of animations by providing a reusable and customizable animation function.

**Parameters:**

* `name` (string): The name of the animation. This name is used to identify the animation internally.
* `propertySetterFunc` (function): A function that takes an entity and a value, and sets a property on that entity. This function will be called repeatedly during the animation to update the property.

**Returns:**

* `function`: A function that can be used to start the animation. This function takes the following arguments:
  * `entities` (array or pcapEntity): An array of entities or a single entity to animate.
  * `startValue` (any): The starting value for the property.
  * `endValue` (any): The ending value for the property.
  * `time` (number): The duration of the animation in seconds.
  * `animSetting` (table, optional): A table of additional animation settings. See the `AnimEvent` constructor for details.

**Example:**

```js
local animateColor = macros.BuildAnimateFunction("ColorChange", function(ent, value) {
    ent.SetColor(value)
})

animateColor(myEntity, Vector(255, 0, 0), Vector(0, 255, 0), 2) // Animate color change from red to green over 2 seconds
```



## [Utils/scripts.nut](scripts.nut)

This file provides functions for running scripts with delays, loops, and intervals, offering more flexibility and control over script execution compared to standard VScripts mechanisms.

#### Warning:
Outdated module!!!

### `RunScriptCode`

The `RunScriptCode` table contains functions for running scripts with different timing options.

### `delay(script, runDelay, activator, rgs, scope)`

This function schedules the execution of a script after a specified delay.

**Parameters:**

* `script` (string or function): The script to execute. This can be a string containing VScripts code or a function object.
* `runDelay` (number): The delay in seconds before executing the script.
* `activator` (CBaseEntity or pcapEntity, optional): The activator entity (the entity that triggered the script execution).
* `args` (array, optional): An array of arguments to pass to the script function (only used if `script` is a function).
* `scope` (optional): Scope.

**Example:**

```js
RunScriptCode.delay(function() {
    printl("This message is printed after a 2-second delay.")
}, 2)
```

### `loopy(script, runDelay, loopCount, outputs)`

This function executes a script repeatedly with a specified delay for a given number of loops. It is useful for creating simple loops without having to manage counters or schedules manually.

**Parameters:**

* `script` (string or function): The script to execute. This can be a string containing VScripts code or a function object.
* `runDelay` (number): The delay in seconds between each execution of the script.
* `loopCount` (number): The number of times to execute the script.
* `outputs` (string or function, optional): A script or function to execute after all loops have completed.

**Example:**

```js
RunScriptCode.loopy(function(i) {
    printl("Loop iteration:" + i)
}, 0.5, 5, function() {
    printl("All loops completed!")
})
```

### `fromStr(str)`

This function executes a script from a string. It is useful for dynamically executing VScripts code that is generated or retrieved at runtime.

**Parameters:**

* `str` (string): The string containing VScripts code to execute.

**Example:**

```js
local scriptCode = "printl('Hello, world!')"
RunScriptCode.fromStr(scriptCode)
```