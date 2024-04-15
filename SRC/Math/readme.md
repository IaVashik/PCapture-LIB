# Math Module

The `Math` module provides various mathematical functions and objects for use in VScripts, including those for linear interpolation, quaternions, vectors, and matrices. It aims to extend the standard mathematical capabilities of VScripts and simplify common mathematical operations.

## [Math/algebraic.nut](algebraic.nut)

This file contains basic algebraic functions such as finding minimum and maximum values, clamping numbers, rounding, and remapping values.

### `math.min(...)`

This function finds the minimum value among the given arguments.

**Parameters:**

* `...` (number): A variable number of numerical arguments to compare.

**Returns:**

* (number): The minimum value among the provided arguments.

**Example:**

```js
local smallestValue = math.min(10, 5, 20, -3) // smallestValue will be -3
```

### `math.max(...)`

This function finds the maximum value among the given arguments.

**Parameters:**

* `...` (number): A variable number of numerical arguments to compare.

**Returns:**

* (number): The maximum value among the provided arguments.

**Example:**

```js
local largestValue = math.max(10, 5, 20, -3) // largestValue will be 20
```

### `math.clamp(number, min, max)`

This function clamps a number within the specified range, ensuring that the returned value is between the minimum and maximum values (inclusive).

**Parameters:**

* `number` (number): The number to clamp.
* `min` (number): The minimum value of the range.
* `max` (number, optional): The maximum value of the range (defaults to a very large number).

**Returns:**

* (number): The clamped value within the specified range.

**Example:**

```js
local clampedValue = math.clamp(15, 10, 20) // clampedValue will be 15 (within the range)
local clampedValue2 = math.clamp(25, 10, 20) // clampedValue2 will be 20 (clamped to the maximum)
```

### `math.round(value, precision)`

This function rounds a number to the specified precision.

**Parameters:**

* `value` (number): The number to round.
* `precision` (number, optional): The precision to round to (e.g., 1000 for rounding to three decimal places, default is 1000).

**Returns:**

* (number): The rounded value.

**Example:**

```js
local roundedValue = math.round(3.14159, 100) // roundedValue will be 3.14 (rounded to two decimal places)
```

### `math.Sign(x)`

This function returns the sign of a number as -1, 0, or 1.

**Parameters:**

* `x` (number): The number to get the sign of.

**Returns:**

* (number): The sign of the number:
    * -1 if the number is negative.
    * 0 if the number is zero.
    * 1 if the number is positive.

**Example:**

```js
local sign = math.Sign(-5) // sign will be -1
local sign2 = math.Sign(0) // sign2 will be 0
local sign3 = math.Sign(10) // sign3 will be 1
```

### `math.copysign(value, sign)`

This function copies the sign of one number to another.

**Parameters:**

* `value` (number): The value to copy the sign to.
* `sign` (number): The number whose sign to copy (should be -1, 0, or 1).

**Returns:**

* (number): The value with the copied sign.

**Example:**

```js
local result = math.copysign(5, -1) // result will be -5
```

### `math.RemapVal(val, A, B, C, D)`

This function remaps a value from one range to another. It takes a value `val` within the range [A, B] and maps it to a corresponding value within the range [C, D].

**Parameters:**

* `val` (number): The value to remap.
* `A` (number): The start of the input range.
* `B` (number): The end of the input range.
* `C` (number): The start of the output range.
* `D` (number): The end of the output range.

**Returns:**

* (number): The remapped value within the range [C, D].

**Example:**

```js
local remappedValue = math.RemapVal(50, 0, 100, -1, 1) // remappedValue will be 0 (middle of the new range)
```

## [Math/utils_vector.nut](utils_vector.nut)

This file contains utility functions for working with vectors, including checking equality, rotating and un-rotating, generating random vectors, reflecting vectors, clamping components, and resizing vectors.

### `math.vector.isEqually(vec1, vec2)`

This function checks if two vectors are equal by comparing their rounded components. It is useful for comparing vectors with floating-point components, where small differences due to precision errors may occur.

**Parameters:**

