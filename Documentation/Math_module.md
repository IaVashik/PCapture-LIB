# PCapture-Math 

Mathematical module with various math functions.

## Class Quaternion

Quaternion class for quaternion operations.

### new(angles) 

Creates a quaternion from Euler angles.

```
local q = Quaternion.new(Vector(30, 45, 60)) // Creates quaternion with angles <30, 45, 60> 
```

- angles - Euler angles vector

Returns new Quaternion instance.

### rotate(vector)

Rotates a vector by the quaternion. 

```
local rotated = q.rotate(Vector(1, 0, 0)) // Outputs: Rotated <1, 0, 0> vector
```

Rotates <1, 0, 0> vector by quaternion q.

- vector - Vector to rotate  

Returns rotated vector.

### unrotate(vector)

Unrotates a vector by the quaternion.

```
local unrotated = q.unrotate(rotated) // Outputs: Original <1, 0, 0> vector  
``` 

Unrotates previously rotated vector.

- vector - Vector to unrotate

Returns original unrotated vector. 

### slerp(target, t)

Spherical linear interpolation between quaternions. 

```
local result = q1.slerp(q2, 0.5) // Outputs: Quaternion interpolated halfway between q1 and q2
```

Interpolates halfway between q1 and q2.

- target - Target quaternion
- t - Interpolation parameter 0-1  

Returns interpolated quaternion.

### toVector() 

Converts quaternion to Euler angles vector.

```
local angles = q.toVector() // Outputs: Vector(30, 45, 60)
```

Returns <pitch, yaw, roll> angles vector.

### get_table()

Gets quaternion components as table.

```
local qTable = q.get_table() // Outputs: table 
```

Returns table with `x`, `y`, `z`, `w` keys.

## Interpolation Functions

### lerp.int(start, end, t)

Integer linear interpolation.

```
local result = lerp.int(10, 20, 0.5) // Outputs: 15
```

- start - Start value  
- end - End value 
- t - Interpolation parameter 0-1

Returns integer interpolated value.

### lerp.vector(start, end, t) 

Vector linear interpolation.

```
local result = lerp.vector(Vector(0, 10, 0), Vector(10, 20, 0), 0.5) // Outputs: Vector(5, 15, 0)
```

- start - Start vector  
- end - End vector
- t - Interpolation parameter 0-1   

Returns interpolated vector.

### lerp.color(start, end, t)

Color linear interpolation.  

```
local result = lerp.color("255 0 0", "0 255 0", 0.5) // Outputs: "128 128 0"
```

- start - Start color vector or string 
- end - End color vector or string
- t - Interpolation parameter 0-1

Returns interpolated color string.

### lerp.sVector(start, end, t) 

Spherical interpolation between vectors.

```
local result = lerp.sVector(Vector(0, 0, 10), Vector(0, 10, 0), 0.5) // Outputs: Vector(0, 5, 5) 
```

- start - Start vector
- end - End vector 
- t - Interpolation parameter 0-1

Returns interpolated vector.

### lerp.SmoothStep(edge0, edge1, x) 

Smoothstep interpolation.  

```
local y = lerp.SmoothStep(0, 10, 5) // Outputs: Smoothstep interpolated value between 0 and 10 at x=5
```

- edge0 - Lower edge
- edge1 - Upper edge
- x - Value to interpolate

Returns interpolated value.

### lerp.FLerp(f1, f2, i1, i2, x)

Linear interpolation between two values.

```
local result = lerp.FLerp(10, 20, 0, 10, 5) // Outputs: 15
```

- f1 - Start value
- f2 - End value  
- i1 - Start parameter
- i2 - End parameter
- x - Interpolation parameter  

Returns interpolated value.

## Other Math Functions

### min(vargs...)

Returns the minimum value.

```
local min = min(10, 5, 20) // Outputs: 5
```

- vargs - Numbers to compare

### max(vargs...)

Returns the maximum value.

```
local max = max(10, 5, 20) // Outputs: 20
```

- vargs - Numbers to compare

### clamp(value, min, max) 

Clamps value within min/max range. 

```
local result = clamp(15, 10, 20) // Outputs: 15 
```

- value - Value to clamp
- min - Minimum value
- max - Maximum value

### roundVector(vec, precision)

Rounds vector components to precision.

```
local result = roundVector(Vector(1.234, 5.678, 9.101), 100) // Outputs: Vector(1.23, 5.68, 9.10)
```

- vec - Vector to round 
- precision - Rounding precision 

Rounds to two decimal places.

### Sign(x)

Gets sign of number (-1, 0, or 1).

```  
local sign = Sign(-5) // Outputs: -1
```

- x - Number to get sign of

### copysign(value, sign)

Copies sign of value. 

```
local result = copysign(5, -1) // Outputs: -5
```

- value - Value to copy sign to
- sign - Sign to copy

### RemapVal(val, A, B, C, D)

Remaps value from [A, B] range to [C, D] range.

```
local result = RemapVal(25, 0, 50, 0, 100) // Outputs: 50
```

- val - Value to remap 
- A - Start of input range
- B - End of input range
- C - Start of output range
- D - End of output range

### rotateVector(vec, angle) 

Rotates vector by quaternion from angles. 

```
local rotated = rotateVector(Vector(1, 0, 0), Vector(0, 45, 0)) // Outputs: Rotated vector
```

- vec - Vector to rotate
- angle - Rotation angles 

### unrotateVector(vec, angle)

Unrotates vector by quaternion from angles.

```
local unrotated = unrotateVector(rotated, Vector(0, 45, 0)) // Outputs: Original vector 
```

- vec - Vector to unrotate
- angle - Rotation angles

### RandomVector(min, max) 

Generates random vector within min/max range. 

```
local randVec = RandomVector(Vector(-10, -10, -10), Vector(10, 10, 10)) // Outputs: Random vector between [-10, 10]
```

- min - Minimum value 
- max - Maximum value

