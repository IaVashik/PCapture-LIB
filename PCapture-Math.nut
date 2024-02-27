/*+--------------------------------------------------------------------------------+
|                           PCapture Vscripts Library                               |
 +---------------------------------------------------------------------------------+
| Author:                                                                           |
|     One-of-a-Kind - laVashik :D                                                   |
 +---------------------------------------------------------------------------------+
| PCapture-math.nut                                                                  |
|       Mathematical module. Contains many different functions,                      |
|       including lerp functions, quaternions and more                               |
+----------------------------------------------------------------------------------+ */

if("math" in getroottable()) {
    dev.warning("Math module initialization skipped. Module already initialized.")
    return
}

::math <- {
    /* Quaternion class for quaternion operations.
    *
    * @param {Quaternion} quaternion - The quaternion to initialize.
    */
    Quaternion = class {    // { TODO } should quaternion be replaced with this?
        quaternion = null 
        
        constructor(quaternion = null) {
            this.quaternion = quaternion
        }

        /* Creates a new quaternion from Euler angles.
        *
        * @param {Vector} angles - The Euler angles
        * @returns {Quaternion} - The new quaternion.
        */
        function new(angles) {
            // Convert angles to radians
            local pitch = angles.z * 0.5 / 180 * PI
            local yaw = angles.y * 0.5 / 180 * PI
            local roll = angles.x * 0.5 / 180 * PI

            // Calculate sine and cosine values
            local sRoll = sin(roll);
            local cRoll = cos(roll);
            local sPitch = sin(pitch);
            local cPitch = cos(pitch);
            local sYaw = sin(yaw);
            local cYaw = cos(yaw);

            // Calculate quaternion components
            local quaternion = {  // this = ...
                x = cYaw * cRoll * sPitch - sYaw * sRoll * cPitch,
                y = cYaw * sRoll * cPitch + sYaw * cRoll * sPitch,
                z = sYaw * cRoll * cPitch - cYaw * sRoll * sPitch,
                w = cYaw * cRoll * cPitch + sYaw * sRoll * sPitch
            }

            return math.Quaternion(quaternion)
        }

        /* Multiplies two quaternions.
        *
        * @param {Quaternion} q1 - The first quaternion.
        * @param {Quaternion} q2 - The second quaternion.
        * @returns {Quaternion} - The multiplication result.
        */
        function multiplyQuaternions(q1, q2) {
            return {
                x = q1.w * q2.x + q1.x * q2.w + q1.y * q2.z - q1.z * q2.y,
                y = q1.w * q2.y - q1.x * q2.z + q1.y * q2.w + q1.z * q2.x,
                z = q1.w * q2.z + q1.x * q2.y - q1.y * q2.x + q1.z * q2.w,
                w = q1.w * q2.w - q1.x * q2.x - q1.y * q2.y - q1.z * q2.z
            }
        }

        /* Rotates a vector by the quaternion.
        *
        * @param {vector} angle - The vector to rotate.
        * @returns {Vector} - The rotated vector.
        */
        function rotate(vector) {
            // Convert vector to quaternion
            local vecQuaternion = { x = vector.x, y = vector.y, z = vector.z, w = 0 };
        
            // Find the inverse quaternion
            local inverse = {
                x = -this.quaternion.x,
                y = -this.quaternion.y,
                z = -this.quaternion.z,
                w = this.quaternion.w
            };
        
            // Apply quaternion rotations to the vector
            local rotatedQuaternion = multiplyQuaternions(multiplyQuaternions(this.quaternion, vecQuaternion), inverse);
        
            // Return the result as a rotated vector
            return Vector(rotatedQuaternion.x, rotatedQuaternion.y, rotatedQuaternion.z);
        }
        
        /* Un-rotates a vector by the quaternion.
        *
        * @param {Vector} vector - The vector to un-rotate.
        * @returns {Vector} - The un-rotated vector.
        */
        function unrotate(vector) {
            // Find the conjugate quaternion
            local conjugateQuaternion = {
                x = -this.quaternion.x,
                y = -this.quaternion.y,
                z = -this.quaternion.z,
                w = this.quaternion.w
            };
        
            // "Convert" vector to quaternion
            local vecQuaternion = { x = vector.x, y = vector.y, z = vector.z, w = 0 };
        
            // Apply quaternion rotations to the vector with inverse rotation angles
            local unrotatedQuaternion = multiplyQuaternions(multiplyQuaternions(conjugateQuaternion, vecQuaternion), this.quaternion);
        
            // Return the result as an un-rotated vector
            return Vector(unrotatedQuaternion.x, unrotatedQuaternion.y, unrotatedQuaternion.z);
        }

        /* Performs spherical linear interpolation (slerp) between two quaternions.
        *
        * @param {Quaternion} targetQuaternion - The target quaternion to interpolate towards.
        * @param {Number} t - The interpolation parameter between 0 and 1.
        * @returns {Quaternion} - The interpolated quaternion.
        */
        function slerp(targetQuaternion, t) {
            local quaternion1 = this.quaternion
            local quaternion2 = targetQuaternion.get_table()

            // Normalize quaternions
            quaternion1 = _normalizeQuaternion(quaternion1);
            quaternion2 = _normalizeQuaternion(quaternion2);

            // Calculate angle between quaternions
            local cosTheta = quaternion1.x * quaternion2.x + quaternion1.y * quaternion2.y + quaternion1.z * quaternion2.z + quaternion1.w * quaternion2.w;

            // If angle is negative, invert the second quaternion
            if (cosTheta < 0) {
                quaternion2.x *= -1;
                quaternion2.y *= -1;
                quaternion2.z *= -1;
                quaternion2.w *= -1;
                cosTheta *= -1;
            }

            // Calculate interpolation values
            local theta = acos(cosTheta);
            local sinTheta = sin(theta);
            local weight1 = sin((1 - t) * theta) / sinTheta;
            local weight2 = sin(t * theta) / sinTheta;

            // Interpolate quaternions
            local resultQuaternion = {
                x = weight1 * quaternion1.x + weight2 * quaternion2.x,
                y = weight1 * quaternion1.y + weight2 * quaternion2.y,
                z = weight1 * quaternion1.z + weight2 * quaternion2.z,
                w = weight1 * quaternion1.w + weight2 * quaternion2.w
            };

            // Normalize the result
            local result = _normalizeQuaternion(resultQuaternion)
            return math.Quaternion(result);
        }

        /* Normalizes the quaternion.
        *
        * @returns {Quaternion} - The normalized quaternion.
        */
        function _normalizeQuaternion(quaternion) {
            local magnitude = sqrt(quaternion.x * quaternion.x + quaternion.y 
                * quaternion.y + quaternion.z * quaternion.z + quaternion.w * quaternion.w);

            return {
                x = quaternion.x / magnitude,
                y = quaternion.y / magnitude,
                z = quaternion.z / magnitude,
                w = quaternion.w / magnitude
            }
        }

        /* Returns the normalized quaternion.
        *
        * @returns {Quaternion} - The normalized quaternion.
        */
        function Norm() {
            return _normalizeQuaternion(this.quaternion)
        }

        /* Converts the quaternion to a vector representing Euler angles.
        *
        * @returns {Vector} - The vector representing Euler angles.
        */
        function toVector() {
            local sinr_cosp = 2 * (quaternion.w * quaternion.x + quaternion.y * quaternion.z);
            local cosr_cosp = 1 - 2 * (quaternion.x * quaternion.x + quaternion.y * quaternion.y);
            local roll = atan2(sinr_cosp, cosr_cosp);

            local sinp = 2 * (quaternion.w * quaternion.y - quaternion.z * quaternion.x);
            local pitch;
            if (abs(sinp) >= 1) {
                pitch = math.copysign(PI / 2, sinp); // PI/2 or -PI/2
            } else {
                pitch = asin(sinp);
            }

            local siny_cosp = 2 * (quaternion.w * quaternion.z + quaternion.x * quaternion.y);
            local cosy_cosp = 1 - 2 * (quaternion.y * quaternion.y + quaternion.z * quaternion.z);
            local yaw = atan2(siny_cosp, cosy_cosp);

            // Convert angles to degrees
            local x = pitch * 180 / PI;
            local y = yaw * 180 / PI;
            local z = roll * 180 / PI;

            return Vector( x, y, z )
        }

        function _mul(other) {
            return math.Quaternion(multiplyQuaternions(this.quaternion, other))
        }

        function _tostring() {
            local x = this.quaternion.x;
            local y = this.quaternion.y;
            local z = this.quaternion.z;
            local w = this.quaternion.w;
            return "Quaternion: (" + x + ", " + y + ", " + z + ", " + w + ")"
        }

        function _typeof() {
            return "PCapLib-Quaternion"
        }

        /* Returns whether the quaternion is valid or not.
        *
        * @returns {bool} - Returns true if the quaternion is valid, otherwise false.
        */
        function IsValid() {
            return quaternion
        }

        function x() {
            return this.quaternion.x;
        }

        function y() {
            return this.quaternion.y;
        }

        function z() {
            return this.quaternion.z;
        }

        function w() {
            return this.quaternion.w;
        }

        /* Returns the quaternion as a table.
        *
        * @returns {table} - The quaternion components as a table.
        */
        function get_table() {
            return {
                x = this.quaternion.x,
                y = this.quaternion.y,
                z = this.quaternion.z,
                w = this.quaternion.w
            }
        }
    },

    /* Interpolation functions */
    lerp = {
        /* Performs linear interpolation (lerp) between start and end based on the parameter t.
        *
        * @param {int|float} start - The starting value.
        * @param {int|float} end - The ending value.
        * @param {int|float} t - The interpolation parameter.
        * @returns {int|float} - The interpolated value.
        */
        int = function(start, end, t) {
            return start * (1 - t) + end * t;
        },


        /* Performs linear interpolation (lerp) between two vectors.
        *
        * @param {Vector} start - The starting vector.
        * @param {Vector} end - The ending vector.
        * @param {int|float} t - The interpolation parameter.
        * @returns {Vector} - The interpolated vector.
        */
        vector = function(start, end, t) {
            return Vector(int(start.x, end.x, t), int(start.y, end.y, t), int(start.z, end.z, t));
        },


        /* Performs linear interpolation (lerp) between two colors.
        *
        * @param {Vector|string} start - The starting color vector or string representation (e.g., "255 0 0").
        * @param {Vector|string} end - The ending color vector or string representation.
        * @param {int|float} t - The interpolation parameter.
        * @returns {string} - The interpolated color string representation (e.g., "128 64 0").
        */
        color = function(start, end, t) {
            if (type(start) == "string") {
                start = StrToVec(start)
            }
            if (type(end) == "string") {
                end = StrToVec(end)
            }

            return abs(int(start.x, end.x, t)) + " " + abs(int(start.y, end.y, t)) + " " + abs(int(start.z, end.z, t))
        },

        /* SLERP for vector */
        sVector = function(start, end, t) {
            local q1 = math.Quaternion().new(start)
            local q2 = math.Quaternion().new(end)
            return q1.slerp(q2, t).toVector()
        }


        /* Performs cubic spline interpolation.
        *
        * @param {float} f - The interpolation parameter.
        * @returns {float} - The interpolated value.
        */
        spline = function( f )
        {
            local fSquared = f * f;
            return 3.0 * fSquared  - 2.0 * fSquared  * f;
        },


        /* Performs smooth interpolation between two values using a smoothstep function.
        *
        * @param {float} edge0 - The lower edge of the interpolation range.
        * @param {float} edge1 - The upper edge of the interpolation range.
        * @param {float} value - The interpolation parameter.
        * @returns {float} - The interpolated value.
        */
        SmoothStep = function(edge0, edge1, value) {
            local t = math.clamp((value - edge0) / (edge1 - edge0), 0.0, 1.0);
            return t * t * (3.0 - 2.0 * t)
        },

        
        /* Performs linear interpolation between two values.
        *
        * @param {float} f1 - The start value.
        * @param {float} f2 - The end value.
        * @param {float} i1 - The start interpolation parameter.
        * @param {float} i2 - The end interpolation parameter.
        * @param {float} value - The interpolation parameter.
        * @returns {float} - The interpolated value.
        */
        FLerp = function( f1, f2, i1, i2, value )
        {
            return f1 + (f2 - f1) * (value - i1) / (i2 - i1);
        }


        // function SmoothCurve(x) {
        //     return ( 1.0  -  cos (x * PI)) *  0.5
        // }


        // function SmoothProgress(progress) {
        //     progress = lerp(-PI/2, PI/2, progress)
        //     progress = sin(progress)
        //     progress = (progress / 2.0) + 0.5
        //     return progress
        // }
    },

    min = function(...) {
        local min = vargv[0]
        for(local i = 0; i< vargc; i++) {
            if(min > vargv[i])
                min = vargv[i]
        }
        
        return min
    },

    max = function(...) {
        local max = vargv[0]
        for(local i = 0; i< vargc; i++) {
            if(vargv[i] > max)
                max = vargv[i]
        }

        return max
    },


    /* Clamps an integer value within the specified range.
    *
    * @param {int|float} int - The value to clamp.
    * @param {int|float} min - The minimum value.
    * @param {int|float} max - The maximum value (optional).
    * @returns {int|float} - The clamped value.
    */
    clamp = function(int, min, max = 99999) { 
        if ( int < min ) return min;
        if ( int > max ) return max;
        return int
    },

    /* Rounds the elements of a vector to the specified precision.
    *
    * @param {Vector} vec - The vector to round.
    * @param {int} int - The precision (e.g., 1000 for rounding to three decimal places).
    * @returns {Vector} - The rounded vector.
    */
    roundVector = function(vec, int = 1000) {
        vec.x = floor(vec.x * int + 0.5) / int
        vec.y = floor(vec.y * int + 0.5) / int
        vec.z = floor(vec.z * int + 0.5) / int
        return vec
    },

    /* Returns the sign of a number.
    *
    * @param {int|float} x - The number.
    * @returns {int} - The sign of the number (-1, 0, or 1).
    */
    Sign = function(x) {
        if (x > 0) {
            return 1;
        } else if (x < 0) {
            return -1;
        } else {
            return 0;
        }
    },

    /* Copies the sign of one value to another.
    *
    * @param {int|float} value - The value to copy the sign to.
    * @param {int|float} sign - The sign to copy.
    * @returns {int|float} - The value with the copied sign.
    */
    copysign = function(value, sign) {
        if (sign < 0) {
            return -value;
        } else {
            return value;
        }
    },


    /* Remaps a value from the range [A, B] to the range [C, D].
    *
    * If A is equal to B, the value will be clamped to C or D depending on its relationship to B.
    *
    * @param {float} val - The value to remap.
    * @param {float} A - The start of the input range.
    * @param {float} B - The end of the input range.
    * @param {float} C - The start of the output range.
    * @param {float} D - The end of the output range.
    * @returns {float} - The remapped value.
    */
    RemapVal = function( val, A, B, C, D )
    {
        if ( A == B )
        {
            if ( val >= B )
                return D;
            return C;
        };
        return C + (D - C) * (val - A) / (B - A);
    },


    rotateVector = function(vector, angle) {
        return math.Quaternion.new(angle).rotate(vector)
    },


    unrotateVector = function(vector, angle) {
        return math.Quaternion.new(angle).unrotate(vector)
    },

    randomVector = function(min, max) {
        if(typeof min == "Vector" && typeof max == "Vector") 
            return Vector(RandomFloat(min.x, max.x), RandomFloat(min.y, max.y), RandomFloat(min.z, max.z))
        return Vector(RandomFloat(min, max), RandomFloat(min, max), RandomFloat(min, max))
    },

    reflectVector = function(dir, normal) {
        return dir - normal * (dir.Dot(normal) * 2)
    },

    clampVector = function(vector, min = 0, max = 255) { // todo
        return Vector(this.clamp(vector.x, min, max), this.clamp(vector.y, min, max), this.clamp(vector.z, min, max)) 
    },

    resizeVector = function(vector, element) {
        local tx = sqrt((vector.x * vector.x) + (vector.y * vector.y) + (vector.z * vector.z))
        return vector * (element / tx)
    }
}