* `vec1` (Vector): The first vector.
* `vec2` (Vector): The second vector.

**Returns:**

* (boolean): True if the vectors are considered equal (their rounded components are the same), false otherwise.

**Example:**

```js
local vec1 = Vector(1.001, 2.002, 3.003)
local vec2 = Vector(1.004, 2.005, 3.006)
if (math.vector.isEqually(vec1, vec2)) {
    // The vectors are considered equal (their rounded components are the same)
}
```

### `math.vector.rotate(vec, angle)`

This function rotates a vector by a given angle represented as Euler angles (pitch, yaw, roll). It uses quaternion operations to perform the rotation.

**Parameters:**

* `vec` (Vector): The vector to rotate.
* `angle` (Vector): The Euler angles in degrees (pitch, yaw, roll) representing the rotation.

**Returns:**

* (Vector): The rotated vector.

**Example:**

```js
local rotatedVec = math.vector.rotate(Vector(1, 0, 0), Vector(0, 45, 0)) // Rotate the vector by 45 degrees around the Y axis
```

### `math.vector.unrotate(vec, angle)`

This function un-rotates a vector by a given angle represented as Euler angles. It reverses the rotation that would be applied by `math.vector.rotate`.

**Parameters:**

* `vec` (Vector): The vector to un-rotate.
* `angle` (Vector): The Euler angles in degrees (pitch, yaw, roll) representing the rotation to reverse.

**Returns:**

* (Vector): The un-rotated vector.

**Example:**

```js
local originalVec = math.vector.unrotate(rotatedVec, Vector(0, 45, 0)) // Un-rotate the vector back to its original orientation
```

### `math.vector.random(min, max)`

This function generates a random vector within the specified range. The range can be defined either by two vectors or by two numbers.

**Parameters:**

* `min` (Vector or number): If a vector, the minimum values for each component of the generated vector. If a number, the minimum value for all components.
* `max` (Vector or number): If a vector, the maximum values for each component of the generated vector. If a number, the maximum value for all components.

**Returns:**

* (Vector): The generated random vector.

**Example:**

```js
local randVec = math.vector.random(Vector(-10, -10, -10), Vector(10, 10, 10)) // Generate a random vector between (-10, -10, -10) and (10, 10, 10)
local randVec2 = math.vector.random(-1, 1) // Generate a random vector with components between -1 and 1
```

### `math.vector.reflect(dir, normal)`

This function reflects a direction vector off a surface with a given normal vector.

**Parameters:**

* `dir` (Vector): The direction vector to reflect.
* `normal` (Vector): The normal vector of the surface.

**Returns:**

* (Vector): The reflected direction vector.

**Example:**

```js
local incomingDir = Vector(1, 0, 0)
local surfaceNormal = Vector(0, 1, 0)
local reflectedDir = math.vector.reflect(incomingDir, surfaceNormal) // Reflect the incoming direction off the surface
```

### `math.vector.clamp(vec, min, max)`

This function clamps the components of a vector within the specified range.

**Parameters:**

* `vec` (Vector): The vector to clamp.
* `min` (number): The minimum value for each component.
* `max` (number): The maximum value for each component.

**Returns:**

* (Vector): The clamped vector.

**Example:**

```js
local clampedVec = math.vector.clamp(Vector(255, 512, -10), 0, 255) // clampedVec will be Vector(255, 255, 0)
```

### `math.vector.resize(vec, newLength)`

This function resizes a vector to a new length while maintaining its direction.

**Parameters:**

* `vec` (Vector): The vector to resize.
* `newLength` (number): The desired new length of the vector.

**Returns:**

* (Vector): The resized vector with the specified length.

**Example:**

```js
local resizedVec = math.vector.resize(Vector(1, 2, 3), 5) // Resize the vector to have a length of 5
```

### `math.vector.round(vec, precision)`

This function rounds the components of a vector to the specified precision.

**Parameters:**

* `vec` (Vector): The vector to round.
* `precision` (number, optional): The precision to round to (e.g., 1000 for rounding to three decimal places, default is 1000).

**Returns:**

* (Vector): The rounded vector.

**Example:**

