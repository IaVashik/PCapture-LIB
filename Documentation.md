# PCapture VScripts Library Documentation

This library consists of several modules that can be extremely useful for you when developing VScripts for Portal 2.

## 1. [Math](SRC/Math/readme.md)

The `Math` module provides various mathematical functions and objects, including those for linear interpolation, quaternions, vectors, and matrices.

### [`Math/algebraic.nut`](SRC/Math/algebraic.nut)

This file contains basic algebraic functions such as finding minimum and maximum values, clamping numbers, rounding, and remapping values.

| Function | Description |
| --------------- | ------------------------------------------------------------------------- |
| `math.min(...)` | Finds the minimum value among the given arguments. |
| `math.max(...)` | Finds the maximum value among the given arguments. |
| `math.clamp(n, min, max)` | Clamps a number within the specified range. |
| `math.round(n, precision)` | Rounds a number to the specified precision. |
| `math.Sign(x)` | Returns the sign of a number (-1, 0, or 1). |
| `math.copysign(value, sign)` | Copies the sign of one value to another. |
| `math.RemapVal(val, A, B, C, D)` | Remaps a value from the range [A, B] to the range [C, D]. |

### [`Math/utils_vector.nut`](SRC/Math/utils_vector.nut)

This file contains utility functions for working with vectors, including checking equality, rotating and un-rotating, generating random vectors, reflecting vectors, clamping components, and resizing vectors.

| Function | Description |
| ----------------------- | ----------------------------------------------------------------------------------------------------- |
| `math.vector.isEqually(vec1, vec2)` | Checks if two vectors are equal based on their rounded components. |
| `math.vector.rotate(vec, angle)` | Rotates a vector by a given angle represented as Euler angles. |
| `math.vector.unrotate(vec, angle)` | Un-rotates a vector by a given angle represented as Euler angles. |
| `math.vector.random(min, max)` | Generates a random vector within the specified range (either between two vectors or two numbers). |
| `math.vector.reflect(dir, normal)` | Reflects a direction vector off a surface with a given normal. |
| `math.vector.clamp(vec, min, max)` | Clamps the components of a vector within the specified range. |
| `math.vector.resize(vec, newLength)` | Resizes a vector to a new length while maintaining its direction. |
| `math.vector.round(vec, precision)`| Rounds the components of a vector to the specified precision. |
| `math.vector.sign(vec)`| Returns the sign vector of a number. |
| `math.vector.abs(vec)`| Calculates the absolute value of each component in a vector. |

### [`Math/lerp.nut`](SRC/Math/lerp.nut)

This file provides functions for linear interpolation (lerp) between different data types, including numbers, vectors, and colors. It also includes functions for spline interpolation, smoothstep interpolation, and other interpolation techniques.

| Function | Description |
| ---------------------- | ---------------------------------------------------------------------------- |
| `math.lerp.number(start, end, t)` | Performs linear interpolation between two numbers. |
| `math.lerp.vector(start, end, t)` | Performs linear interpolation between two vectors. |
| `math.lerp.color(start, end, t)` | Performs linear interpolation between two colors (represented as strings or vectors). |
| `math.lerp.sVector(start, end, t)` | Performs spherical linear interpolation between two vectors. |
| `math.lerp.spline(f)` | Performs cubic spline interpolation. |
| `math.lerp.SmoothStep(edge0, edge1, value)` | Performs smooth interpolation using a smoothstep function. |
| `math.lerp.FLerp(f1, f2, i1, i2, value)` | Performs linear interpolation between two values with custom interpolation parameters. |
| `math.lerp.SmoothCurve(x)` | Applies a smooth curve function to a value. |
| `math.lerp.SmoothProgress(progress)` | Calculates smooth progress based on a progress value. |

### [`Math/quaternion.nut`](SRC/Math/quaternion.nut)

This file defines the `math.Quaternion` class, which represents a quaternion (a mathematical object used for rotations in 3D space). The class provides methods for creating quaternions from Euler angles or vectors, rotating and un-rotating vectors, performing spherical linear interpolation, normalization, and conversion to other representations (axis-angle and Euler angles).

| Method | Description |
| -------------------------- | --------------------------------------------------------------------------------------------------------------- |
| `Quaternion(x, y, z, w)` | Creates a new quaternion with the specified components. |
| `fromEuler(angles)` | Creates a quaternion from Euler angles (pitch, yaw, roll). |
| `fromVector(vector)` | Creates a quaternion from a vector (with the w component set to 0). |
| `rotateVector(vector)` | Rotates a vector by the quaternion. |
| `unrotateVector(vector)` | Un-rotates a vector by the quaternion (reverses the rotation). |
| `slerp(targetQuaternion, t)`| Performs spherical linear interpolation (slerp) between this quaternion and the target quaternion. |
| `normalize()` | Normalizes the quaternion (scales its components so that its length is 1). |
| `dot(other)` | Calculates the dot product of this quaternion and another quaternion. |
| `length()` | Calculates the length (magnitude) of the quaternion. |
| `inverse()` | Calculates the inverse of the quaternion (the quaternion that, when multiplied by this quaternion, results in the identity quaternion). |
| `fromAxisAngle(axis, angle)`| Creates a quaternion from an axis and an angle of rotation around that axis. |
| `toAxisAngle()` | Converts the quaternion to an axis and an angle of rotation around that axis. |
| `toVector()` | Converts the quaternion to a vector representing Euler angles (pitch, yaw, roll). |
| `isEqually(other)` | Checks if this quaternion is equal to another quaternion based on their components and length. |
| `cmp(other)` | Compares this quaternion to another quaternion based on their magnitudes. |

