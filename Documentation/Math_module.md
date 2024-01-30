# PCapture-Math 

Mathematical module with various math functions.

## Class Quaternion

Quaternion class for quaternion operations.

### new(angles) 

Creates a quaternion from Euler angles.

```
local q = Quaternion.new(Vector(30, 45, 60)) // Creates quaternion with angles Vector(30, 45, 60) 
```

- `angles` (Vector): Euler angles vector
- Returns (Quaternions): new Quaternion instance.

### rotate(vector)

Rotates a vector by the quaternion. 

```
local rotated = q.rotate(Vector(1, 0, 0)) // Outputs: Rotated Vector(1, 0, 0)
```

Rotates <1, 0, 0> vector by quaternion q.

- `vector` (Vector): Vector to rotate  
- Returns (Vector): rotated vector.

### unrotate(vector)

Unrotates a vector by the quaternion.

```
local unrotated = q.unrotate(rotated) // Outputs: Original Vector(1, 0, 0) vector  
``` 

Unrotates previously rotated vector.

- `vector` (Vector): Vector to unrotate
- Returns (Vector): original unrotated vector. 

### slerp(target, t)

Spherical linear interpolation between quaternions. 

```
local result = q1.slerp(q2, 0.5) // Outputs: Quaternion interpolated halfway between q1 and q2
```

Interpolates halfway between q1 and q2.

- `target` (Quaternions): Target quaternion
- `t` (float): Interpolation parameter 0-1  

- Returns (Quaternions): interpolated quaternion.

### toVector() 

Converts quaternion to Euler angles vector.

```
local angles = q.toVector() // Outputs: Vector(30, 45, 60)
```

- Returns (Vector): angles vector.

### get_table()

Gets quaternion components as table.

```
local qTable = q.get_table() // Outputs: table 
```

- Returns (table): table with `x`, `y`, `z`, `w` keys.

## Interpolation Functions

### lerp.int(start, end, t)

Integer linear interpolation.

```
local result = lerp.int(10, 20, 0.5) // Outputs: 15
```

- `start` (int|float): Start value  
- `end` (int|float): End value 
- `t` (float): Interpolation parameter 0-1
- Returns (int): integer interpolated value.

### lerp.vector(start, end, t) 

Vector linear interpolation.

```
local result = lerp.vector(Vector(0, 10, 0), Vector(10, 20, 0), 0.5) // Outputs: Vector(5, 15, 0)
```

- `start` (Vector): Start vector  
- `end` (Vector): End vector
- `t` (float): Interpolation parameter 0-1   
- Returns (Vector): interpolated vector.

### lerp.color(start, end, t)

Color linear interpolation.  

```
local result = lerp.color("255 0 0", "0 255 0", 0.5) // Outputs: "128 128 0"
local result2 = lerp.color(Vector(255, 0, 0), Vector(0, 255, 0), 0.5) // Outputs: "128 128 0"

```

- `start` (Vector|string): Start color vector or string 
- `end` (Vector|string): End color vector or string
- `t` (float): Interpolation parameter 0-1
- Returns (string): interpolated color string.

### lerp.sVector(start, end, t) 

Spherical interpolation between vectors.

```
local result = lerp.sVector(Vector(0, 0, 10), Vector(0, 10, 0), 0.5) // Outputs: Vector(0, 5, 5) 
```

- `start` (Vector): Start vector
- `end` (Vector): End vector 
- `t` (int|float): Interpolation parameter 0-1
- Returns (Vector): interpolated vector.

### lerp.SmoothStep(edge0, edge1, x) 

Smoothstep interpolation.  

```
local y = lerp.SmoothStep(0, 10, 5) // Outputs: Smoothstep interpolated value between 0 and 10 at x=5
```

- `edge0` (float): Lower edge
- `edge1` (float): Upper edge
- `x` (float): Value to interpolate
- Returns (float): interpolated value.

### lerp.FLerp(f1, f2, i1, i2, x)

Linear interpolation between two values.

```
local result = lerp.FLerp(10, 20, 0, 10, 5) // Outputs: 15
```

- `f1` (float): Start value
- `f2` (float): End value  
- `i1` (float): Start parameter
- `i2` (float): End parameter
- `x` (float): Interpolation parameter  
- Returns (float): interpolated value.

## Other Math Functions

### math.min(vargs...)

```
local min = math.min(10, 5, 20) // Outputs: 5
```

- `vargs` (int|float): Numbers to compare
- Returns (int|float): the minimum value.

### math.max(vargs...)

```
local max = math.max(10, 5, 20) // Outputs: 20
```

- `vargs` (int|float): Numbers to compare
- Returns (int|float): the maximum value.

### math.clamp(value, min, max) 

Clamps value within min/max range. 

```
local result = math.clamp(15, 10, 20) // Outputs: 15 
local result2 = math.clamp(15, 20, 30) // Outputs: 20 
```

- `value` (int|float): Value to clamp
- `min` (int|float): Minimum value
- `max` (int|float): Maximum value
- Returns (int|float): The clamped value

### math.Sign(x)

Gets sign of number (-1, 0, or 1).

```  
local sign = math.Sign(-5) // Outputs: -1
```

- `x` (int|float): Number to get sign of
- Returns (int): The sign of the number (-1, 0, or 1).

### math.copysign(value, sign)

Copies sign of value. 

```
local result = math.copysign(5, -1) // Outputs: -5
```

- `value` (int|float): Value to copy sign to
- `sign` (int): Sign to copy
- Returns (int|float): The value with the copied sign.

### math.RemapVal(val, A, B, C, D)

Remaps value from [A, B] range to [C, D] range.

```
local result = math.RemapVal(25, 0, 50, 0, 100) // Outputs: 50
```

- `val` (float): Value to remap 
- `A` (float): Start of input range
- `B` (float): End of input range
- `C` (float): Start of output range
- `D` (float): End of output range
- Returns (float): The remapped value.

### math.roundVector(vec, precision)

Rounds vector components to precision.

```
local result = math.roundVector(Vector(1.234, 5.678, 9.101), 90) // Outputs: Vector(1.23, 5.68, 9.10)
```
Rounds to two decimal places.

- `vec` (Vector): Vector to round 
- `precision` (int|float): Rounding precision 
- Returns (Vector): The rounded vector.

### math.rotateVector(vec, angle) 

Rotates vector by quaternion from angles. 

```
local rotated = math.rotateVector(Vector(1, 0, 0), Vector(0, 45, 0)) // Outputs: Rotated vector
```

- `vec` (Vector): Vector to rotate
- `angle` (int|float): Rotation angles 
- Returns (Vector): Rotated vector

### math.unrotateVector(vec, angle)

Unrotates vector by quaternion from angles.

```
local unrotated = math.unrotateVector(rotated, Vector(0, 45, 0)) // Outputs: Original vector 
```

- `vec` (Vector): Vector to unrotate
- `angle` (int|float): Rotation angles
- Returns (Vector): Unrotated vector

### math.RandomVector(min, max) 

Generates random vector within min/max range. 

```
local randVec = RandomVector(Vector(-10, -10, -10), Vector(10, 10, 10)) // Outputs: Random vector between [-10, 10]
```

- `min` (int|float): Minimum value 
- `max` (int|float): Maximum value
- Returns (Vector): The random vector