```js
local roundedVec = math.vector.round(Vector(1.234, 5.678, 9.101), 100) // Round the vector components to two decimal places
```

### `math.vector.sign(vec)` 

This function returns a new vector where each component represents the sign of the corresponding component in the input vector. The sign is determined using the `math.Sign` function, which returns -1 for negative values, 0 for zero, and 1 for positive values.

**Parameters:**

* `vec` (Vector): The input vector.

**Returns:**

* (Vector): A new vector with the signs of the input vector's components.

**Example:**

```js
local vec = Vector(-14, 0, 2)
local signVec = math.vector.sign(vec) // signVec will be Vector(-1, 0, 1)
```

#### `math.vector.abs(vector)`

This function calculates the absolute value of each component in a vector and returns a new vector with the absolute values.

**Parameters:**

* `vector` (Vector): The input vector.

**Returns:**

* (Vector): A new vector with the absolute values of the original vector's components.

**Example:**

```js
local vec = Vector(-3, 4, -5)
local absVec = math.vector.abs(vec) // absVec will be Vector(3, 4, 5)
```


## [Math/lerp.nut](lerp.nut)

This file provides functions for linear interpolation (lerp) between different data types, including numbers, vectors, and colors. It also includes functions for spline interpolation, smoothstep interpolation, and other interpolation techniques.

### `math.lerp.number(start, end, t)`

This function performs linear interpolation between two numbers. It calculates a value between `start` and `end` based on the interpolation parameter `t`.

**Parameters:**

* `start` (number): The starting value.
* `end` (number): The ending value.
* `t` (number): The interpolation parameter (between 0 and 1).

**Returns:**

* (number): The interpolated value between `start` and `end`.

**Example:**

```js
local interpolatedValue = math.lerp.number(10, 20, 0.5) // interpolatedValue will be 15 (halfway between 10 and 20)
```

### `math.lerp.vector(start, end, t)`

This function performs linear interpolation between two vectors. It calculates a new vector that lies on the line segment between `start` and `end`, with the position determined by the interpolation parameter `t`.

**Parameters:**

* `start` (Vector): The starting vector.
* `end` (Vector): The ending vector.
* `t` (number): The interpolation parameter (between 0 and 1).

**Returns:**

* (Vector): The interpolated vector between `start` and `end`.

**Example:**

```js
local startPos = Vector(0, 0, 0)
local endPos = Vector(10, 10, 0)
local interpolatedPos = math.lerp.vector(startPos, endPos, 0.25) // interpolatedPos will be Vector(2.5, 2.5, 0)
```

### `math.lerp.color(start, end, t)`

This function performs linear interpolation between two colors. The colors can be represented as strings (e.g., "255 0 0" for red) or as vectors with components (r, g, b).

**Parameters:**

* `start` (string or Vector): The starting color.
* `end` (string or Vector): The ending color.
* `t` (number): The interpolation parameter (between 0 and 1).

**Returns:**

* (string): The interpolated color as a string.

**Example:**

```js
local startColor = "255 0 0" // Red
local endColor = "0 0 255" // Blue
local interpolatedColor = math.lerp.color(startColor, endColor, 0.5) // interpolatedColor will be "128 0 128" (purple)
```

### `math.lerp.sVector(start, end, t)`

This function performs spherical linear interpolation (slerp) between two vectors. Slerp is a more sophisticated interpolation technique that results in a smoother transition between orientations compared to linear interpolation.

**Parameters:**

* `start` (Vector): The starting vector.
* `end` (Vector): The ending vector.
* `t` (number): The interpolation parameter (between 0 and 1).

**Returns:**

* (Vector): The interpolated vector using slerp.

**Example:**

```js
local startDir = Vector(1, 0, 0) // Facing right
local endDir = Vector(0, 1, 0) // Facing forward
local interpolatedDir = math.lerp.sVector(startDir, endDir, 0.5) // Interpolate between the two directions using slerp
```

### `math.lerp.spline(f)`

This function performs cubic spline interpolation. Spline interpolation is a technique for creating smooth curves that pass through a set of control points.

**Parameters:**

