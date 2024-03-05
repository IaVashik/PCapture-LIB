# PCapture VScripts Library documentation
This library consists of several modules that can be extremely useful for you

## 1. [`PCapture-Lib`](/SRC/PCapture-Lib.nut)

The main file in the library. Initializes required parts of the library


## 2. [`PCapture-Utils`](/SRC/PCapture-Utils.nut)

A collection of utility functions for script execution and debugging. It's a Swiss army knife for developers working with Squirrel :D

### RunScriptCode

`RunScriptCode` provides utility functions for executing scripts.

| Name | Usage | Description |
|-|-|-|  
| delay | void RunScriptCode::delay(string&#124;func script, float fireDelay, Ent activator = null, Ent caller = null) | Creates a delay before executing the specified script. |
| setInterval | void RunScriptCode::setInterval(string&#124;func script, float interval = tick, float globalDelay = 0, string eventName = "global") | Schedules the execution of a script recursively at a fixed interval. |
| loopy | void RunScriptCode::loopy(string&#124;func func, float fireDelay, int loop, string&#124;func outputs = null) | Runs func repeatedly for given loops. |
| fromStr | void RunScriptCode::fromStr(string script) | Executes a script from a string. |


### dev 

`dev` provides developer utility functions. 
| Name | Usage | Description |
|-|-|-|
| DrawEntityBBox | void dev::DrawEntityBBox(Ent entity, float time) | Draws the bounding box of an entity. |
| drawbox | void dev::drawbox(Vector origin, Vector color, float time = 0.05) | Draws a box at the specified position. |
| log | void dev::log(string msg) | Logs a message if developer mode is enabled. |
| warning | void dev::warning(string msg) | Displays a warning message if developer mode is enabled. |
| error | void dev::error(string msg) | Displays an error message if developer mode is enabled. |


### Other Functions

Other utility functions.
| Name | Usage | Description |
|-|-|-|
| fprint | void fprint(string msg, any vargs...) | Prints a formatted message to the console. |
| StrToVec | Vector StrToVec(string value) | Converts a string to a Vector. *Example: "255 31 10" -> Vector(255, 31, 10)* |
| GetPrefix | void GetPrefix(string&#124;CBaseEntity name) | Gets the prefix of an entity name. |
| GetPostfix | string GetPostfix(string&#124;CBaseEntity name) | Gets the postfix of an entity name. |
| Precache | string Precache(string&#124;array&#124;arrayLib sound_path) | Precaches a sound |

#### [More info about *PCapture-Utils* here](Utils_module.md)

## 3. [`PCapture-Entities`](/SRC/PCapture-Entities.nut)

Improved Entities Module. Contains A VERY LARGE number of different functions that you just missed later!

| Name | Usage | Description |
|-|-|-|
| CreateByClassname | pcapEntity entLib::CreateByClassname(string classname, table keyvalues = null) | Creates an entity of the specified classname with provided keyvalues |
| FindByClassname | pcapEntity entLib::FindByClassname(string classname, CBaseEntity&#124;pcapEntity start_ent = null) | Finds an entity by classname starting search from given entity |  
| FindByClassnameWithin | pcapEntity entLib::FindByClassnameWithin(string classname, Vector origin, int radius, CBaseEntity&#124;pcapEntity start_ent = null) | Finds an entity by classname within given radius of a point |
| FindByName | pcapEntity entLib::FindByName(string targetname, CBaseEntity&#124;pcapEntity start_ent = null) | Finds an entity by targetname starting search from given entity |
| FindByNameWithin | pcapEntity entLib::FindByNameWithin(string targetname, Vector origin, int radius, CBaseEntity&#124;pcapEntity start_ent = null) | Finds an entity by targetname within given radius of a point |
| FindByModel | pcapEntity entLib::FindByModel(string model, CBaseEntity&#124;pcapEntity start_ent = null) | Finds an entity by model starting search from given entity |
| FindByModelWithin | pcapEntity entLib::FindByModelWithin(string model, Vector origin, int radius, CBaseEntity&#124;pcapEntity start_ent = null) | Finds an entity by model within given radius of a point |  
| FindInSphere | pcapEntity entLib::FindInSphere(Vector origin, int radius, CBaseEntity&#124;pcapEntity start_ent = null) | Finds entities within sphere of given radius from point |
| FromEntity | pcapEntity entLib::FromEntity(CBaseEntity entity) | Creates pcapEntity object from given CBaseEntity |
| SetAbsAngles | void pcapEntity::SetAbsAngles(Vector vector) | Sets absolute rotation angles of the entity |
| Destroy | void pcapEntity::Destroy() | Destroys the entity |
| Kill | void pcapEntity::Kill(int fireDelay = 0) | Kills the entity with delay |
| Dissolve | void pcapEntity::Dissolve() | Dissolve the entity |
| IsValid | bool pcapEntity::IsValUtilsid() | Checks if the entity is valid |
| IsPlayer | bool pcapEntity::IsPlayer() | Checks if the entity is the player |
| EyePosition | Vector pcapEntity::EyePosition() | Gets the eye position of the player entity.                           |
| EyeAngles   | Vector pcapEntity::EyeAngles() | Gets the eye angles of the player entity.                             |
| EyeForwardVector | Vector pcapEntity::EyeForwardVector() | Gets the forward vector from the player entity's eye position.        |
| SetKeyValue | void pcapEntity::SetKeyValue(string key, any value) | Sets a keyvalue of the entity |
| addOutput | void pcapEntity::addOutput(string output, string target, string input, string param = "", int delay = 0, int fires = -1) | Sets a outputs of the entity |
| ConnectOutputEx | void pcapEntity::ConnectOutputEx(string&#124;function output, string script, int delay = 0, int fires = -1) | TODO |
| SetName | void pcapEntity::SetName(string name) | Sets name (targetname) of the entity |  
| SetUniqueName | void pcapEntity::SetUniqueName(string preifx = "") | Sets unique name (targetname) of the entity |  
| SetParent | void pcapEntity::SetParent(string name, string&#124;CBaseEntity&#124;pcapEntity parent, int fireDelay = 0) | Sets parent entity |
| SetCollision | void pcapEntity::SetCollision(int solid, int fireDelay = 0) | Sets collision type of the entity |
| SetCollisionGroup | void pcapEntity::SetCollisionGroup(int collisionGroup) | Sets collision group of the entity |
| SetAnimation | void pcapEntity::SetAnimation(string animationName, int fireDelay = 0) | Start playing animation of the entity |
| SetAlpha | void pcapEntity::SetAlpha(int opacity, int fireDelay = 0) | Sets opacity of the entity |
| SetColor | void pcapEntity::SetColor(Vector&#124;string colorValue, int fireDelay = 0) | Sets color of the entity |
| SetSkin | void pcapEntity::SetSkin(int skin, int fireDelay = 0) | Sets the skin of the entity |
| SetDrawEnabled | void pcapEntity::SetDrawEnabled(bool isEnabled, int fireDelay = 0) | Enables/Disables rendering of the entity |
| SetSpawnflags | void pcapEntity::SetSpawnflags(int flag) | Sets spawnflags of the entity |
| SetModelScale | void pcapEntity::SetModelScale(int scaleValue, int fireDelay = 0) | Sets model scale of the entity |
| SetCenter | void pcapEntity::SetCenter(Vector vector) | Sets center of the entity |
| SetBBox | void pcapEntity::SetBBox(Vector|string min, Vector|string max) | Sets bounding box of the entity |
| SetUserData | void pcapEntity::SetUserData(string name, any value) | Stores arbitrary value associated with the entity |
| GetUserData | any pcapEntity::GetUserData(string name) | Gets stored value by name |
| GetBBox | table pcapEntity::GetBBox() | Returns bounding box of the entity |
| GetAABB | table pcapEntity::GetAABB() | Returns oriented bounding box of the entity |
| GetIndex | int pcapEntity::GetIndex() | Returns index of the entity |
| GetKeyValue | any pcapEntity::GetKeyValue(string key) | Returns keyvalue of the entity |
| GetSpawnflags | int&#124;null pcapEntity::GetSpawnflags() | Returns spawnflags of the entity, if such information is available |
| GetAlpha | int&#124;null pcapEntity::GetAlpha() | Returns opacity of the entity, if such information is available |
| GetColor | string&#124;null pcapEntity::GetColor() | Returns color of the entity, if such information is available |
| GetNamePrefix | string pcapEntity::GetNamePrefix() | Returns name prefix of the entity, if such information is available |
| GetNamePostfix | string pcapEntity::GetNamePostfix() | Returns name postfix of the entity |
| CreateAABB | Vector pcapEntity::CreateAABB(int stat) | Returns AABB face of the entity |
| getBBoxPoints | Array<Vector> pcapEntity::getBBoxPoints() | Returns AABB vertices of the entity |

#### [More info about *PCapture-Entities* here](Entities_module.md)

## 4. [`PCapture-Math`](/SRC/PCapture-Math.nut)  

Mathematical module. Contains many different functions including lerp functions, quaternions and more

### Quaternions object

| Name | Usage | Description |
|-|-|-|
| new | Quaternion math::Quaternion::new(Vector angles) | Creates quaternion from Euler angles |
| rotate | Vector math::Quaternion::rotate(Vector angle) | Rotates vector by quaternion |
| unrotate | Vector math::Quaternion::unrotate(Vector angle) | Un-rotates vector by quaternion |
| slerp | Quaternion math::Quaternion::slerp(Quaternion target, float t) | Spherical linear interpolation between quaternions |
| Norm | Quaternion math::Quaternion::Norm() | Returns normalized quaternion |
| toVector | Vector math::Quaternion::toVector() | Converts quaternion to Euler angles |
| IsValid | bool math::Quaternion::IsValid() | Check if quaternion is valid |
| get_table | table math::Quaternion::get_table() | Get quaternion as table |

### lerp functions

| Name | Usage | Description |
|-|-|-|
| lerp.int | int math::lerp::int(int start, int end, float t) | Integer linear interpolation |
| lerp.vector | Vector math::lerp::vector(Vector start, Vector end, float t) | Vector linear interpolation |
| lerp.color | string math::lerp::color(Vector&#124;string start, Vector&#124;string end, float t) | Color linear interpolation |  
| lerp.sVector | Vector math::lerp::sVector(Vector start, Vector end, float t) | Vector spherical interpolation |

### Others math functions

| Name | Usage | Description |
|-|-|-|
| min | int&#124;float math::min(int&#124;float vargs) | Returns the minimum value |
| max | int&#124;float math::max(int&#124;float vargs) | Returns the maximum value |
| clamp | int&#124;float math::clamp(int&#124;float int, int&#124;float min, int&#124;float max) | Clamp integer within range |
| roundVector | Vector math::roundVector(Vector vec, int precision) | Round vector to precision |
| Sign | int math::Sign(int&#124;float x) | Get sign of number |
| copysign | int&#124;float math::copysign(int&#124;float value, int&#124;float sign) | Copy sign of value |
| RemapVal | Vector math::RemapVal(float value, float low1, float high1, float low2, float high2) | Remaps a value from the range [A, B] to the range [C, D].
| rotateVector | Vector math::rotateVector(Vector vector, Vector angle) | Rotate vector by quaternion |
| unrotateVector | Vector math::unrotateVector(Vector vector, Vector angle) | Un-rotate vector by quaternion |
| randomVector | Vector math::randomVector(int min, int max) | Returns a randomized vector in the min to max range |
| reflectVector | Vector math::reflectVector(Vector dir, Vector normal) | Returns a reflection vector |
| clampVector | Vector math::clampVector(Vector dir, int min = 0, int max = 255) | Clamp vector within range |

#### [More info about *PCapture-Math* here](Math_module.md)

## 5. [`PCapture-EventHandler`](/SRC/PCapture-EventHandler.nut)  

Improved EntFire/logic_relay/loop module. Allows you to create whole events from many different events and cancel them at any time, unlike EntFireByHandler. Able to take not only string, but also full-fledged functions:

| Name | Usage | Description |
|-|-|-|
| CreateScheduleEvent | void CreateScheduleEvent(string eventName, string&#124;function action, float timeDelay, string note = null) | Creates a scheduled event |
| cancelScheduledEvent | void cancelScheduledEvent(string eventName, float delay = 0) | Cancels a scheduled event |
| getEventInfo | table&#124;null getEventInfo(string eventName) | Gets info for scheduled event |
| eventIsValid | bool eventIsValid(string eventName) | Checks if event is valid |
| getEventNote | any getEventNote(string eventName) | Returns the nearest note of the event if it exists |

#### [More info about *PCapture-EventHandler* here](EventHandler_module.md)

## 6. [`PCapture-Array`](/SRC/PCapture-Arrays.nut ) 

Improved arrays module. Contains easy output in the console and additional features to simplify life:

| Name | Usage | Description |
|-|-|-|
| arrayLib | class arrayLib | Enhanced arrays module |
| constructor | void constructor(array = []) | Constructor. Initializes the array with the provided initial array. |
| new | arrayLib new(...vargc) | Create a new arrayLib instance from arguments. Returns the new arrayLib instance. |
| append | int append(any val) | Append a value to the array. Returns the new array length. |
| apply | void apply(Function func) | Apply a function to each element of the array. |
| clear | void clear() | Clear the array and table. |
| extend | void extend(array other) | Extend the array with another array. |
| filter | arrayLib filter(Function func) | Filter the array by a predicate function. Returns the filtered array. |
| find | bool find(any match) | Check if the array contains a value. Returns whether the value is found. |
| search | int&#124;null search(any&#124;Function match) | Search for a value in the array. Returns the index of the match or null. |
| insert | any insert(int idx, any val) | Insert a value into the array at the specified index. |
| len | int len() | Get the length of the array. |
| map | arrayLib map(Function func) | Map the array to a new array using a mapping function. Returns the mapped array. |
| pop | any pop() | Pop a value off the end of the array. Returns the popped value. |
| get | any get(int idx, any default = null) | Retrieve the element at the specified index in the array. Default value to return if the index is out of bounds |
| push | void push(any val) | Append a value to the array. |
| remove | void remove(int idx) | Remove an element from the array at the specified index. |
| resize | void resize(int size, any fill = null) | Resize the array to the specified size. Optionally fill new slots with a fill value. |
| reverse | arrayLib reverse() | Reverse the array in-place. Returns the reversed array. |
| slice | arrayLib slice(int start, int end = null) | Slice a portion of the array. Returns the sliced array. |
| sort | arrayLib sort(Function func = null) | Sort the array. Optionally accepts a compare function. Returns the sorted array. |
| top | any top() | Get the last element of the array. |
| Clone | arrayLib Clone() | Returns a clone of the array |
| join | string join(string joinstr = "") | Join the array into a string using the specified separator string. Returns the joined string. |
| totable | table totable(bool recreate = false) | Convert the array to a table representation. Optionally recreate the table if it already exists. Returns the table representation. |

#### [More info about *PCapture-Arrays* here](Arrays_module.md)

## 7. [`PCapture-BBoxCast`](/SRC/PCapture-Bboxcast.nut)  
#### TODO
Improved [BBoxCast](https://github.com/IaVashik/portal2-BBoxCast) for BBox-based ray tracing in Portal 2, more optimized.


## 8. [`PCapture-Anims`](/SRC/PCapture-Anims.nut) 

Animation module, used to quickly create animation events related to alpha, color, object moving

| Name | Usage | Description |
|-|-|-|
| AlphaTransition | void animate::AlphaTransition(pcapEntity&#124;CBaseEntity&#124;string entities, int startOpacity, int endOpacity, int&#124;float time, {eventName = null, globalDelay = 0, note = null, outputs = null} EventSetting) | Smoothly changes the alpha value of entities from the initial value to the final value over a specified time. |
| ColorTransition | void animate::ColorTransition(pcapEntity&#124;CBaseEntity&#124;string entities, string&#124;Vector startColor, string&#124;Vector endColor, int&#124;float time, {eventName = null, globalDelay = 0, note = null, outputs = null} EventSetting) | Smoothly changes the color of entities from the start color to the end color over a specified time. |
| PositionTransitionByTime | void animate::PositionTransitionByTime(pcapEntity&#124;CBaseEntity&#124;string entities, Vector startPos, Vector endPos, int&#124;float time, {eventName = null, globalDelay = 0, note = null, outputs = null} EventSetting) | Moves entities from the start position to the end position over a specified time based on increments of time. |
| PositionTransitionBySpeed | number animate::PositionTransitionBySpeed(pcapEntity&#124;CBaseEntity&#124;string entity, Vector startPos, Vector endPos, int&#124;float speed, {eventName = null, globalDelay = 0, note = null, outputs = null} EventSetting) | Moves entities from the start position to the end position over a specified time based on speed. |
| AnglesTransitionByTime | void animate::AnglesTransitionByTime(pcapEntity&#124;CBaseEntity&#124;string entity, Vector startAngles, Vector endAngles, int&#124;float time, {eventName = null, globalDelay = 0, note = null, outputs = null} EventSetting) | Changes angles of entities from the start angles to the end angles over a specified time. |

#### [More info about *PCapture-Anims* here](Anims_module.md)

## 9. [`PCapture-Improvements`](/SRC/PCapture-Improvements.nut)

Overrides and improves existing standard VScripts functions.
| Name | Usage | Description |
|-|-|-|
| FrameTime             | void FrameTime()                                       | Limits frametime to avoid zero values, providing a default if zero.   |
| EntFireByHandle       | void EntFireByHandle(target, action, value = "", delay = 0, activator = null, caller = null) | Wrapper to handle PCapLib objects with EntFireByHandle.               |
| GetPlayerEx           | pcapEntity GetPlayerEx(index)                                | Retrieves a player entity with extended functionality.                |

#### [More info about *PCapture-Improvements* here](Improvements_module.md)
