# PCapture-Utils 

This module contains useful utilities for script execution and debugging. It's a Swiss army knife for developers working with Squirrel.

## Class `RunScriptCode`

Provides functions for executing scripts.

### delay(script, delay, activator = null, caller = null) 

Creates a delay before executing the specified script.

```
RunScriptCode.delay("printl(\"Hello\")", 1.5) // outputs: "Hello"
```

Outputs "Hello" to the console after 1.5 second delay.

- `script` (string|function): The script to execute, string or function  
- `delay` (int|float): The delay in seconds
- `activator` (CBaseEntity|pcapEntity, *optional*): The activator entity
- `caller` (CBaseEntity|pcapEntity, *optional*): The caller entity


### setInterval(script, delay, eventName)

Executes a script recursively at a fixed interval.
This function schedules the provided script to run repeatedly at a specified interval. After each execution, the function schedules itself to run again, creating a loop that continues until you cancel the event.

```
RunScriptCode.setInterval("printl(\"Hello\")", 1) // outputs "Hello" every 1 second
``` 

Recursively outputs "Hello" to console every 1 second.

- `script` (string|function): The script to execute, string or function
- `delay` (int|float, *optional*): The interval between executions in seconds (default *every tick*)
- `eventName` (string, *optional*): The event name for scheduling (default *"global"*)

> **Note: **
> To stop execution, call `cancelScheduledEvent(eventName)`


### loopy(func, delay, loop, outputs)

Executes a function repeatedly for a given number of loops. 

```
RunScriptCode.loopy("printl(\"Hello\")", 1, 5) // outputs "Hello" 5 times with 1 second delay
```

Outputs "Hello" 5 times to console with 1 second delay between prints.

- `func` (string|function): The function to execute
- `delay` (int|float): The delay between executions in seconds
- `loop` (int): The number of loops  
- `outputs` (string|function, *optional*): The function to execute after all loops (*optional*)

### fromStr(str) 

Executes a script from a string.

```
RunScriptCode.fromStr("printl(\"Hello World!\")") // outputs "Hello World!"
``` 

Executes the given script string, printing "Hello World!".

- `str` (str): The script string

## Class `dev`

Provides developer utilities. 

### DrawEntityBBox(ent, time)

Draws the bounding box of an entity. 

```
local ent = Entities.FindByName(null, "prop_physics")
dev.DrawEntityBBox(ent, 10)
```

Draws bounding box of "prop_physics" entity for 10 seconds.

- `ent` (CBaseEntity|pcapEntity): The entity
- `time` (int|float): Display time in seconds


### drawbox(vector, color, time = 0.05) 

Draws a box at the specified position.

```
dev.drawbox(Vector(0, 0, 0), Vector(255, 0, 0))  
```

Draws a red box at the origin for 0.05 seconds.

- `vector` (Vector): The position
- `color` (Vector): The color as Vector or string 
- `time` (int|float, *optional*): Display time in seconds (default *0.05*)

### Other Functions 

### fprint(msg, ...)

Prints a formatted message to console.

```
fprint("Hello, my name is {}", "John") // outputs "Hello, my name is John"
fprint("Ent: {}, model: {}, health: {}", ent, ent.GetModelName(), ent.GetHealth()) // outputs: "Ent: " TODO
```

Prints "Hello, my name is John" to the console.

- `msg` (str): The message string with `{}` placeholders
- `...` (any): Values to substitute into placeholders


### StrToVec(str) 

Converts a string to a Vector. 

```
local vec = StrToVec("1.0 2.5 3.2") 
// vec = Vector(1.0, 2.5, 3.2) 
```

Converts "1.0 2.5 3.2" to Vector(1.0, 2.5, 3.2).

- `str` (str): The string like "x y z"

### GetPrefix(name)

Gets the prefix of an entity name.

### GetPostfix(name)  

Gets the postfix of an entity name.

### Precache(sound_path)

Precaches a sound.

```
Precache("sound/weapon_my.wav")
``` 

Precaches "sound/weapon_my.wav" sound.

- `sound_path` (string|array|arrayLib): Path to the sound
