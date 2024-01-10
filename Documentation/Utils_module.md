# PCapture-Utils 

This module contains useful utilities for script execution and debugging. It's a Swiss army knife for developers working with Squirrel.

### *Class* RunScriptCode

Provides functions for executing scripts.

#### delay(script, delay, activator, caller) 

Creates a delay before executing the specified script.

```
RunScriptCode.delay("printl(\"Hello\")", 1.5) // outputs: "Hello"
```

Outputs "Hello" to the console after 1.5 second delay.

- script - The script to execute, string or function  
- delay - The delay in seconds
- activator - The activator entity (optional)
- caller - The caller entity (optional)


#### recursive(script, delay, eventName)

Executes a script recursively at a fixed interval.

```
RunScriptCode.recursive("printl(\"Hello\")", 1) // outputs "Hello" every 1 second
``` 

Recursively outputs "Hello" to console every 1 second.

- script - The script to execute, string or function
- delay - The interval between executions in seconds  
- eventName - The event name for scheduling (default "global")

> **Note:**
> To stop execution, call `cancelScheduledEvent(eventName)`


#### loopy(func, delay, loop, outputs)

Executes a function repeatedly for a given number of loops. 

```
RunScriptCode.loopy("printl(\"Hello\")", 1, 5) // outputs "Hello" 5 times with 1 second delay
```

Outputs "Hello" 5 times to console with 1 second delay between prints.

- func - The function to execute
- delay - The delay between executions in seconds
- loop - The number of loops  
- outputs - The function to execute after all loops (optional)

#### fromStr(str) 

Executes a script from a string.

```
RunScriptCode.fromStr("printl(\"Hello World!\")") // outputs "Hello World!"
``` 

Executes the given script string, printing "Hello World!".

- str - The script string

### *Class* dev

Provides developer utilities. 

#### DrawEntityBBox(ent, time)

Draws the bounding box of an entity. 

```
local ent = Entities.FindByName(null, "prop_physics")
dev.DrawEntityBBox(ent, 10)
```

Draws bounding box of "prop_physics" entity for 10 seconds.

- ent - The entity
- time - Display time in seconds


#### drawbox(vector, color, time) 

Draws a box at the specified position.

```
dev.drawbox(Vector(0, 0, 0), "255 0 0")  
```

Draws a red box at the origin for 0.05 seconds.

- vector - The position
- color - The color as Vector or string 
- time - Display time in seconds (default 0.05)

### Other Functions 

#### fprint(msg, ...)

Prints a formatted message to console.

```
fprint("Hello, my name is {}", "John") // outputs "Hello, my name is John"
```

Prints "Hello, my name is John" to the console.

- msg - The message string with `{}` placeholders
- ... - Values to substitute into placeholders


#### StrToVec(str) 

Converts a string to a Vector. 

```
local vec = StrToVec("1.0 2.5 3.2") // vec = Vector(1.0, 2.5, 3.2) 
```

Converts "1.0 2.5 3.2" to Vector(1.0, 2.5, 3.2).

- str - The string like "x y z"

#### GetPrefix(name)

Gets the prefix of an entity name.

#### GetPostfix(name)  

Gets the postfix of an entity name.

#### Precache(sound_path)

Precaches a sound.

```
Precache("sound/weapon_my.wav")
``` 

Precaches "sound/weapon_my.wav" sound.

- sound_path - Path to the sound