### [`Math/matrix.nut`](SRC/Math/matrix.nut)

This file defines the `math.Matrix` class, which represents a 3x3 matrix (a mathematical object used for transformations in 3D space). The class provides methods for creating matrices from Euler angles, rotating and un-rotating vectors, transposing, inverting, calculating the determinant, scaling, rotating around the X axis, and performing matrix operations (multiplication, addition, and subtraction).

| Method | Description |
| -------------------------- | ----------------------------------------------------------------------------------------------------------------- |
| `Matrix(a, b, c, d, e, f, g, h, k)` | Creates a new matrix with the specified components. |
| `fromEuler(angles)` | Creates a rotation matrix from Euler angles (pitch, yaw, roll). |
| `rotateVector(point)` | Rotates a point using the matrix. |
| `unrotateVector(point)` | Unrotates a point using the matrix (reverses the rotation). |
| `transpose()` | Transposes the matrix (swaps rows and columns). |
| `inverse()` | Calculates the inverse of the matrix (the matrix that, when multiplied by this matrix, results in the identity matrix). |
| `determinant()` | Calculates the determinant of the matrix. |
| `scale(factor)` | Scales the matrix by a given factor. |
| `rotateX(angle)` | Rotates the matrix around the X axis by a given angle. |
| `_mul(other)` | Multiplies this matrix by another matrix. |
| `_add(other)` | Adds this matrix to another matrix. |
| `_sub(other)` | Subtracts another matrix from this matrix. |
| `isEqually(other)` | Checks if this matrix is equal to another matrix based on their components and sum. |
| `cmp(other)` | Compares this matrix to another matrix based on the sum of their components. |

### [More info about *Math module* here](SRC/Math/readme.md)

## 2. [IDT](SRC/IDT/readme.md) (Improved Data Types)

The `IDT` module provides enhanced versions of standard VScripts data structures, including arrays, lists, and trees.

### [`IDT/array.nut`](SRC/IDT/array.nut)

This file defines the `arrayLib` class, which is an enhanced version of the standard VScripts array with additional methods for manipulation, searching, sorting, and conversion.

| Method | Description |
| ---------------------- | ----------------------------------------------------------------------------------------------------------- |
| `arrayLib(array)` | Creates a new `arrayLib` object from an existing array. |
| `new(...)` | Creates a new `arrayLib` object from a variable number of arguments. |
| `append(value)` | Appends a value to the end of the array. |
| `apply(func)` | Applies a function to each element of the array and modifies the array in-place. |
| `clear()` | Removes all elements from the array. |
| `extend(other)` | Appends all elements from another array or `arrayLib` to the end of this array. |
| `filter(func)` | Creates a new `arrayLib` containing only the elements that satisfy the predicate function. |
| `contains(value)` | Checks if the array contains the specified value. |
| `search(value or func)` | Searches for a value or a matching element in the array using a predicate function and returns its index. |
| `insert(index, value)` | Inserts a value at the specified index in the array. |
| `len()` | Returns the number of elements in the array. |
| `map(func)` | Creates a new `arrayLib` by applying a function to each element of this array. |
| `pop()` | Removes and returns the last element of the array. |
| `push(value)` | Appends a value to the end of the array. |
| `remove(index)` | Removes the element at the specified index from the array. |
| `resize(size, fill)` | Resizes the array to the specified size and optionally fills new elements with a value. |
| `reverse()` | Reverses the order of elements in the array in-place. |
| `slice(start, end)` | Returns a new `arrayLib` containing a portion of the array. |
| `sort(func)` | Sorts the elements of the array in-place, optionally using a comparison function. |
| `top()` | Returns the last element of the array. |
| `join(separator)` | Joins the elements of the array into a string, separated by the specified separator. |
| `get(index, default)` | Returns the element at the specified index or a default value if the index is out of bounds. |
| `totable(recreate)` | Converts the array to a table, optionally recreating the table if it already exists. |
| `tolist()` | Converts the array to a list. |

### [`IDT/entity.nut`](SRC/IDT/entity.nut)

This file defines the `pcapEntity` class, which extends the functionality of `CBaseEntity` with additional methods for manipulating entity properties, setting outputs, managing user data, and retrieving information about the entity's bounding box and other attributes.