* `f` (number): The interpolation parameter (between 0 and 1).

**Returns:**

* (number): The interpolated value using cubic spline interpolation.

**Example:**

```js
// ... (assuming you have a set of control points for the spline)
local interpolatedValue = math.lerp.spline(0.5) // Interpolate at the midpoint of the spline
```

### `math.lerp.SmoothStep(edge0, edge1, x)`

This function performs smooth interpolation between two values using a smoothstep function. The smoothstep function provides a smooth transition between the two edges, avoiding sudden jumps or discontinuities.

**Parameters:**

* `edge0` (number): The lower edge of the interpolation range.
* `edge1` (number): The upper edge of the interpolation range.
* `x` (number): The value to interpolate.

**Returns:**

* (number): The interpolated value between `edge0` and `edge1`.

**Example:**

```js
local smoothedValue = math.lerp.SmoothStep(0, 10, 5) // Smoothly interpolate between 0 and 10 at x=5
```

### `math.lerp.FLerp(f1, f2, i1, i2, x)`

This function performs linear interpolation between two values with custom interpolation parameters. It allows you to define the start and end values, as well as the corresponding interpolation parameters, for more control over the interpolation behavior.

**Parameters:**

* `f1` (number): The start value.
* `f2` (number): The end value.
* `i1` (number): The start interpolation parameter.
* `i2` (number): The end interpolation parameter.
* `x` (number): The interpolation parameter for the current value.

**Returns:**

* (number): The interpolated value.

**Example:**

```js
local result = math.lerp.FLerp(10, 20, 0, 10, 5) // result will be 15 (linear interpolation with custom parameters)
```

### `math.lerp.SmoothCurve(x)`

This function applies a smooth curve function to a value. It transforms the input value using a cosine function to create a smooth, curved transition.

**Parameters:**

* `x` (number): The input value to transform.

**Returns:**

* (number): The transformed value using the smooth curve function.

**Example:**

```js
local curvedValue = math.lerp.SmoothCurve(0.5) // Apply the smooth curve function to the value 0.5
```

### `math.lerp.SmoothProgress(progress)`

This function calculates smooth progress based on a progress value. It maps the input progress value (between 0 and 1) to a smooth, curved progression using sine and linear interpolation.

**Parameters:**

* `progress` (number): The input progress value (between 0 and 1).

**Returns:**

* (number): The calculated smooth progress value.

**Example:**

```js
local smoothProgress = math.lerp.SmoothProgress(0.5) // Calculate the smooth progress at 50%
```

## [Math/quaternion.nut](quaternion.nut)

This file defines the `math.Quaternion` class, which represents a quaternion (a mathematical object used for rotations in 3D space). The class provides methods for creating quaternions from Euler angles or vectors, rotating and un-rotating vectors, performing spherical linear interpolation, normalization, and conversion to other representations (axis-angle and Euler angles).

### `Quaternion(x, y, z, w)`

**Constructor**

This creates a new quaternion with the specified components.

**Parameters:**

* `x` (number): The x component of the quaternion.
* `y` (number): The y component of the quaternion.
* `z` (number): The z component of the quaternion.
* `w` (number): The w component of the quaternion.

**Example:**

```js
local q = math.Quaternion(0, 0, 0, 1) // Create an identity quaternion (no rotation)
```

### `fromEuler(angles)`

This method creates a quaternion from Euler angles (pitch, yaw, roll).

**Parameters:**

* `angles` (Vector): The Euler angles in degrees (pitch, yaw, roll).

**Returns:**

* (Quaternion): The quaternion corresponding to the given Euler angles.

**Example:**

```js
local q = math.Quaternion.fromEuler(Vector(30, 45, 60)) // Create a quaternion from Euler angles
```

### `fromVector(vector)`

This method creates a quaternion from a vector, with the w component of the quaternion set to 0.

**Parameters:**

* `vector` (Vector): The vector to create the quaternion from.

**Returns:**

* (Quaternion): The quaternion with the vector's components as x, y, and z, and w set to 0.

**Example:**

