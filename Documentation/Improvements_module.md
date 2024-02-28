# PCapture-Improvements

Overrides and improves existing standard VScripts functions.

### FrameTime

Limits frametime to avoid zero values.
> Note
> If the game is paused, FrameTime will return 0, which can create infinite recursion in some functions

```
local tick = FrameTime()
```

- Returns: Clamped frametime.

### EntFireByHandle(target, action, value = "", delay = 0, activator = null, caller = null)

Wrapper for EntFireByHandle to handle PCapLib objects.

```
EntFireByHandle(target, action, value, delay, activator, caller)
```

- target (CBaseEntity|pcapEntity): Target entity.
- action (string): Action.
- value (string, *optional*): Action value.
- delay (number, *optional*): Delay in seconds.
- activator (CBaseEntity|pcapEntity, *optional*): Activator entity.
- caller (CBaseEntity|pcapEntity, *optional*): Caller entity.

### GetPlayerEx

Retrieves a player entity with extended functionality (pcapEntity).

```
local player = GetPlayerEx(1)
```

- index (int, *optional*): The index of the player (1-based). // TODO
- Returns: pcapEntity.