| Method | Description |
| ---------------------------------- | --------------------------------------------------------------------------------------------------------------------- |
| `pcapEntity(entity)` | Creates a new `pcapEntity` object from a `CBaseEntity` object. |
| `SetAngles(x, y, z)` | Sets the angles (pitch, yaw, roll) of the entity. |
| `SetAbsAngles(angles)` | Sets the absolute rotation angles of the entity. |
| `Destroy()` | Destroys the entity. |
| `Kill(fireDelay)` | Kills the entity with an optional delay. |
| `Dissolve()` | Dissolves the entity using an `env_entity_dissolver` entity. |
| `IsValid()` | Checks if the entity is valid (exists and is not dissolved). |
| `IsPlayer()` | Checks if the entity is the player. |
| `EyePosition()` | Gets the eye position of the player entity. |
| `EyeAngles()` | Gets the eye angles of the player entity. |
| `EyeForwardVector()` | Gets the forward vector from the player entity's eye position. |
| `SetKeyValue(key, value)` | Sets a key-value pair for the entity, also storing it as user data. |
| `addOutput(outputName, target, input, param, delay, fires)` | Sets an output for the entity, connecting it to a target entity and input with optional parameters and timing. |
| `ConnectOutputEx(outputName, script, delay, fires)` | Connects an output to a script function or string with optional delay and trigger count. |
| `EmitSoundEx(soundName, timeDelay, eventName)`| Plays a sound with an optional delay and event name for scheduling. |
| `SetName(name)` | Sets the targetname of the entity. |
| `SetUniqueName(prefix)` | Sets a unique targetname for the entity using the provided prefix. |
| `SetParent(parentEnt, fireDelay)` | Sets the parent entity for the entity. |
| `GetParent()` | Gets the parent entity of the entity, if set. |
| `SetCollision(solidType, fireDelay)` | Sets the collision type of the entity. |
| `SetCollisionGroup(collisionGroup)` | Sets the collision group of the entity. |
| `SetAnimation(animationName, fireDelay)` | Starts playing the specified animation on the entity. |
| `SetAlpha(opacity, fireDelay)` | Sets the alpha (opacity) of the entity. |
| `SetColor(colorValue, fireDelay)` | Sets the color of the entity using a color string or Vector. |
| `SetSkin(skin, fireDelay)` | Sets the skin of the entity. |
| `SetDrawEnabled(isEnabled, fireDelay)`| Enables or disables rendering of the entity. |
| `IsDrawEnabled()` | Checks if the entity is set to be drawn. |
| `SetTraceIgnore(isEnabled)` | Sets whether the entity should be ignored during traces. |
| `SetSpawnflags(flag)` | Sets the spawnflags of the entity. |
| `SetModelScale(scaleValue, fireDelay)` | Sets the scale of the entity's model. |
| `GetModelScale()` | Gets the current model scale of the entity. |
| `SetCenter(vector)` | Sets the center of the entity. |
| `SetBBox(minBounds, maxBounds)` | Sets the bounding box of the entity using vectors or string representations of vectors. |
| `SetContext(name, value, fireDelay)` | Sets a context value for the entity. |
| `SetUserData(name, value)` | Stores an arbitrary value associated with the entity using a name. |
| `GetUserData(name)` | Retrieves a stored user data value by name. |
| `GetBBox()` | Returns the bounding box of the entity as a table with `min` and `max` vectors. |
| `GetAABB()` | Returns the axis-aligned bounding box (AABB) of the entity as a table with `min`, `max`, and `center` vectors. |
| `GetIndex()` | Returns the index of the entity. |
| `GetKeyValue(key)` | Returns the value of a key-value pair for the entity, if set using `SetKeyValue`. |
| `GetSpawnflags()` | Returns the spawnflags of the entity, if set using `SetKeyValue`. |
| `GetAlpha()` | Returns the alpha (opacity) value of the entity, if set using `SetKeyValue`. |
| `GetColor()` | Returns the color of the entity, if set using `SetKeyValue`. |
| `GetSkin()` | Returns the skin of the entity, if set using `SetKeyValue`. |
| `GetNamePrefix()` | Returns the prefix of the entity's name. |
| `GetNamePostfix()` | Returns the postfix of the entity's name. |
| `CreateAABB(stat)` | Returns a specific face of the entity's oriented bounding box (AABB) as a vector. |
| `getBBoxPoints()` | Returns an array of vectors representing the 8 vertices of the entity's axis-aligned bounding box (AABB). |
| `getBBoxFaces()` | Gets the faces of the entity's bounding box as an array of triangle vertices. |

### [`IDT/entity_creator.nut`](SRC/IDT/entity_creator.nut)

This file defines the `entLib` class, which provides helper functions for creating and finding entities.

| Function | Description |
| -------------------------------------------- | -------------------------------------------------------------------------------------------------------------- |
| `CreateByClassname(classname, keyvalues)` | Creates an entity of the specified classname with the provided key-value pairs. |
| `CreateProp(classname, origin, modelname, activity, keyvalues)` | Creates a prop entity with the specified classname, origin, model name, activity, and key-value pairs. |
| `FromEntity(CBaseEntity)` | Wraps a `CBaseEntity` object in a `pcapEntity` object. |
| `FindByClassname(classname, start_ent)` | Finds an entity with the specified classname, optionally starting the search from a given entity. |
| `FindByClassnameWithin(classname, origin, radius, start_ent)` | Finds an entity with the specified classname within a given radius from the origin. |
| `FindByName(targetname, start_ent)` | Finds an entity with the specified targetname, optionally starting the search from a given entity. |
| `FindByNameWithin(targetname, origin, radius, start_ent)` | Finds an entity with the specified targetname within a given radius from the origin. |
| `FindByModel(model, start_ent)` | Finds an entity with the specified model, optionally starting the search from a given entity. |
| `FindByModelWithin(model, origin, radius, start_ent)` | Finds an entity with the specified model within a given radius from the origin. |
| `FindInSphere(origin, radius, start_ent)` | Finds entities within a sphere defined by the origin and radius. |

### [`IDT/list.nut`](SRC/IDT/list.nut)