```js
local v = Vector(1, 2, 3)
local q = math.Quaternion.fromVector(v) // Create a quaternion from the vector
```

### `rotateVector(vector)`

This method rotates a vector by the quaternion.

**Parameters:**

* `vector` (Vector): The vector to rotate.

**Returns:**

* (Vector): The rotated vector.

**Example:**

```js
local rotatedVec = q.rotateVector(Vector(1, 0, 0)) // Rotate the vector (1, 0, 0) by the quaternion q
```

### `unrotateVector(vector)`

This method un-rotates a vector by the quaternion, reversing the rotation that would be applied by `rotateVector`.

**Parameters:**

* `vector` (Vector): The vector to un-rotate.

**Returns:**

* (Vector): The un-rotated vector.

**Example:**

```js
local originalVec = q.unrotateVector(rotatedVec) // Un-rotate the vector back to its original orientation
```

### `slerp(targetQuaternion, t)`

This method performs spherical linear interpolation (slerp) between this quaternion and the target quaternion. Slerp is a more sophisticated interpolation technique than linear interpolation, resulting in a smoother transition between orientations.

**Parameters:**

* `targetQuaternion` (Quaternion): The target quaternion to interpolate towards.
* `t` (number): The interpolation parameter between 0 and 1.

**Returns:**

* (Quaternion): The interpolated quaternion.

**Example:**

```js
local q1 = math.Quaternion.fromEuler(Vector(0, 0, 0)) // Starting orientation
local q2 = math.Quaternion.fromEuler(Vector(0, 90, 0)) // Ending orientation
local interpolatedQ = q1.slerp(q2, 0.5) // Interpolate halfway between the two orientations
```

### `normalize()`

This method normalizes the quaternion, scaling its components so that its length (magnitude) is 1. Normalization is often necessary for quaternion operations to work correctly.

**Returns:**

* (Quaternion): The normalized quaternion.

**Example:**

```js
local normalizedQ = q.normalize() // Normalize the quaternion q
```

### `dot(other)`

This method calculates the dot product of this quaternion and another quaternion.

**Parameters:**

* `other` (Quaternion): The other quaternion to calculate the dot product with.

**Returns:**

* (number): The dot product of the two quaternions.

**Example:**

```js
local dotProduct = q1.dot(q2) // Calculate the dot product of q1 and q2
```

### `length()`

This method calculates the length (magnitude) of the quaternion.

**Returns:**

* (number): The length of the quaternion.

**Example:**

```js
local quaternionLength = q.length() // Get the length of the quaternion q
```

### `inverse()`

This method calculates the inverse of the quaternion. The inverse of a quaternion is the quaternion that, when multiplied by the original quaternion, results in the identity quaternion (no rotation).

**Returns:**

* (Quaternion): The inverse of the quaternion.

**Example:**

```js
local inverseQ = q.inverse() // Calculate the inverse of the quaternion q
```

### `fromAxisAngle(axis, angle)`

This method creates a quaternion from an axis and an angle of rotation around that axis.

**Parameters:**

* `axis` (Vector): The axis of rotation (should be a normalized vector).
* `angle` (number): The angle of rotation in radians.

**Returns:**

* (Quaternion): The quaternion representing the rotation around the given axis.

**Example:**

```js
local axis = Vector(0, 1, 0) // Rotate around the Y axis
local angle = math.rad(45) // Rotate 45 degrees
local q = math.Quaternion.fromAxisAngle(axis, angle) // Create a quaternion for the rotation
```

### `toAxisAngle()`

This method converts the quaternion to an axis and an angle of rotation around that axis.

**Returns:**

* (table): A table with two keys:
* `axis` (Vector): The axis of rotation.
* `angle` (number): The angle of rotation in radians.

**Example:**

```js
local axisAngle = q.toAxisAngle()
printl("Axis:" + axisAngle.axis)
printl("Angle:" + math.deg(axisAngle.angle))
```

### `toVector()`

This method converts the quaternion to a vector representing Euler angles (pitch, yaw, roll) in degrees.

**Returns:**

* (Vector): The Euler angles corresponding to the quaternion's rotation.

**Example:**