This file defines the `List` class, which represents a doubly linked list and provides methods for adding and removing elements, accessing elements by index, reversing the list, and converting the list to an array.

| Method | Description |
| ---------------------- | ---------------------------------------------------------------------------------------------------------------------- |
| `List(...)` | Creates a new `List` object with optional initial elements. |
| `fromArray(array)` | Creates a new `List` object from an existing array. |
| `len()` | Returns the number of elements in the list. |
| `append(value)` | Appends a value to the end of the list. |
| `insert(index, value)` | Inserts a value at the specified index in the list. |
| `getNode(index)` | Gets the node at the specified index in the list. Throws an error if the index is out of bounds. |
| `get(index, default)` | Gets the value at the specified index in the list, or a default value if the index is out of bounds. |
| `remove(index)` | Removes the node at the specified index from the list. |
| `pop()` | Removes and returns the last element of the list. |
| `top()` | Returns the value of the last element in the list. |
| `reverse()` | Reverses the order of elements in the list in-place. |
| `clear()` | Removes all elements from the list. |
| `join(separator)` | Joins the elements of the list into a string, separated by the specified separator. |
| `apply(func)` | Applies a function to each element of the list and modifies the list in-place. |
| `extend(other)` | Appends all elements from another iterable to the end of the list. |
| `search(value or func)` | Searches for a value or a matching element in the list using a predicate function and returns its index. |
| `map(func)` | Creates a new `List` by applying a function to each element of this list. |
| `toarray()` | Converts the list to an array. |

### [`IDT/tree_sort.nut`](SRC/IDT/tree_sort.nut)

This file defines the `AVLTree` class, which represents a self-balancing binary search tree (AVL tree). It provides methods for inserting and removing nodes, searching for nodes, and traversing the tree in different orders.

| Method | Description |
| ----------------------- | ------------------------------------------------------------------------------------------------------------------------------ |
| `AVLTree(...)` | Creates a new `AVLTree` object with optional initial elements. |
| `fromArray(array)` | Creates a new `AVLTree` object from an existing array. |
| `len()` | Returns the number of nodes in the tree. |
| `toArray()` | Converts the tree to an array using inorder traversal (ascending order). |
| `tolist()` | Converts the tree to a list using inorder traversal (ascending order). |
| `insert(key)` | Inserts a new node with the given key into the tree. |
| `search(value)` | Searches for a node with the given value in the tree and returns the node if found. |
| `remove(value)` | Removes the node with the given value from the tree. |
| `GetMin()` | Returns the minimum value in the tree. |
| `GetMax()` | Returns the maximum value in the tree. |
| `inorderTraversal()` | Performs an inorder traversal of the tree and returns an array of nodes in ascending order. |
| `printTree()` | Prints a visual representation of the tree structure to the console. |

### [More info about *IDT module* here](SRC/IDT/readme.md)

## 3. [Utils](SRC/Utils/readme.md)

The `Utils` module provides various utility functions for script execution, debugging, file operations, and working with entities.

### [`Utils/debug.nut`](SRC/Utils/debug.nut)

This file contains functions for debugging and logging messages, including drawing bounding boxes, logging messages with different severity levels, and formatting messages.

| Function | Description |
| ---------------------------------------- | ------------------------------------------------------------------------------------------------------------ |
| `dev.DrawEntityBBox(ent, time)` | Draws the bounding box of an entity for the specified time. |
| `dev.drawbox(vector, color, time)` | Draws a box at the specified vector position for the specified time. |
| `dev.debug(msg)` | Logs a debug message to the console if debug logging is enabled. |
| `dev.log(msg)` | Logs a message to the console only if developer mode is enabled. |
| `dev.warning(msg)` | Displays a warning message in a specific format, including function name, source file, and line number. |
| `dev.error(msg)` | Displays an error message in a specific format, including function name, source file, and line number. |
| `dev.format(msg, ...)` | Formats a message string with placeholders and substitutes values from the provided arguments. |
| `dev.fprint(msg, ...)` | Formats a message string and prints it to the console using `printl`. |

### [`Utils/file.nut`](SRC/Utils/file.nut)

This file defines the `File` class, which provides methods for reading from and writing to files.

| Method | Description |
| ---------------------- | --------------------------------------------------------------------------- |
| `File(path)` | Creates a new `File` object for the specified file path. |
| `write(text)` | Appends text to the end of the file. |
| `readlines()` | Reads all lines from the file and returns them as an array of strings. |
| `read()` | Reads the entire contents of the file and returns it as a single string. |
| `clear()` | Clears the contents of the file. |

### [`Utils/improvements.nut`](SRC/Utils/improvements.nut)

This file contains functions that override and improve existing VScripts functions, such as `FrameTime` and `EntFireByHandle`, to provide additional functionality or prevent potential issues.

| Function | Description |
| --------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `FrameTime()` | Returns the current frame time, ensuring it is never zero by returning a small default value if necessary. |
| `UniqueString(prefix)` | Generates a unique string with the specified prefix. |
| `EntFireByHandle(target, action, value, delay, activator, caller)` | Triggers an entity's input with optional delay, activator, and caller, handling `pcapEntity` objects and extracting the underlying `CBaseEntity` objects. |
| `GetPlayerEx(index)` | Retrieves a player entity with extended functionality as a `pcapEntity` object. |
| `GetPlayers()` | Returns an array of all players in the game as `pcapEntity` objects. |
| `AttachEyeControlToPlayers()` | Attaches eye control entities to all players in the game to track their eye position and angles. |

### [`Utils/macros.nut`](SRC/Utils/macros.nut)

This file contains various macro functions that provide shortcuts for common operations, such as precaching sounds, retrieving values from tables, printing iterable objects, calculating distances, converting between strings and vectors, and getting entity name prefixes and postfixes.

| Macro | Description |
| ---------------------- | ------------------------------------------------------------------------------------------------------- |
| `macros.Precache(soundPath)` | Precaches a sound script or a list of sound scripts for later use. |
| `macros.GetFromTable(table, key, defaultValue)` | Gets a value from a table, returning a default value if the key is not found. |
| `macros.PrintIter(iterable)` | Prints the keys and values of an iterable object to the console. |
| `macros.GetDist(vec1, vec2)` | Calculates the distance between two vectors. |
| `macros.StrToVec(str)` | Converts a string representation of a vector (e.g., "x y z") to a `Vector` object. |
| `macros.VecToStr(vec)` | Converts a `Vector` object to a string representation (e.g., "x y z"). |
| `macros.isEqually(val1, val2)` | Checks if two values are equal, handling different data types. |
| `macros.GetPrefix(name)` | Gets the prefix of an entity name, or the original name if no "-" is found. |
| `macros.GetPostfix(name)` | Gets the postfix of an entity name, or the original name if no "-" is found. |
| `macros.GetEyeEndpos(player, distance)` | Calculates the end position of a ray cast from the player's eyes based on the given distance. |
| `macros.GetVertex(VecX, VecY, VecZ, angle)` | Gets one vertex of the bounding box based on x, y, z bounds. |
| `macros.GetTriangle(Vec1, Vec2, Vec3)` | Creates a triangle representation from three vertices. |

### [`Utils/scripts.nut`](SRC/Utils/scripts.nut)

This file provides functions for running scripts with delays, loops, and intervals.

| Function | Description |
| ------------------------------ | ----------------------------------------------------------------------------------------------------------------------- |
| `RunScriptCode.delay(script, runDelay, activator, caller, args)` | Creates a delay before executing the specified script, optionally specifying activator, caller, and arguments. |
| `RunScriptCode.loopy(script, runDelay, loopCount, outputs)` | Executes a function repeatedly with a specified delay for a given number of loops. |
| `RunScriptCode.setInterval(script, interval, runDelay, eventName)` | Schedules the execution of a script recursively at a fixed interval. |
| `RunScriptCode.fromStr(str)` | Executes a script from a string. |

### [`Utils/consts.nut`](SRC/Utils/consts.nut)
This file contains constants that define the different types of collisions and object physics in Source Engine.

#### Collision Groups

| Constant | Description |
| ---------------------------- | ------------------------------------------------------------- |
| `COLLISION_GROUP_NONE` | Collides with nothing (0). |
| `COLLISION_GROUP_DEBRIS` | Small, non-gameplay-interfering objects (1). |
| `COLLISION_GROUP_DEBRIS_TRIGGER` | Like `DEBRIS`, but ignores `PUSHAWAY` (2). |
| `COLLISION_GROUP_INTERACTIVE_DEBRIS` | Like `DEBRIS`, but doesn't collide with the same group (3). |
| `COLLISION_GROUP_INTERACTIVE` | Interactive entities, ignores debris (4). |
| `COLLISION_GROUP_PLAYER` | Used by players, ignores `PASSABLE_DOOR` (5). |
| `COLLISION_GROUP_BREAKABLE_GLASS` | Breakable glass, ignores the same group and NPC line-of-sight (6). |
| `COLLISION_GROUP_VEHICLE` | Driveable vehicles, always collides with `VEHICLE_CLIP` (7). |
| `COLLISION_GROUP_PLAYER_MOVEMENT` | Player movement collision (8). |
| `COLLISION_GROUP_NPC` | Used by NPCs, always collides with `DOOR_BLOCKER` (9). |
| `COLLISION_GROUP_IN_VEHICLE` | Entities inside vehicles, no collisions (10). |
| `COLLISION_GROUP_WEAPON` | Weapons, including dropped ones (11). |
| `COLLISION_GROUP_VEHICLE_CLIP` | Only collides with `VEHICLE` (12). |
| `COLLISION_GROUP_PROJECTILE` | Projectiles, ignore other projectiles (13). |
| `COLLISION_GROUP_DOOR_BLOCKER` | Blocks NPCs, may collide with some projectiles (14). |
| `COLLISION_GROUP_PASSABLE_DOOR` | Passable doors, allows players through (15). |
| `COLLISION_GROUP_DISSOLVING` | Dissolved entities, only collide with `NONE` (16). |
| `COLLISION_GROUP_PUSHAWAY` | Pushes props away from the player (17). |
| `COLLISION_GROUP_NPC_ACTOR` | NPCs potentially stuck in a player (18). |
| `COLLISION_GROUP_NPC_SCRIPTED` | NPCs in scripted sequences with collisions disabled (19). |

#### Solid Types