```js
local eulerAngles = q.toVector() // Convert the quaternion to Euler angles
```

### `isEqually(other)`

This method checks if this quaternion is equal to another quaternion based on their components and length. It uses a more precise comparison than simply checking for exact equality of the components due to potential floating-point precision errors.

**Parameters:**

* `other` (Quaternion): The other quaternion to compare.

**Returns:**

* (boolean): True if the quaternions are considered equal, false otherwise.

**Example:**

```js
local q1 = math.Quaternion.fromEuler(Vector(0, 45, 0))
local q2 = math.Quaternion.fromAxisAngle(Vector(0, 1, 0), math.rad(45))
if (q1.isEqually(q2)) {
    // The quaternions represent the same rotation
}
```

### `cmp(other)`

This method compares this quaternion to another quaternion based on their magnitudes. It is used for sorting quaternions.

**Parameters:**

* `other` (Quaternion): The other quaternion to compare.

**Returns:**

* (number):
* 1 if this quaternion's magnitude is greater than the other quaternion's magnitude.
* -1 if this quaternion's magnitude is less than the other quaternion's magnitude.
* 0 if the magnitudes are equal.

**Example:**

```js
local q1 = math.Quaternion(1, 2, 3, 4)
local q2 = math.Quaternion(2, 3, 4, 5)
local comparisonResult = q1.cmp(q2) // comparisonResult will be -1 (q1's magnitude is less than q2's magnitude)
```

## [Math/matrix.nut](matrix.nut)

This file defines the `math.Matrix` class, which represents a 3x3 matrix (a mathematical object used for transformations in 3D space). The class provides methods for creating matrices from Euler angles, rotating and un-rotating vectors, transposing, inverting, calculating the determinant, scaling, rotating around the X axis, and performing matrix operations (multiplication, addition, and subtraction).

### `Matrix(a, b, c, d, e, f, g, h, k)`

**Constructor**

This creates a new matrix with the specified components.

**Parameters:**

* `a` (number): The value at row 1, column 1 of the matrix.
* `b` (number): The value at row 1, column 2 of the matrix.
* `c` (number): The value at row 1, column 3 of the matrix.
* `d` (number): The value at row 2, column 1 of the matrix.
* `e` (number): The value at row 2, column 2 of the matrix.
* `f` (number): The value at row 2, column 3 of the matrix.
* `g` (number): The value at row 3, column 1 of the matrix.
* `h` (number): The value at row 3, column 2 of the matrix.
* `k` (number): The value at row 3, column 3 of the matrix.

**Example:**

```js
local identityMatrix = math.Matrix(1, 0, 0, 0, 1, 0, 0, 0, 1) // Create an identity matrix
```

### `fromEuler(angles)`

This method creates a rotation matrix from Euler angles (pitch, yaw, roll).

**Parameters:**

* `angles` (Vector): The Euler angles in degrees (pitch, yaw, roll).

**Returns:**

* (Matrix): The rotation matrix corresponding to the given Euler angles.

**Example:**

```js
local rotationMatrix = math.Matrix.fromEuler(Vector(30, 45, 0)) // Create a rotation matrix from Euler angles
```

### `rotateVector(point)`

This method rotates a point using the matrix.

**Parameters:**

* `point` (Vector): The point to rotate.

**Returns:**

* (Vector): The rotated point.

**Example:**

```js
local rotatedPoint = rotationMatrix.rotateVector(Vector(1, 0, 0)) // Rotate the point (1, 0, 0) using the rotation matrix
```

### `unrotateVector(point)`

This method un-rotates a point using the matrix, reversing the rotation that would be applied by `rotateVector`.

**Parameters:**

* `point` (Vector): The point to un-rotate.

**Returns:**

* (Vector): The un-rotated point.

**Example:**

```js
local originalPoint = rotationMatrix.unrotateVector(rotatedPoint) // Un-rotate the point back to its original position
```

### `transpose()`

This method transposes the matrix, swapping its rows and columns.

**Returns:**

* (Matrix): The transposed matrix.

**Example:**

```js
local transposedMatrix = rotationMatrix.transpose() // Transpose the rotation matrix
```

### `inverse()`

This method calculates the inverse of the matrix. The inverse of a matrix is the matrix that, when multiplied by the original matrix, results in the identity matrix.

**Returns:**

* (Matrix): The inverse of the matrix.
* Throws an error if the matrix is singular (its determinant is zero).

**Example:**

```js
local inverseMatrix = rotationMatrix.inverse() // Calculate the inverse of the rotation matrix
```

### `determinant()`

This method calculates the determinant of the matrix. The determinant is a scalar value that can be used to determine properties of the matrix, such as whether it is invertible.

**Returns:**

* (number): The determinant of the matrix.

**Example:**

```js
local det = rotationMatrix.determinant() // Calculate the determinant of the rotation matrix
```

### `scale(factor)`

This method scales the matrix by a given factor. This multiplies each component of the matrix by the scaling factor.

**Parameters:**

* `factor` (number): The scaling factor.

**Returns:**

* (Matrix): The scaled matrix.

**Example:**

```js
local scaledMatrix = rotationMatrix.scale(2) // Scale the rotation matrix by a factor of 2
```

### `rotateX(angle)`

This method rotates the matrix around the X axis by a given angle. This is equivalent to pre-multiplying the matrix by a rotation matrix that rotates around the X axis.

**Parameters:**

* `angle` (number): The angle of rotation in radians.

**Returns:**

* (Matrix): The rotated matrix.

**Example:**

```js
local rotatedMatrixX = rotationMatrix.rotateX(math.rad(45)) // Rotate the matrix 45 degrees around the X axis
```

### `_mul(other)`

This method multiplies this matrix by another matrix. Matrix multiplication is not commutative, so the order of the matrices matters.

**Parameters:**

* `other` (Matrix): The other matrix to multiply by.

**Returns:**

* (Matrix): The result of the matrix multiplication.

**Example:**

```js
local resultMatrix = matrix1 * matrix2 // Multiply matrix1 by matrix2
```

### `_add(other)`

This method adds this matrix to another matrix. Matrix addition is commutative, so the order of the matrices does not matter.

**Parameters:**

* `other` (Matrix): The other matrix to add.

**Returns:**

* (Matrix): The result of the matrix addition.

**Example:**

```js
local resultMatrix = matrix1 + matrix2 // Add matrix1 and matrix2
```

### `_sub(other)`

This method subtracts another matrix from this matrix.

**Parameters:**

* `other` (Matrix): The matrix to subtract.

**Returns:**

* (Matrix): The result of the matrix subtraction.

**Example:**

```js
local resultMatrix = matrix1 - matrix2 // Subtract matrix2 from matrix1
```

### `isEqually(other)`

This method checks if this matrix is equal to another matrix based on their components and sum. It uses a more precise comparison than simply checking for exact equality of the components due to potential floating-point precision errors.

**Parameters:**

* `other` (Matrix): The other matrix to compare.

**Returns:**

* (boolean): True if the matrices are considered equal, false otherwise.

**Example:**

```js
local matrix1 = math.Matrix(1, 2, 3, 4, 5, 6, 7, 8, 9)
local matrix2 = math.Matrix(1, 2, 3, 4, 5, 6, 7, 8, 9)
if (matrix1.isEqually(matrix2)) {
    // The matrices are considered equal
}
```

### `cmp(other)`

This method compares this matrix to another matrix based on the sum of their components. It is used for sorting matrices.

**Parameters:**

* `other` (Matrix): The other matrix to compare.

**Returns:**

* (number):
* 1 if this matrix's sum is greater than the other matrix's sum.
* -1 if this matrix's sum is less than the other matrix's sum.
* 0 if the sums are equal.

**Example:**
```js
local matrix1 = math.Matrix(1, 2, 3, 4, 5, 6, 7, 8, 9)
local matrix2 = math.Matrix(2, 3, 4, 5, 6, 7, 8, 9, 10)
local comparisonResult = matrix1.cmp(matrix2)  // comparisonResult will be -1 (matrix1's sum is less than matrix2's sum)
```