| Constant | Description |
| --------------- | ------------------------------------------------------------ |
| `SOLID_NONE` | No collision at all (0). |
| `SOLID_BSP` | Uses Quake Physics engine (1). |
| `SOLID_VPHYSICS` | Uses an axis-aligned bounding box (AABB) for collision (2). |
| `SOLID_OBB` | Uses an oriented bounding box (OBB) for collision (3). |
| `SOLID_OBB_YAW` | Uses an OBB constrained to yaw rotation (4). |
| `SOLID_CUSTOM` | Custom/test solid type (5). |
| `SOLID_VPHYSICS`| Uses VPhysics engine for realistic physics (6). |

### [More info about *Utils module* here](SRC/Utils/readme.md)

## 4. [TracePlus](SRC/TracePlus/readme.md)

The `TracePlus` module provides advanced ray tracing capabilities, including portal support and more precise algorithms.

### [`TracePlus/init.nut`](SRC/TracePlus/init.nut)

This file initializes the `TracePlus` module and includes the necessary script files for the module's functionality.

### [`TracePlus/results.nut`](SRC/TracePlus/results.nut)

This file defines the `CheapTraceResult` and `BboxTraceResult` classes, which represent the results of cheap traces and bbox casts, respectively. These classes provide methods for retrieving information about the trace, such as the start and end positions, hit position, hit entity, impact normal, and portal entry information.

| Class | Description |
| --------------------- | ----------------------------------------------------------------------------------------------------------------------------------- |
| `CheapTraceResult` | Represents the result of a cheap (fast but less accurate) trace. |
| `BboxTraceResult` | Represents the result of a bbox cast (trace with a bounding box). |

### [`TracePlus/settings.nut`](SRC/TracePlus/settings.nut)

This file defines the `TracePlus.Settings` class, which encapsulates settings for ray traces, including lists of entities and models to ignore or prioritize, error tolerance, and custom filter functions for determining collision and ignore behavior.

| Method | Description |
| ------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `TracePlus.Settings.new(settingsTable)` | Creates a new `TracePlus.Settings` object with default values or from a table of settings. |
| `SetIgnoredClasses(ignoreClassesArray)` | Sets the list of entity classnames to ignore during traces. |
| `SetPriorityClasses(priorityClassesArray)` | Sets the list of entity classnames to prioritize during traces. |
| `SetIgnoredModels(ignoredModelsArray)` | Sets the list of entity model names to ignore during traces. |
| `SetErrorTolerance(tolerance)` | Sets the maximum allowed distance between trace start and hit positions. |
| `AppendIgnoredClass(className)` | Appends an entity classname to the list of ignored classes. |
| `AppendPriorityClasses(className)` | Appends an entity classname to the list of priority classes. |
| `AppendIgnoredModel(modelName)` | Appends an entity model name to the list of ignored models. |
| `GetIgnoreClasses()` | Returns the list of entity classnames to ignore during traces. |
| `GetPriorityClasses()` | Returns the list of entity classnames to prioritize during traces. |
| `GetIgnoredModels()` | Returns the list of entity model names to ignore during traces. |
| `GetErrorTolerance()` | Returns the maximum allowed distance between trace start and hit positions. |
| `SetCollisionFilter(filterFunction)` | Sets a custom function to determine if a ray should hit an entity. |
| `SetIgnoreFilter(filterFunction)` | Sets a custom function to determine if an entity should be ignored during a trace. |
| `GetCollisionFilter()` | Returns the custom collision filter function. |
| `GetIgnoreFilter()` | Returns the custom ignore filter function. |
| `ApplyCollisionFilter(entity, note)` | Applies the custom collision filter function to an entity. |
| `ApplyIgnoreFilter(entity, note)` | Applies the custom ignore filter function to an entity. |
| `UpdateIgnoreEntities(ignoreEntities, newEnt)`| Updates the list of entities to ignore during a trace, including the player entity. |

### [`TracePlus/cheap_trace.nut`](SRC/TracePlus/cheap_trace.nut)

This file provides functions for performing cheap (fast but less accurate) traces, including traces with portal support and traces from the player's eyes.

| Function | Description |
| ---------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------- |
| `TracePlus.Cheap(startPos, endPos)` | Performs a cheap trace from the specified start and end positions. |
| `TracePlus.FromEyes.Cheap(distance, player)` | Performs a cheap trace from the player's eyes. |
| `TracePlus.FromEyes.PortalCheap(distance, player)` | Performs a cheap trace with portal support from the player's eyes. |

### [`TracePlus/bboxcast.nut`](SRC/TracePlus/bboxcast.nut)

This file provides functions for performing bbox casts (traces with bounding boxes), including casts with portal support and casts from the player's eyes.

| Function | Description |
| -------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------- |
| `TracePlus.Bbox(startPos, endPos, ignoreEntities, settings, note)` | Performs a bbox cast from the specified start and end positions, optionally ignoring entities and using custom settings and note. |
| `TracePlus.FromEyes.Bbox(distance, player, ignoreEntities, settings)` | Performs a bbox cast from the player's eyes. |
| `TracePlus.FromEyes.PortalBbox(distance, player, ignoreEntities, settings)` | Performs a bbox cast with portal support from the player's eyes. |

### [`TracePlus/portal_casting.nut`](SRC/TracePlus/portal_casting.nut)

This file contains functions for handling portal interactions during traces, including calculating new trace positions after passing through portals and finding partner portals for linked portal doors and prop portals.

| Function | Description |
| ------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `TracePlus.PortalCheap(startPos, endPos)` | Performs a cheap trace with portal support. |
| `TracePlus.PortalBbox(startPos, endPos, ignoreEntities, settings, note)` | Performs a bbox cast with portal support. |
| `FindPartnersForPortals()` | Finds and sets partner portals for linked portal doors and prop portals. |

### [More info about *TracePlus module* here](SRC/TracePlus/readme.md)


## 5. [ActionScheduler](SRC/ActionScheduler/readme.md)

The `ActionScheduler` module provides an enhanced system for creating and managing scheduled events in VScripts, offering more flexibility and control compared to standard mechanisms like `EntFireByHandle`. It allows you to create complex sequences of actions, schedule them with precise timing, and cancel them as needed.

### [`ActionScheduler/event.nut`](SRC/ActionScheduler/event.nut)

This file defines the `ScheduleAction` class, which represents a single action scheduled for execution at a specific time.

| Method | Description |
| --------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------- |
| `ScheduleEvent(caller, action, timeDelay, note, args)` | Creates a new `ScheduleEvent` object with the specified caller, action, execution time, optional note, and arguments. |
| `run()` | Executes the scheduled action, compiling it if necessary and passing any provided arguments. Returns the result of the action function. |

### [`ActionScheduler/action_scheduler.nut`](SRC/ActionScheduler/action_scheduler.nut)

This file provides functions for creating and managing scheduled events, including adding actions, creating intervals, and canceling events.

| Function | Description |
| -------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `ScheduleEvent.Add(eventName, action, timeDelay, args, note)`  | Adds a single action to a scheduled event with the specified name. If the event does not exist, it is created.                                                                                                                     |
| `ScheduleEvent.AddActions(eventName, actions, noSort)`      | Adds multiple actions to a scheduled event, ensuring they are sorted by execution time.                                                                                                                                                 |
| `ScheduleEvent.AddInterval(eventName, action, interval, initialDelay, args, note)` | Adds an action to a scheduled event that will be executed repeatedly at a fixed interval.                                                                                                                                               |
| `ScheduleEvent.Cancel(eventName, delay)`       | Cancels all scheduled actions within an event with the given name.                                                                                                                                                                    |
| `ScheduleEvent.CancelByAction(action, delay)` | Cancels all scheduled actions that match the given action.                                                                                                                                                                         | 
| `ScheduleEvent.CancelAll()`                  | Cancels all scheduled events and actions, effectively clearing the event scheduler.                                                                                                                                                         |
| `ScheduleEvent.GetEvent(eventName)`           | Retrieves a scheduled event by name as a `List` of `ScheduleAction` objects.                                                                                                                                                           |
| `ScheduleEvent.IsValid(eventName)`            | Checks if a scheduled event with the given name exists and has scheduled actions.                                                                                                                                                |
| `ScheduleEvent.GetNote(eventName)`            | Retrieves the note associated with the first scheduled action within the event with the given name.                                                                                                                                      | 

### [`ActionScheduler/event_handler.nut`](SRC/ActionScheduler/event_handler.nut)

This file contains the `ExecuteScheduledEvents` function, which processes scheduled events and actions.

| Function | Description |
| -------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `ExecuteScheduledEvents()` | Iterates over all scheduled events and checks if the execution time for the first action in each event has arrived. If so, it executes the action and removes it from the event's list of actions. If an event has no more actions remaining, it is removed from the list of scheduled events. The function then schedules itself to run again after a short delay to continue processing events. | 

### [More info about *ActionScheduler module* here](SRC/ActionScheduler/readme.md) 

## 6. [Animations](SRC/Animations/readme.md)

The `Animations` module provides functions for creating animations related to alpha (opacity), color, and object movement.

### [`Animations/init.nut`](SRC/Animations/init.nut)

This file initializes the `Animations` module, defines the `AnimEvent` class for managing animation events, and includes the necessary script files for the module's functionality.

### [`Animations/alpha.nut`](SRC/Animations/alpha.nut)

This file provides the `animate.AlphaTransition` function for creating animations that transition the alpha (opacity) of entities over time.

| Function | Description |
| ------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------ |
| `animate.AlphaTransition(entities, startOpacity, endOpacity, time, animSetting)` | Creates an animation that smoothly transitions the alpha (opacity) of entities from the starting value to the ending value over a specified time. |

### [`Animations/color.nut`](SRC/Animations/color.nut)

This file provides the `animate.ColorTransition` function for creating animations that transition the color of entities over time.

| Function | Description |
| ------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------ |
| `animate.ColorTransition(entities, startColor, endColor, time, animSetting)` | Creates an animation that smoothly transitions the color of entities from the starting color to the ending color over a specified time. |

### [`Animations/position.nut`](SRC/Animations/position.nut)

This file provides the `animate.PositionTransitionByTime` function for creating animations that transition the position of entities over time.

| Function | Description |
| ------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------- |
| `animate.PositionTransitionByTime(entities, startPos, endPos, time, animSetting)` | Creates an animation that moves entities from the starting position to the ending position over a specified time based on increments of time. |
| `animate.PositionTransitionBySpeed(entities, startPos, endPos, speed, animSetting)` | Creates an animation that transitions the position of entities over time based on a specified speed.  |

### [`Animations/angles.nut`](SRC/Animations/angles.nut)

This file provides the `animate.AnglesTransitionByTime` function for creating animations that transition the angles of entities over time.

| Function | Description |
| ------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------- |
| `animate.AnglesTransitionByTime(entities, startAngles, endAngles, time, animSetting)` | Creates an animation that changes the angles of entities from the starting angles to the ending angles over a specified time. |

### [More info about *Animations module* here](SRC/Animations/readme.md)

## 7. [GameEvents](SRC/GameActionScheduler/readme.md)

The `GameEvents` module provides classes for creating and handling custom game events with triggers, filters, and actions. It offers more flexibility than standard VScripts game events.

### [`GameActionScheduler/init.nut`](SRC/GameActionScheduler/init.nut)

This file initializes the `GameEvents` module and includes the necessary script files for the module's functionality.

### [`GameActionScheduler/game_event.nut`](SRC/GameActionScheduler/game_event.nut)

This file defines the `GameEvent` class, which represents a custom game event with a name, trigger count, action to perform when triggered, and optional filter function.

| Method | Description |
| ---------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `GameEvent(eventName, triggerCount, action)` | Creates a new `GameEvent` object with the specified name, trigger count (number of times it can be triggered before becoming inactive, -1 for unlimited triggers), and action to perform when triggered. |
| `SetAction(actionFunction)` | Sets the action function for the event, which will be executed when the event is triggered. |
| `SetFilter(filterFunction)` | Sets the filter function for the event, which should return true if the event should be triggered and false otherwise. This allows for conditional triggering of the event based on custom criteria. |
| `Trigger(args)` | Triggers the event if the trigger count allows and the filter function (if set) returns true. The action function is executed with the provided arguments, and a VScript event message is logged if event logging is enabled. |
| `ForceTrigger(args)` | Forces the event to trigger, ignoring the filter function and trigger count. The action function is executed with the provided arguments. |

### [`GameActionScheduler/event_listener.nut`](SRC/GameActionScheduler/event_listener.nut)

This file defines the `EventListener` object, which listens for and handles custom game events created using the `GameEvent` class.

| Function | Description |
| --------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------- |
| `Notify(eventName, args)` | Notifies the listener of a triggered event and calls the event's `Trigger` method with the provided arguments. Returns the result of the event's action or `null` if the event is not found or the filter fails. |
| `GetEvent(EventName)` | Retrieves a `GameEvent` object by name. Returns `null` if the event is not found. |

### [More info about *GameEvents module* here](SRC/GameActionScheduler/readme.md)

## 8. [HUD](SRC/HUD/readme.md)

The `HUD` module provides classes for displaying text and hints on the screen using in-game entities.

### [`HUD/init.nut`](SRC/HUD/init.nut)

This file initializes the `HUD` module and includes the necessary script files for the module's functionality.

### [`HUD/game_text.nut`](SRC/HUD/game_text.nut)

This file defines the `HUD.ScreenText` class, which allows you to create and manage on-screen text displays using the "game_text" entity.

| Method | Description |
| ------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `ScreenText(position, message, holdtime, targetname)` | Creates a new `ScreenText` object at the specified position with the given message, hold time, and optional targetname. |
| `Enable()` | Displays the on-screen text. |
| `Disable()` | Hides the on-screen text. |
| `Update()` | Updates and redisplays the on-screen text. |
| `SetText(message)` | Changes the message of the text display and redisplays it. |
| `SetChannel(channel)` | Sets the channel of the text display. |
| `SetColor(color)` | Sets the primary color of the text display as a string. |
| `SetColor2(color)` | Sets the secondary color of the text display as a string. |
| `SetEffect(index)` | Sets the effect of the text display. |
| `SetFadeIn(value)` | Sets the fade-in time of the text display in seconds. |
| `SetFadeOut(value)` | Sets the fade-out time of the text display in seconds. |
| `SetHoldTime(time)` | Sets the hold time (duration) of the text display. |
| `SetPos(position)` | Sets the position of the text display. |

### [`HUD/hint_instructor.nut`](SRC/HUD/hint_instructor.nut)

This file defines the `HUD.HintInstructor` class, which allows you to create and manage hints using the "env_instructor_hint" entity.

| Method | Description |
| --------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `HintInstructor(message, holdtime, icon, showOnHud, targetname)` | Creates a new `HintInstructor` object with the specified message, hold time, icon, display location (HUD or target entity), and optional targetname. |
| `Enable()` | Displays the hint. |
| `Disable()` | Hides the hint. |
| `Update()` | Updates and redisplays the hint. |
| `SetText(message)` | Changes the message of the hint and redisplays it. |
| `SetBind(bind)` | Sets the bind to display with the hint icon and updates the icon to "use_binding". |
| `SetPositioning(value, entity)` | Sets the positioning of the hint, either on the HUD or at the target entity's position. |
| `SetColor(color)` | Sets the color of the hint text as a string. |
| `SetIconOnScreen(icon)` | Sets the icon to display when the hint is on-screen. |
| `SetIconOffScreen(icon)` | Sets the icon to display when the hint is off-screen. |
| `SetHoldTime(time)` | Sets the hold time (duration) of the hint. |
| `SetDistance(distance)` | Sets the distance at which the hint is visible. |
| `SetEffects(sizePulsing, alphaPulsing, shaking)` | Sets the visual effects for the hint, including size pulsing, alpha pulsing, and shaking. |

### [More info about *HUD module* here](SRC/HUD/readme.md)
