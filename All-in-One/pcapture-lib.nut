/*+--------------------------------------------------------------------------------+
|                           PCapture Vscripts Library                               |
 +---------------------------------------------------------------------------------+
| Author:                                                                           |
|     One-of-a-Kind - laVashik :D                                                   |
 +---------------------------------------------------------------------------------+
| pcapture-lib.nut                                                                  |
|       The main file in the library. Initializes required parts of the library     |
|                                                                                   |
+----------------------------------------------------------------------------------+ */

if (!("self" in this)) {
    self <- Entities.FindByClassname(null, "worldspawn")
} else {
    getroottable()["self"] <- self
}

// Library files
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

math <- {
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
        * @param {Vector/string} start - The starting color vector or string representation (e.g., "255 0 0").
        * @param {Vector/string} end - The ending color vector or string representation.
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
    }
}
/*+--------------------------------------------------------------------------------+
|                           PCapture Vscripts Library                               |
 +---------------------------------------------------------------------------------+
| Author:                                                                           |
|     One-of-a-Kind - laVashik :D                                                   |
 +---------------------------------------------------------------------------------+
| PCapture-array.nut                                                                 |
|       Improved arrays module. Contains easy output in the console                  |
|       and additional features to simplify life                                     |
+----------------------------------------------------------------------------------+ */

if("arrayLib" in getroottable()) {
    dev.warning("Enhanced arrays module initialization skipped. Module already initialized.")
    return
}

/*
* Enhanced arrays module.
*/
class arrayLib {

    /* The internal array. */
    arr = null
    
    /* The internal table representation. */
    table = null;
    
    /* Whether the internal table is valid. */
    tableIsValid = false
    
    /*
    * Constructor.
    *
    * @param {array} array - The initial array.
    */
    constructor(array = []) {
        this.arr = array
        this.table = {}
    }

    /*
    * Create a new arrayLib instance from arguments.
    *
    * @param {...any} vargv - The values for the array.
    * @returns {arrayLib} - The new arrayLib instance. 
    */
    function new(...) {
        local arr = array(vargc)
        for(local i = 0; i< vargc; i++) {
            arr[i] = vargv[i]
        }
        return arrayLib(arr)
    }

    /*
    * Append a value to the array.
    *
    * @param {any} val - The value to append.
    * @returns {int} - The new array length.
    */
    function append(val) {
        this._pushToTable(val)
        arr.append(val);
        return this
    }

    /*
    * Apply a function to each element.
    *
    * @param {Function} func - The function to apply.
    */
    function apply(func) {
        foreach(idx, value in arr) {
            arr[idx] = func(value)
        }
        this.totable(true)
        return this
    }

    /*
    * Clear the array and table.
    */
    function clear() {
        this.arr.clear()
        this.table.clear()
        this.tableIsValid = false
        return this
    }

    /*
    * Extend the array with another array.
    *
    * @param {array} other - The array to extend from.
    */
    function extend(other) {
        if(typeof other == "arrayLib") {
            other = other.arr
        }
        arr.extend(other);
        this.totable(true)
        return this
    }

    /*
    * Filter the array by a predicate function.
    *
    * @param {Function} func(inx, val, newArr) - The predicate function. 
    * @returns {arrayLib} - The filtered array.
    */
    function filter(func) {
        local newArray = arrayLib([])
        foreach(idx, val in arr) {
            if(func(idx, val, newArray))
                newArray.append(val)
        }
        return newArray
    }

    /*
    * Check if the array contains a value.
    *
    * @param {any} match - The value to find.
    * @returns {boolean} - Whether the value is found.
    */
    function find(match) {
        if(!this.tableIsValid) this.totable()
        return match in this.table
    }

    /*
    * Search for a value in the array.
    *
    * @param {any|Function} match - The value or predicate to search for.
    * @returns {int|null} - The index of the match or null.
    */
    function search(match) {
        if(typeof match == "function") {
            foreach(idx, val in arr) {
                if(match(val))
                    return idx
            }
        }
        else {
            foreach(idx, val in arr) {
                if(val == match)
                    return idx
            }
        }

        return null
    }

    /*
    * Insert a value into the array.
    *
    * @param {int} idx - The index to insert at.
    * @param {any} val - The value to insert.
    */
    function insert(idx, val) {
        this._pushToTable(val)
        return arr.insert(idx, val)
    }

    /*
    * Get the array length.
    *
    * @returns {int} - The array length.
    */
    function len() {
        return arr.len()
    }

    /*
    * Map the array to a new array via a function.
    *
    * @param {Function} func - The mapping function.
    * @returns {arrayLib} - The mapped array.
    */
    function map(func) {
        local newArray = array(this.len())
        foreach(idx, value in arr) {
            newArray[idx] = func(value)
        }
        return arrayLib(newArray)
    }

    /*
    * Pop a value off the end of the array.
    *
    * @returns {any} - The popped value.
    */
    function pop() {
        local pop = arr.pop()
        this._deleteFromTable(pop)
        return pop
    }

    /*
    * Append a value to the array.
    *
    * @param {any} val - The value to append.
    */
    function push(val) {
        this.append(val)
    }

    // function reduce(func) {

    // }

    /*
    * Remove an element by index.
    *
    * @param {int} idx - The index to remove.
    */
    function remove(idx) {
        this._deleteFromTable(arr[idx])
        arr.remove(idx);
    }

    /*
    * Resize the array.
    *
    * @param {int} size - The new size.
    * @param {any} fill - The fill value for new slots.
    */
    function resize(size, fill = null) {
        arr.resize(size, fill);
        this.totable(true)
    }

    /*
    * Reverse the array in-place.
    *
    * @returns {arrayLib} - The reversed array.
    */
    function reverse() {
        return arr.reverse();
    }

    /*
    * Slice a portion of the array.
    *
    * @param {int} start - The start index.
    * @param {int} end - The end index.
    * @returns {arrayLib} - The sliced array.
    */
    function slice(start, end = null) {
        return arrayLib(arr.slice(start, end || this.len()))
    }

    /*
    * Sort the array.
    *
    * @param {Function} func - Optional compare function.
    * @returns {arrayLib} - The sorted array.
    */
    function sort(func = null) {
        func ? arr.sort(func) : arr.sort()
        return this
    }

    /*
    * Get the last element.
    *
    * @returns {any} - The last element.
    */
    function top() {
        arr.top();
        return this
    }

    /*
    * Join the array into a string.
    *
    * @param {string} joinstr - The separator string.
    * @returns {string} - The joined string.
    */
    function join(joinstr = "") {
        if(this.len() == 0) return ""
        
        local string = ""
        foreach(elem in this.arr) {
            string += elem + joinstr
        }
        return joinstr.len() != 0 ? string.slice(0, joinstr.len() * -1) : string
    }

    /*
    * Retrieve the element at the specified index in the array.
    *
    * @param {integer} idx - The index of the element to retrieve.
    * @param {any} defaultVal - Optional default value to return if the index is out of bounds. Defaults to null.
    * @returns {any} - The element at the specified index or the default value if the index is out of bounds.
    */
    function get(idx, defaultVal = null) {
        if(this.len() > idx)
            return this.arr[idx]
        return defaultVal
    }

    /*
    * Convert the array to a table.
    *
    * @param {boolean} reacreate - Whether to recreate the table.
    * @returns {table} - The table representation.
    */
    function totable(reacreate = false) {
        if(this.table.len() > 0 && !reacreate) return this.table

        tableIsValid = true
        this.table.clear()
        foreach(element in arr) {
            this.table[element] <- null
        }
        return this.table
    }

    /*
    * Delete a value from the internal table.
    *
    * @param {any} val - The value to delete.
    */
    function _deleteFromTable(val) {
        if(val in this.table)
            this.table.rawdelete(val)
    }

    /*
    * Add a value to the internal table.
    *
    * @param {any} val - The value to add.
    */
    function _pushToTable(val) {
        if(this.table.len() != 0)
            this.table[val] <- null
    }

    /*
    * Convert the array to a string.
    *
    * @returns {string} - The string representation.
    */
    function _tostring() return format("Array: [%s]", this.join(", "))
    
    /*
    * Get the type name.
    *
    * @returns {"arrayLib"}
    */
    function _typeof () return "arrayLib";
    
    /*
    * Get an element by index.
    *
    * @param {int} idx - The index.
    * @returns {any} - The element.
    */
    function _get(idx) return arr[idx];
    
    /*
    * Set an element by index.
    *
    * @param {int} idx - The index.
    * @param {any} val - The new value.
    */
    function _set(idx, val) return arr[idx] = val;


    function _nexti(previdx) {
        if(this.len() == 0) return null
        if (previdx == null) return 0;
		return previdx < this.len() - 1 ? previdx + 1 : null;
	}
}
/*+--------------------------------------------------------------------------------+
|                           PCapture Vscripts Library                               |
 +---------------------------------------------------------------------------------+
| Author:                                                                           |
|     One-of-a-Kind - laVashik :D                                                   |
 +---------------------------------------------------------------------------------+
| PCapture-utils.nut                                                                |
|       A collection of utility functions for script execution and debugging.       |
|       It's a Swiss army knife for developers working with Squirrel :D             |
+----------------------------------------------------------------------------------+ */


RunScriptCode <- {
    /* Creates a delay before executing the specified script.
    * 
    * @param {string|function} script - The script to execute. Can be a function or a string.
    * @param {int|float} runDelay - The delay in seconds.
    * @param {CBaseEntity|pcapEntity} activator - The activator entity. (optional)
    * @param {CBaseEntity|pcapEntity} caller - The caller entity. (optional)
    */
    delay = function(script, runDelay, activator = null, caller = null) {
        if (typeof script == "function")
            return CreateScheduleEvent("global", script, runDelay)

        EntFireByHandle(self, "runscriptcode", script, runDelay, activator, caller)
    },  

    /* Executes a function repeatedly with a specified delay for a given number of loops.
    * 
    * @param {string} func - The function to execute.
    * @param {int|float} runDelay - The delay between each execution in seconds.
    * @param {int|float} loop - The number of loops.
    * @param {string} outputs - The function to execute after all loops completed. (optional)
    */
    loopy = function(func, runDelay, loop, outputs = null) {
        if (loop > 0) {
            this.delay(func, runDelay)
            this.delay("loopy(\"" + func + "\"," + runDelay + "," + (loop - 1) + ",\"" + outputs + "\")", runDelay)
        } else if (outputs)
            this.delay(outputs, 0)
    },

    /* Schedules the execution of a script recursively at a fixed interval.
     *
     * This function schedules the provided script to run repeatedly at a specified interval. After each execution,
     * the function schedules itself to run again, creating a loop that continues until you cancel the event
     *
     * @param {string|function} script - The script to be executed. Can be a function or a string containing code.
     * @param {int|float} runDelay - The time delay between consecutive executions in seconds.
     * @param {string} eventName - The name of the event used for scheduling. (optional, default="global")
     */
    recursive = function(script, runDelay = FrameTime(), eventName = "global") {
        local runAgain = function() : (script, runDelay, eventName) {
            RunScriptCode.recursive(script, runDelay, eventName)
        }
        
        CreateScheduleEvent(eventName, script, runDelay)
        CreateScheduleEvent(eventName, runAgain, runDelay)
    },

    /* Execute a script from a string.
    * 
    * @param {string} str - The script string.
    */
    fromStr = function(str) {
        compilestring(str)()
    }
}


dev <- {
    /* Draws the bounding box of an entity for the specified time.
    * 
    * @param {CBaseEntity|pcapEntity} ent - The entity to draw the bounding box for.
    * @param {int|float} time - The duration of the display in seconds.
    */
    DrawEntityBBox = function(ent, time) {
        DebugDrawBox(ent.GetOrigin(), ent.GetBoundingMins(), ent.GetBoundingMaxs(), 255, 165, 0, 9, time)
    },

    /* Draws a box at the specified vector position for the specified time.
    * 
    * @param {Vector} vector - The position of the box.
    * @param {Vector} color - The color of the box.
    * @param {int|float} time - The duration of the display in seconds. (optional)
    */
    drawbox = function(vector, color, time = 0.05) {
        DebugDrawBox(vector, Vector(-1,-1,-1), Vector(1,1,1), color.x, color.y, color.z, 100, time)
    },


    /* Logs a message to the console only if developer mode is enabled.
    * 
    * @param {string} msg - The message to log.
    */
    log = function(msg) {
        if (developer() != 0)
            printl("• " + msg)
    },

    /* Displays a warning message in a specific format.
    * 
    * @param {string} msg - The warning message.
    */
    warning = function(msg) {
        _more_info("? Warning (%s [%d]): %s", msg)
    },

    /* Displays an error message in a specific format.
    * 
    * @param {string} msg - The error message.
    */
    error = function(msg) {
        _more_info("?? *ERROR*: [func = %s; line = %d] | %s", msg)
        SendToConsole("playvol resource/warning.wav 1")
    },

    /*
    * Formats and prints detailed debug info.
    *
    * @param {string} pattern - Printf pattern 
    * @param {string} msg - The error message
    */  
    _more_info = function(pattern, msg) {
        if (developer() == 0)
            return

        local info = getstackinfos(3)
        local func_name = info.func
        if (func_name == "main" || func_name == "unknown")
            func_name = "file " + info.src

        printl(format(pattern, func_name, info.line, msg))
    }
}


/* Prints a formatted message to the console.
* 
* @param {string} msg - The message string containing `{}` placeholders.
* @param {any} vargs... - Additional arguments to substitute into the placeholders.

*/
function fprint(msg, ...) {

    // If you are sure of what you are doing, you don't have to use it
    local subst_count = 0;
    for (local i = 0; i < msg.len() - 1; i++) {
        if (msg.slice(i, i+2) == "{}") {
            subst_count++; 
        }
    }
    if (subst_count != vargc) {
        throw("Discrepancy between the number of arguments and substitutions")
    }


    local args = array(vargc)
    for(local i = 0; i< vargc; i++) {
        args[i] = vargv[i]
    }

    if (msg.slice(0, 2) == "{}") {
        msg = args[0] + msg.slice(2); 
        args.remove(0); 
    }

    local parts = split(msg, "{}");
    local result = "";

    for (local i = 0; i < parts.len(); i++) {
        result += parts[i];
        if (i < args.len()) {
            result += args[i].tostring();
        }
    }

    printl(result)
}



/* Converts a string to a Vector object.
* 
* @param {string} str - The string representation of the vector, e.g., "x y z".
* @returns {Vector} - The converted vector.
*/
function StrToVec(str) {
    local str_arr = split(str, " ")
    local vec = Vector(str_arr[0].tointeger(), str_arr[1].tointeger(), str_arr[2].tointeger())
    return vec
}


/* Gets the prefix of the entity name.
*
* @returns {string} - The prefix of the entity name.
*/
function GetPrefix(name) {
    local parts = split(name, "-")
    if(parts.len() == 0)
        return name
    
    local lastPartLength = parts.pop().len()
    local prefix = name.slice(0, -lastPartLength)
    return prefix;
}


/* Gets the postfix of the entity name.
*
* @returns {string} - The postfix of the entity name.
*/
function GetPostfix(name) {
    local parts = split(name, "-")
    if(parts.len() == 0)
        return name

    local lastPartLength = parts[0].len();
    local prefix = name.slice(lastPartLength);
    return prefix;
}


/* Precaches a sound script for later use.
* 
* @param {string|array|arrayLib} sound_path - The path to the sound script.
*/
function Precache(sound_path) {
    if(typeof sound_path == "string")
        return self.PrecacheSoundScript(sound_path)
    foreach(path in sound_path)
        self.PrecacheSoundScript(path)
}
/*+--------------------------------------------------------------------------------+
|                           PCapture Vscripts Library                               |
 +---------------------------------------------------------------------------------+
| Author:                                                                           |
|     One-of-a-Kind - laVashik :D                                                   |
 +---------------------------------------------------------------------------------+
| PCapture-entities.nut                                                             |
|       Improved Entities Module. Contains A VERY LARGE number                      |
|       of different functions that you just missed later!                          |
+----------------------------------------------------------------------------------+ */

if("entLib" in getroottable()) {
    dev.warning("entLib module initialization skipped. Module already initialized.")
    return
}


/* Initializes an entity object.
*
* @param {CBaseEntity} entity - The entity object.
* @param {string} type - The type of entity.
* @returns {pcapEntity} - A new entity object.
*/
function init(CBaseEntity) {
    if(!CBaseEntity)
        return null
    return pcapEntity(CBaseEntity)
}

class entLib {
    /* Creates an entity of the specified classname with the provided keyvalues.
    *
    * @param {string} classname - The classname of the entity.
    * @param {table} keyvalues - The key-value pairs for the entity.
    * @returns {pcapEntity} - The created entity object.
    */
    function CreateByClassname(classname, keyvalues = {}) {
        local new_entity = pcapEntity(Entities.CreateByClassname(classname))
        foreach(key, value in keyvalues) {
            new_entity.SetKeyValue(key, value)
        }
        return new_entity
    }

    function CreateProp(classname, origin, modelname, activity = 1, keyvalues = {}) {
        local new_entity = pcapEntity(CreateProp(classname, origin, modelname, activity))
        foreach(key, value in keyvalues) {
            new_entity.SetKeyValue(key, value)
        }
        return new_entity
    }



    /* Finds an entity with the specified classname.
    *
    * @param {string} classname - The classname to search for.
    * @param {CBaseEntity} start_ent - The starting entity to search within.
    * @returns {pcapEntity} - The found entity object.
    */
    function FindByClassname(classname, start_ent = null) {
        if(start_ent && typeof start_ent == "pcapEntity")
            start_ent = start_ent.CBaseEntity
        local new_entity = Entities.FindByClassname(start_ent, classname)
        return init(new_entity)
    }


    /* Finds an entity with the specified classname within a given radius from the origin.
    *
    * @param {string} classname - The classname to search for.
    * @param {Vector} origin - The origin position.
    * @param {int} radius - The search radius.
    * @param {CBaseEntity} start_ent - The starting entity to search within.
    * @returns {pcapEntity} - The found entity object.
    */
    function FindByClassnameWithin(classname, origin, radius, start_ent = null) {
        if(start_ent && typeof start_ent == "pcapEntity")
            start_ent = start_ent.CBaseEntity
        local new_entity = Entities.FindByClassnameWithin(start_ent, classname, origin, radius)
        return init(new_entity)
    }


    /* Finds an entity with the specified targetname within the given starting entity.
    *
    * @param {string} targetname - The targetname to search for.
    * @param {CBaseEntity} start_ent - The starting entity to search within.
    * @returns {pcapEntity} - The found entity object.
    */
    function FindByName(targetname, start_ent = null) {
        if(start_ent && typeof start_ent == "pcapEntity")
            start_ent = start_ent.CBaseEntity
        local new_entity = Entities.FindByName(start_ent, targetname)
        return init(new_entity)
    }


    /* Finds an entity with the specified targetname within a given radius from the origin.
    *
    * @param {string} targetname - The targetname to search for.
    * @param {Vector} origin - The origin position.
    * @param {int} radius - The search radius.
    * @param {CBaseEntity} start_ent - The starting entity to search within.
    * @returns {pcapEntity} - The found entity object.
    */
    function FindByNameWithin(targetname, origin, radius, start_ent = null) {
        if(start_ent && typeof start_ent == "pcapEntity")
            start_ent = start_ent.CBaseEntity
        local new_entity = Entities.FindByNameWithin(start_ent, targetname, origin, radius)
        return init(new_entity)
    }


    /* Finds an entity with the specified model within the given starting entity.
    *
    * @param {string} model - The model to search for.
    * @param {CBaseEntity} start_ent - The starting entity to search within.
    * @returns {pcapEntity} - The found entity object.
    */
    function FindByModel(model, start_ent = null) {
        if(start_ent && typeof start_ent == "pcapEntity")
            start_ent = start_ent.CBaseEntity
        local new_entity = Entities.FindByModel(start_ent, model)
        return init(new_entity)
    }


    /* Finds an entity with the specified model within a given radius from the origin.
    *
    * @param {string} model - The model to search for.
    * @param {Vector} origin - The origin position.
    * @param {int} radius - The search radius.
    * @param {CBaseEntity} start_ent - The starting entity to search within.
    * @returns {pcapEntity} - The found entity object.
    */
    function FindByModelWithin(model, origin, radius, start_ent = null) {
        if(start_ent && typeof start_ent == "pcapEntity")
            start_ent = start_ent.CBaseEntity
        local new_entity = null
        for(local ent; ent = FindByClassnameWithin("*", origin, radius, start_ent);) {
            if(ent.GetModelName() == model && ent != start_ent) {
                new_entity = ent;
                break;
            }
        }

        return init(new_entity)
    }


    /* Finds entities within a sphere defined by the origin and radius.
    *
    * @param {Vector} origin - The origin position of the sphere.
    * @param {int} radius - The radius of the sphere.
    * @param {CBaseEntity} start_ent - The starting entity to search within.
    * @returns {pcapEntity} - The found entity object.
    */
    function FindInSphere(origin, radius, start_ent = null) {
        if(start_ent && typeof start_ent == "pcapEntity")
            start_ent = start_ent.CBaseEntity
        local new_entity = Entities.FindInSphere(start_ent, origin, radius)
        return init(new_entity)
    }


    function FromEntity(CBaseEntity) {
        if(typeof CBaseEntity == "pcapEntity")
            return CBaseEntity
        return init(CBaseEntity)
    }
}




class pcapEntity {
    CBaseEntity = null;
    Scope = {}

    /* Constructor for the entity object.
    *
    * @param {CBaseEntity} entity - The entity object.
    */
    constructor(entity = null) {
        if(typeof entity == "pcapEntity")
            entity = entity.CBaseEntity
            
        if(entity == null) return null

        this.CBaseEntity = entity
        entity.ValidateScriptScope()
    }


    function SetAngles(x, y, z) {
        x = x >= 360 ? 0 : x
        y = y >= 360 ? 0 : y
        z = z >= 360 ? 0 : z
        this.CBaseEntity.SetAngles(x, y, z)
    }

    /* Sets the angles of the entity.
    *
    * @param {Vector} vector - The angle vector.
    */
    function SetAbsAngles(vector) {
        this.CBaseEntity.SetAngles(vector.x, vector.y, vector.z)
    }


    /* Destroys the entity. */
    function Destroy() {
        this.CBaseEntity.Destroy()
        this.CBaseEntity = null
    }


    /* Kills the entity.
    *
    * @param {int|float} fireDelay - Delay in seconds before applying.
    */
    function Kill(fireDelay = 0) {
        EntFireByHandle(CBaseEntity, "kill", "", fireDelay)
        this.CBaseEntity = null
    }


    function Dissolve() {
        dissolver.SetKeyValue("target", this.GetName())
        EntFireByHandle(dissolver, "dissolve")
    }


    /* Checks if the entity is valid.
    *
    * @returns {bool} - True if the entity is valid, false otherwise.
    */
    function IsValid() {
        return this.CBaseEntity && this.CBaseEntity.IsValid()
    }


    /* Checks if this entity is the player entity.
    * 
    * @returns {bool} - True if this entity is the player, false otherwise.
    */
    function IsPlayer() {
        return this.CBaseEntity == GetPlayer()
    }


    /* Sets the key-value pair of the entity.  
    *
    * @param {string} key - The key of the key-value pair.
    * @param {int|float|Vector|string} value - The value of the key-value pair.
    */
    function SetKeyValue(key, value) {
        switch (typeof value) {
            case "integer":
                this.CBaseEntity.__KeyValueFromInt(key, value);
                break;
            case "float":
                this.CBaseEntity.__KeyValueFromFloat(key, value);
                break;
            case "Vector":
                this.CBaseEntity.__KeyValueFromVector(key, value);
                break;
            default:
                this.CBaseEntity.__KeyValueFromString(key, value.tostring());
        }

        this.SetUserData(key, value)
    }


    /* Sets the outputs of the entity.  (TODO improve description)
    *
    * @param {string} outputName - Output named
    * @param {string} target - Targets entities named
    * @param {string} input - Via this input
    * @param {string} param - with a parameter ovveride of
    * @param {int|float} delay - Delay in seconds before applying.
    * @param {int} fires - 
    */
    function addOutput(outputName, target, input, param = "", delay = 0, fires = -1) {
        this.SetKeyValue(outputName, target + "\x001B" + input + "\x001B" + param + "\x001B" + delay + "\x001B" + fires)
    }


    /* Sets the targetname of the entity.
    *
    * @param {string} name - The targetname to be set.
    */
    function SetName(name) {
        this.SetKeyValue("targetname", name)
    }


    /* Sets the parent of the entity.
    *
    * @param {string|CBaseEntity|pcapEntity} parent - The parent entity object.
    * @param {int|float} fireDelay - Delay in seconds before applying.
    */
    function SetParent(parentEnt, fireDelay = 0) {
        this.SetUserData("parent", parentEnt)
        if(typeof parentEnt == "pcapEntity" || typeof parentEnt == "instance") {
            if(parentEnt.GetName() == "") {
                parentEnt.SetName(UniqueString("parent"))
            }
            parentEnt = parentEnt.GetName()
        }
        
        EntFireByHandle(this.CBaseEntity, "SetParent", parentEnt, fireDelay)
    }


    /* Sets the collision of the entity.
    *
    * @param {int} solid - The type of collision.
    * @param {int|float} fireDelay - Delay in seconds before applying.
    */
    function SetCollision(solid, fireDelay = 0) {
        EntFireByHandle(this.CBaseEntity, "SetSolidtype", solid.tostring(), fireDelay, null, null)
        this.SetUserData("Solidtype", solid)
    }


    /* Sets the collision group of the entity.
    *
    * @param {int} collisionGroup - The collision group.
    */
    function SetCollisionGroup(collisionGroup) {
        this.SetKeyValue("CollisionGroup", collisionGroup)
        this.SetUserData("CollisionGroup", collisionGroup)
    }
    

    /* Start playing animation
    *
    * @param {string} animationName - Animation name.
    * @param {int|float} fireDelay - Delay in seconds before applying.
    */
    function SetAnimation(animationName, fireDelay) {
        EntFireByHandle(this.CBaseEntity, "SetAnimation", animationName, fireDelay)
        this.SetUserData("animation", animationName)
    }


    /* Sets the alpha of the entity.
    *
    * @param {int} opacity - The alpha value.
    * @param {int|float} fireDelay - Delay in seconds before applying.
    * Note: Don't forgot for "rendermode" use 5
    */
    function SetAlpha(opacity, fireDelay = 0) {
        EntFireByHandle(this.CBaseEntity, "Alpha", opacity.tostring(), fireDelay, null, null)
        this.SetUserData("alpha", opacity)
    }


    /* Sets the color of the entity.
    *
    * @param {string|Vector} colorValue - The color value.
    * @param {int|float} fireDelay - Delay in seconds before applying.
    */
    function SetColor(colorValue, fireDelay = 0) {
        if(typeof colorValue == "Vector") 
            colorValue = colorValue.toString()
        EntFireByHandle(this.CBaseEntity, "Color", colorValue, fireDelay, null, null)
        this.SetUserData("color", colorValue)
    }


    /* Sets the skin of the entity.
    *
    * @param {int} skin - The skin number.
    * @param {int|float} fireDelay - Delay in seconds before applying.
    */
    function SetSkin(skin, fireDelay = 0) {
        EntFireByHandle(this.CBaseEntity, "skin", skin.tostring(), fireDelay, null, null)
        this.SetUserData("skin", skin)
    }


    /* Sets whether the entity should be drawn or not. 
    *
    * @param {bool} isEnabled - True to enable drawing, false to disable.
    * @param {int|float} fireDelay - Delay in seconds before applying.
    */
    function SetDrawEnabled(isEnabled, fireDelay = 0) {
        if(isEnabled) {
            EntFireByHandle(this.CBaseEntity, "EnableDraw", "", fireDelay)
        }
        else {
            EntFireByHandle(this.CBaseEntity, "DisableDraw", "", fireDelay)
        }
        
    }

    /* Sets the spawnflags for the entity.
    *
    * @param {int} flag - The spawnflags value to set.
    */
    function SetSpawnflags(flag) {
        this.SetKeyValue("CollisionGroup", flag)
        this.SetUserData("spawnflags", flag)
    }


    /* Sets the scale of the entity.
    *
    * @param {int} scaleValue - The scale value.
    * @param {int|float} fireDelay - Delay in seconds before applying.
    */
    function SetModelScale(scaleValue, fireDelay = 0) {
        EntFireByHandle(this.CBaseEntity, "addoutput", "ModelScale " + scaleValue, fireDelay, null, null)
        this.SetUserData("ModelScale", scaleValue)
    }


    /* Sets the center of the entity.
    *
    * @param {Vector} vector - The center vector.
    */
    function SetCenter(vector) {
        local offset = this.CBaseEntity.GetCenter() - this.CBaseEntity.GetOrigin()
        this.CBaseEntity.SetAbsOrigin( vector - offset )
    }

    /* Sets the bounding box of the entity.
    *
    * @param {Vector|string} min - The minimum bounds vector or a string representation of the vector.
    * @param {Vector|string} max - The maximum bounds vector or a string representation of the vector.
    */
    function SetBBox(minBounds, maxBounds) {
        // Please specify the data type of `min` and `max` to improve the documentation accuracy.
        if (type(minBounds) == "string") {
            minBounds = StrToVec(minBounds)
        }
        if (type(maxBounds) == "string") {
            maxBounds = StrToVec(maxBounds)
        }

        this.CBaseEntity.SetSize(minBounds, maxBounds)
    }


    /* Stores an arbitrary value associated with the entity.
    *
    * @param {string} name - The name of the value.  
    * @param {any} value - The value to store.
    */
    function SetUserData(name, value) {
        this.CBaseEntity.GetScriptScope()[name.tolower()] <- value
    }


    /* Gets a stored user data value.
    *
    * @param {string} name - The name of the value to get.
    * @returns {any} - The stored value, or null if not found.
    */ 
    function GetUserData(name) {
        local Scope = this.CBaseEntity.GetScriptScope()
        name = name.tolower()
        if(name in Scope)
            return Scope[name]
        return null
    }


    /* Gets the bounding box of the entity.
    *
    * @returns {table} - The minimum bounds and maximum bounds of the entity.
    */
    function GetBBox() {
        local max = GetBoundingMaxs()
        local min = GetBoundingMins()
        return {min = min, max = max}
    }


    /* Returns the axis-aligned bounding box (AABB) of the entity.
    *
    * @returns {table} - The minimum bounds, maximum bounds, and center of the entity.
    */ 
    function GetAABB() {
        local max = CreateAABB(7)
        local min = CreateAABB(0)
        local center = CreateAABB( 4)
        return {min = min, center = center, max = max}
    }


    /* Gets the index of the entity.
     *
     * @returns {int} - The index of the entity.
    */
    function GetIndex() {
        return this.CBaseEntity.entindex()
    }


    /* Gets the value of the key-value pair of the entity 
    * Note: only works if you used the SetKeyValue function!
    *
    * @param {string} key - The key of the key-value pair.
    * @returns {any} - The value of the key-value pair.
    */
    function GetKeyValue(key) {
        local value = this.GetUserData(key)
        if(value != null)
            return value

        switch(key) {
            case "model":
                return this.GetModelName()
                break
            case "health":
                return this.GetHealth()
                break
            case "targetname":
                return this.GetName()
                break
        }

        return null
    }


    /* Gets the spawnflags for the entity.
    * Note: only works if you used the SetKeyValue function!
    *
    * @returns {int|null} - The spawnflags value.
    */ 
    function GetSpawnflags() {
        return this.GetUserData("spawnflags")
    }


    /* Gets the alpha/opacity value of the entity.
    * Note: only works if you used the SetKeyValue function!
    * 
    * @returns {int|null} - The alpha value.
    */
    function GetAlpha() {
        local alpha = this.GetUserData("alpha")
        return alpha != null ? alpha : 255
    }


    /* Gets the color value of the entity.
    * Note: only works if you used the SetKeyValue function!
    *
    * @returns {string|null} - The color value.
    */
    function GetColor() {
        local color = this.GetUserData("color")
        return color ? color : "255 255 255"
    }


    function GetSkin() {
        local skin = this.GetUserData("skin")
        return skin ? skin : 0
    }


    /* Gets the prefix of the entity name.
    *
    * @returns {string} - The prefix of the entity name.
    */
    function GetNamePrefix() {
        return GetPrefix(this.GetName())
    }


    /* Gets the postfix of the entity name.
    *
    * @returns {string} - The postfix of the entity name.
    */
    function GetNamePostfix() {
        return GetPostfix(this.GetName())
    }


    /* Converts the entity object to a string.
    *
    * @returns {string} - The string representation of the entity.
    */
    function _tostring() {
        return "pcapEntity: " + this.CBaseEntity + ""
    }


    /* Returns the type of the entity object.
    *
    * @returns {string} - The type of the entity object.
    */
    function _typeof() {
        return "pcapEntity"
    }


    /* Gets the oriented bounding box of the entity.
    *
    * @param {int} stat - 0 for min bounds, 7 for max bounds, 4 for center bounds. 
    * @returns {Vector} - The bounds vector.
    */
    function CreateAABB(stat) { 
        local angles = this.GetAngles()
        if(stat == 4) 
            angles = Vector(45, 45, 45)

        local all_vertex = {
            v = this.getBBoxPoints()
            x = []
            y = []
            z = []
        }

        foreach(v in all_vertex.v)
        {
            all_vertex.x.append(v.x)
            all_vertex.y.append(v.y)
            all_vertex.z.append(v.z)
        }
        all_vertex.x.sort()
        all_vertex.y.sort()
        all_vertex.z.sort()
        
        if(stat == 4)
            return ( Vector(all_vertex.x[7], all_vertex.y[7], all_vertex.z[7]) - Vector(all_vertex.x[0], all_vertex.y[0], all_vertex.z[0]) ) * 0.5
        return Vector(all_vertex.x[stat], all_vertex.y[stat], all_vertex.z[stat])
    }


    /* Gets the 8 vertices of the axis-aligned bounding box.
    *
    * @returns {Array<Vector>} - The 8 vertices of the bounding box.  
    */
    function getBBoxPoints() {
        local BBmax = this.GetBoundingMaxs();
        local BBmin = this.GetBoundingMins();
        local angles = this.GetAngles()
    
        return [
            _GetVertex(BBmin, BBmin, BBmin, angles), _GetVertex(BBmin, BBmin, BBmax, angles),
            _GetVertex(BBmin, BBmax, BBmin, angles), _GetVertex(BBmin, BBmax, BBmax, angles),
            _GetVertex(BBmax, BBmin, BBmin, angles), _GetVertex(BBmax, BBmin, BBmax, angles),
            _GetVertex(BBmax, BBmax, BBmin, angles), _GetVertex(BBmax, BBmax, BBmax, angles)
        ]
    }


    /* Gets one vertex of the bounding box based on x, y, z bounds.
    * 
    * @param {Vector} x - The x bounds.
    * @param {Vector} y - The y bounds.  
    * @param {Vector} z - The z bounds.
    * @param {Vector} ang - The angle vector.
    * @returns {Vector} - The vertex.
    */
    function _GetVertex(x, y, z, ang) {
        // return rotate(Vector(x.x, y.y, z.z), ang)
        return math.rotateVector(Vector(x.x, y.y, z.z), ang)
    }
}

function pcapEntity::ConnectOutput(output, func_name) this.CBaseEntity.ConnectOutput(output, func_name)
function pcapEntity::DisconnectOutput(output, func_name) this.CBaseEntity.DisconnectOutput(output, func_name)
function pcapEntity::EmitSound(sound_name) this.CBaseEntity.EmitSound(sound_name)
function pcapEntity::PrecacheSoundScript(sound_name) this.CBaseEntity.PrecacheSoundScript(sound_name)
function pcapEntity::IsSequenceFinished() return this.CBaseEntity.IsSequenceFinished()
function pcapEntity::SpawnEntity() this.CBaseEntity.SpawnEntity()

function pcapEntity::GetAngles() return this.CBaseEntity.GetAngles()
function pcapEntity::GetAngularVelocity() return this.CBaseEntity.GetAngularVelocity()
function pcapEntity::GetBoundingMaxs() return this.CBaseEntity.GetBoundingMaxs()
function pcapEntity::GetBoundingMins() return this.CBaseEntity.GetBoundingMins()
function pcapEntity::GetCenter() return this.CBaseEntity.GetCenter()
function pcapEntity::GetClassname() return this.CBaseEntity.GetClassname()
function pcapEntity::GetForwardVector() return this.CBaseEntity.GetForwardVector()
function pcapEntity::GetHealth() return this.CBaseEntity.GetHealth()
function pcapEntity::GetLeftVector() return this.CBaseEntity.GetLeftVector()
function pcapEntity::GetMaxHealth() return this.CBaseEntity.GetMaxHealth()
function pcapEntity::GetModelKeyValues() return this.CBaseEntity.GetModelKeyValues()
function pcapEntity::GetModelName() return this.CBaseEntity.GetModelName()
function pcapEntity::GetName() return this.CBaseEntity.GetName()
function pcapEntity::GetOrigin() return this.CBaseEntity.GetOrigin()
function pcapEntity::GetScriptId() return this.CBaseEntity.GetScriptId()
function pcapEntity::GetUpVector() return this.CBaseEntity.GetUpVector()
function pcapEntity::GetPartnername() return this.CBaseEntity.GetPartnername()
function pcapEntity::GetPartnerInstance() return this.CBaseEntity.GetPartnerInstance()
function pcapEntity::ValidateScriptScope() return this.CBaseEntity.ValidateScriptScope()
function pcapEntity::EyePosition() return this.CBaseEntity.EyePosition()

function pcapEntity::SetAbsOrigin(vector) this.CBaseEntity.SetAbsOrigin(vector)
function pcapEntity::SetForwardVector(vector) this.CBaseEntity.SetForwardVector(vector)
function pcapEntity::SetHealth(health) this.CBaseEntity.SetHealth(health)
function pcapEntity::SetMaxHealth(health) this.CBaseEntity.SetMaxHealth(health)
function pcapEntity::SetModel(model_name) this.CBaseEntity.SetModel(model_name)
function pcapEntity::SetOrigin(vector) this.CBaseEntity.SetOrigin(vector)


// add CBaseEnts check with pcapEntity
/*+--------------------------------------------------------------------------------+
|                           PCapture Vscripts Library                               |
 +---------------------------------------------------------------------------------+
| Author:                                                                           |
|     One-of-a-Kind - laVashik :D                                                   |
 +---------------------------------------------------------------------------------+
| PCapture-EventHandler.nut                                                             |
|       Improved EntFire/logic_relay/loop module. Allows you to create whole events     |
|       from many different events and cancel them at any time, unlike EntFireByHandler.|
|       Able to take not only string, but also full-fledged functions                   |
+----------------------------------------------------------------------------------+ */

if("CreateScheduleEvent" in getroottable()) {
    dev.warning("EventHandler module initialization skipped. Module already initialized.")
    return
}

// Object to store scheduled events 
scheduledEventsList <- {global = []}
// Var to track if event loop is running
isEventLoopRunning <- false


/*
 * Creates a new scheduled event.
 * 
 * @param {string} eventName - Name of the event. 
 * @param {string|function} action - Action to execute for event.
 * @param {int|float} timeDelay - Delay in seconds before executing event.
 * @param {string} note - Optional note about the event, if needed.
*/
function CreateScheduleEvent(eventName, action, timeDelay, note = null)
{
    if ( !(eventName in scheduledEventsList) )
    {
        scheduledEventsList[eventName] <- []
        // dev.log("Created new Event - " + eventName)
    }

    local newScheduledEvent = {action = action, timeDelay = (Time() + timeDelay), note = note}
    local currentEventList = scheduledEventsList[eventName]

    local lastIndex = currentEventList.len() - 1
    while (lastIndex >= 0 && currentEventList[lastIndex].timeDelay > newScheduledEvent.timeDelay)
    {
        lastIndex--
    }
    currentEventList.insert(lastIndex + 1, newScheduledEvent)

    if(!isEventLoopRunning)
    {
        isEventLoopRunning = true
        ExecuteScheduledEvents()
    }
}

/*
 * Executes scheduled events when their time is up
*/
function ExecuteScheduledEvents() {
    if(scheduledEventsList.len() == 1 && scheduledEventsList.global.len() == 0)
        return isEventLoopRunning = false

    foreach(eventName, eventInfo in scheduledEventsList)
    {
        if(eventInfo.len() == 0 && eventName != "global")
            cancelScheduledEvent(eventName)
        
        while (eventInfo.len() > 0 && Time() >= eventInfo[0].timeDelay) 
        {
            local event = eventInfo[0]
            // printl(("eventName : "+eventName+", event: "+event.action+", timeDelay: "+event.timeDelay+", Time(): "+Time())) //DEV CODE
            if(typeof event.action == "string") {
                // try {
                    compilestring( event.action )()
                // }
                // catch(exception) {
                    // dev.error(exception + "! Event action: " + event.action)
                // }
            }
            else if(typeof event.action == "function" || typeof event.action == "native function"){
                event.action() 
            }
            else {
                dev.warning("Unable to process event " + event.action + " in event " + eventName)
            }
            eventInfo.remove(0) 
        }
    }

    RunScriptCode.delay("ExecuteScheduledEvents()", FrameTime())
}

/*
* Cancels a scheduled event with the given name.
* 
* @param {string} eventName - Name of event to cancel.
* @param {int|float} delay - Delay in seconds before event cancelation
*/
function cancelScheduledEvent(eventName, delay = 0) 
{
    if(eventName == "global")
        return dev.warning("The global event cannot be closed!")
    if(!(eventName in scheduledEventsList))
        return dev.error("There is no event named " + eventName)

    if(delay == 0)
        scheduledEventsList.rawdelete(eventName)
    else {
        return CreateScheduleEvent("global", format("cancelScheduledEvent(\"%s\")", eventName), delay)
    }
        
    // Debug info
    // if(GetDeveloperLevel() > 0) {
    //     local test = ""
    //     foreach(k, i in scheduledEventsList)
    //         test += k + ", "

    //     test = test.slice(0, -2)
    //     dev.log(format("Event \"%s\" closed. Actial events: %s", eventName, test))
    // }
}

/*
 * Gets info about a scheduled event.
 * 
 * @param {string} eventName - Name of event to get info for.
 * @returns {table|null} - The event info object or null if not found.
*/
function getEventInfo(eventName)
{
    local event = null
    if(eventName in scheduledEventsList)
        event = scheduledEventsList[eventName]
    return event
}

/*
 * Checks if event is valid
 * 
 * @param {string} eventName - Name of event to get info for.
 * @returns {bool} - Object exists or not.
*/
function eventIsValid(eventName) {
    return eventName in scheduledEventsList && scheduledEventsList[eventName].len() != 0
}


function getEventNote(eventName) {
    local info = getEventInfo(eventName)
    if(!info || info.len() == 0) 
        return null
    
    foreach(event in info) {
        if(event.note)
            return event.note
    }
    
    return null
}
/*+--------------------------------------------------------------------------------+
|                           PCapture Vscripts Library                               |
 +---------------------------------------------------------------------------------+
| Author:                                                                           |
|     One-of-a-Kind - laVashik :D                                                   |
 +---------------------------------------------------------------------------------+
| PCapture-bboxcast.nut                                                             |
|       Improved BBoxCast. More info here:                                          |
|       https://github.com/IaVashik/portal2-BBoxCast                                |
+----------------------------------------------------------------------------------+ */

if("bboxcast" in getroottable()) {
    dev.warning("Animate module initialization skipped. Module already initialized.")
    return
}

/*
* Default settings for bboxcast traces.
*/  
::defaultSettings <- {  //  TODO make as a class
    ignoreClass = arrayLib.new("info_target", "viewmodel", "weapon_", "func_illusionary", "info_particle_system",
    "trigger_", "phys_", "env_sprite", "point_", "vgui_", "physicsclonearea", "env_beam", "func_breakable"),
    priorityClass = arrayLib.new("linked_portal_door"),
    customFilter = null,      // function(ent) {return false},
    ErrorCoefficient = 500,
    // enablePortalTracing = false 
}

/*
* A class for performing bbox-based ray tracing in Portal 2.
*/
class bboxcast {
    startpos = null;
    endpos = null;
    hitpos = null;
    hitent = null;
    surfaceNormal = null;
    ignoreEnt = null;
    traceSettings = null;
    PortalFound = [];

    /*
    * Constructor.
    *
    * @param {Vector} startpos - Start position.
    * @param {Vector} endpos - End position.
    * @param {CBaseEntity|pcapEntity|array|arrayLib} ignoreEnt - Entity to ignore. 
    * @param {object} settings - Trace settings.
    */
    constructor(startpos, endpos, ignoreEnt = null, settings = ::defaultSettings) {
        this.startpos = startpos;
        this.endpos = endpos;
        this.ignoreEnt = ignoreEnt
        this.traceSettings = _checkSettings(settings)
        local result = this.Trace(startpos, endpos, ignoreEnt)
        this.hitpos = result.hit
        this.hitent = result.ent
    }

    /*
    * Get the starting position.
    *
    * @returns {Vector} Start position.
    */
    function GetStartPos() {
        return startpos
    }

    /*
    * Get the ending position.
    * 
    * @returns {Vector} End position.
    */
    function GetEndPos() {
        return endpos
    }

     /*
    * Get the hit position.
    *
    * @returns {Vector} Hit position. 
    */
    function GetHitpos() {
        return hitpos
    }

    /*
    * Get the hit entity.
    *
    * @returns {Entity} Hit entity.
    */
    function GetEntity() {
        return entLib.FromEntity(hitent)
    }

    /*
    * Get entities to ignore.
    *
    * @returns {Entity|array} Ignored entities.
    */
    function GetIngoreEntities() {
        return ignoreEnt
    }

    /*
    * Check if the trace hit anything.
    *
    * @returns {boolean} True if hit.
    */
    function DidHit() {
        return GetFraction() != 1
    }

    /*
    * Check if the trace hit the world.
    *
    * @returns {boolean} True if hit world.
    */
    function DidHitWorld() {
        return (!hitent && DidHit())
    }

    /*
    * Get the fraction of the path traversed.
    *
    * @returns {float} Path fraction.
    */
    function GetFraction() {
        return _GetDist(startpos, hitpos) / _GetDist(startpos, endpos)
    }

    /*
    * Get the surface normal at the impact point.
    *
    * @returns {Vector} Surface normal. 
    */
    function GetImpactNormal() { 
        // If the surface normal is already calculated, return it
        if(surfaceNormal)
            return surfaceNormal

        local intersectionPoint = this.hitpos

        // Calculate the normalized direction vector from startpos to hitpos
        local dir = (this.hitpos - this.startpos).normalize()

        // Calculate offset vectors perpendicular to the trace direction
        local perpDir = Vector(-dir.y, dir.x, 0)
        local offset1 = perpDir
        local offset2 = dir.Cross(offset1)

        // Calculate new start positions for two additional traces
        local newStart1 = this.startpos + offset1
        local newStart2 = this.startpos + offset2

        // Perform two additional traces to find intersection points
        local intersectionPoint1
        local intersectionPoint2
        // if(this.GetEntity()) {
        //     local normalSetting = {
        //         ignoreClass = ["*"],
        //         priorityClass = [this.GetEntity().GetClassname()],
        //         ErrorCoefficient = 3000,
        //     }
        //     intersectionPoint1 = bboxcast(newStart1, newStart1 + dir * 8000, this.ignoreEnt, normalSetting).GetHitpos()
        //     intersectionPoint2 = bboxcast(newStart2, newStart2 + dir * 8000, this.ignoreEnt, normalSetting).GetHitpos()
        // }
        // else {
            intersectionPoint1 = _TraceEnd(newStart1, newStart1 + dir * 8000)
            intersectionPoint2 = _TraceEnd(newStart2, newStart2 + dir * 8000)
        // }

        // Calculate two edge vectors from intersection point to hitpos
        local edge1 = intersectionPoint1 - intersectionPoint;
        local edge2 = intersectionPoint2 - intersectionPoint;

        // Calculate the cross product of the two edges to find the normal vector
        this.surfaceNormal = edge2.Cross(edge1).normalize()

        return this.surfaceNormal
    }



    /*
    * Perform the main trace.
    *
    * @param {Vector} startpos - Start position.
    * @param {Vector} endpos - End position.
    * @param {Entity} ignoreEnt - Entity to ignore.
    * @returns {object} Trace result.
    */
    function Trace(startpos, endpos, ignoreEnt) {
        // Get the hit position from the fast trace
        local hitpos = _TraceEnd(startpos, endpos)
        // Calculate the distance between start and hit positions
        local dist = hitpos - startpos
        // Calculate a distance coefficient for more precise tracing based on distance and error coefficient
        local dist_coeff = abs(dist.Length() / traceSettings.ErrorCoefficient) + 1
        // Calculate the number of steps based on distance and distance coefficient
        local step = dist.Length() / 14 / dist_coeff

        // Iterate through each step
        for (local i = 0.0; i < step; i++) {
            // Calculate the ray position for the current step
            local Ray_part = startpos + dist * (i / step)
            // Find the entity at the ray point
            for (local ent;ent = Entities.FindByClassnameWithin(ent, "*", Ray_part, 5 * dist_coeff);) {
                if (ent && _checkEntityIsIgnored(ent, ignoreEnt)) {
                    return {hit = Ray_part, ent = ent}
                }
            }
        }

        return {hit = hitpos, ent = null}
    }

    // Check if an entity should be ignored based on the provided settings
    /*
    * Check if entity is a priority class.
    *
    * @param {string} entityClass - Entity class name.
    * @returns {boolean} True if priority.
    */
    function _isPriorityEntity(entityClass) {
        return traceSettings.priorityClass.find(entityClass)
    }

    /* 
    * Check if entity is an ignored class.
    *
    * @param {string} entityClass - Entity class name.
    * @returns {boolean} True if ignored.
    */
    function _isIgnoredEntity(entityClass) {
        return traceSettings.ignoreClass.find(entityClass) && !_isPriorityEntity(entityClass)
    }

    /*
    * Check if entity should be ignored.
    *
    * @param {Entity} ent - Entity to check.
    * @param {Entity|array} ignoreEnt - Entities being ignored. 
    * @returns {boolean} True if should ignore.
    */
    function _checkEntityIsIgnored(ent, ignoreEnt) {
        if(typeof ignoreEnt == "pcapEntity")
            ignoreEnt = ignoreEnt.CBaseEntity

        local classname = ent.GetClassname()

        if(traceSettings.customFilter && traceSettings.customFilter(ent))
            return false

        if (typeof ignoreEnt == "array" || typeof ignoreEnt == "arrayLib") {
            foreach (mask in ignoreEnt) {
                if(typeof mask == "pcapEntity")
                    mask = mask.CBaseEntity
                if (mask == ent) {
                    return false;
                }
            }
        } 
        else if (ent == ignoreEnt) {
            return false;
        }

        if (traceSettings.ignoreClass.find("*")) {
            if(!_isPriorityEntity(classname))
                return false
        }
        else {
            if (_isIgnoredEntity(classname)) {
                return false
            }
            else {
                local classType = split(classname, "_")[0] + "_"
                if(_isIgnoredEntity(classType))
                    return false
            }
        }


        return true
    }

    // Calculate the distance between two points
    function _GetDist(start, end) {
        return (start - end).Length()
    }

    // Internal function
    function _TraceEnd(startpos,endpos) {
        return startpos + (endpos - startpos) * (TraceLine(startpos, endpos, null))
    }

    function _checkSettings(inputSettings) {
        // Check if settings is already in the correct format
        if (inputSettings.len() == 5)
            return inputSettings
            
        // Check and assign default values if missing
        if (!("ignoreClass" in inputSettings)) {
            inputSettings["ignoreClass"] <- ::defaultSettings["ignoreClass"]
        }
        if (!("priorityClass" in inputSettings)) {
            inputSettings["priorityClass"] <- ::defaultSettings["priorityClass"]
        }   
        if (!("ErrorCoefficient" in inputSettings)) {
            inputSettings["ErrorCoefficient"] <- ::defaultSettings["ErrorCoefficient"]
        }
        if (!("customFilter" in inputSettings)) {
            inputSettings["customFilter"] <- ::defaultSettings["customFilter"]
        }
    
        // Convert arrays to tables
        if(typeof inputSettings["ignoreClass"] == "array")
            inputSettings["ignoreClass"] = arrayLib(inputSettings["ignoreClass"])
        if(typeof inputSettings["priorityClass"] == "array")
            inputSettings["priorityClass"] = arrayLib(inputSettings["priorityClass"]) 
    
        return inputSettings
    }

    // Convert the bboxcast object to string representation
    function _tostring() {
        return "Bboxcast 2.0 | \nstartpos: " + startpos + ", \nendpos: " + endpos + ", \nhitpos: " + hitpos + ", \nent: " + hitent + "\n========================================================="
    }
}

// PRESETS

/*
* Perform trace from player's eyes.
*
* @param {float} distance - Trace distance.
* @param {Entity} ignoreEnt - Entity to ignore.  
* @param {object} settings - Trace settings.
* @param {Entity} player - Player entity.
* @returns {bboxcast} Resulting trace. 
*/
function bboxcast::TracePlayerEyes(distance, ignoreEnt = null, settings = ::defaultSettings, player = null) { // TODO ????????????????? ????????? CO-OP!
    // Get the player's eye position and forward direction
    if(player == null) 
        player = GetPlayerEx()
    if(!player) 
        return bboxcast(Vector(), Vector())
    if(typeof player != "pcapEntity") 
        player = entLib.FromEntity(player)
    
    local eyePointEntity = player.GetUserData("Eye")
    local eyePosition = eyePointEntity.GetOrigin()
    local eyeDirection = eyePointEntity.GetForwardVector()

    // Calculate the start and end positions of the trace
    local startpos = eyePosition
    local endpos = eyePosition + eyeDirection * distance

    // Check if any entities should be ignored during the trace
    if (ignoreEnt) {
        // If ignoreEnt is an array, append the player entity to it
        if (type(ignoreEnt) == "array" || typeof ignoreEnt == "arrayLib") {
            ignoreEnt.append(player)
        }
        // If ignoreEnt is a single entity, create a new array with both the player and ignoreEnt
        else {
            ignoreEnt = [player, ignoreEnt]
        }
    }
    // If no ignoreEnt is provided, ignore the player only
    else {
        ignoreEnt = player
    }

    // Perform the bboxcast trace and return the trace result
    return bboxcast(startpos, endpos, ignoreEnt, settings)
}



/*
* Store disabled entities' bounding boxes.
*/   
disabled_entity <- {}

/*
* Disable entity by setting size to 0. 
*
* @param {Entity} ent - Entity to disable.
*/
function CorrectDisable(ent = null) {
    if(!ent)
        ent = caller
    if(typeof ent == "string")
        ent = Entities.FindByName(null, ent)

    EntFireByHandle(ent, "Disable", "", 0, null, null)
    local entIndex = ent.entindex.tostring()
    if( !(entIndex in disabled_entity)) {
        disabled_entity[entIndex] <- {min = ent.GetBoundingMins(), max = ent.GetBoundingMaxs()}
    }
    ent.SetSize(Vector(), Vector())
}


/*
* Enable previously disabled entity.
*  
* @param {Entity} ent - Entity to enable. 
*/
function CorrectEnable(ent = null) {
    if(!ent)
        ent = caller
    if(typeof ent == "string")
        ent = Entities.FindByName(null, ent)

    EntFireByHandle(ent, "Enable", "", 0, null, null)
    local entIndex = ent.entindex.tostring()
    if( entIndex in disabled_entity ) {
        local BBox = disabled_entity[entIndex]
        ent.SetSize(BBox.min, BBox.max)
    }
}


for(local player; player = entLib.FindByClassname("player", player);) {
    if(player.GetUserData("Eye")) return

    eyeControlEntity <- Entities.CreateByClassname( "logic_measure_movement" )
    local controlName = "eyeControl" + UniqueString()
    eyeControlEntity.__KeyValueFromString("targetname", controlName)
    eyeControlEntity.__KeyValueFromInt("measuretype", 1)

    eyePointEntity <- Entities.CreateByClassname( "info_target" )
    local eyeName = "eyePoint" + UniqueString()
    eyePointEntity.__KeyValueFromString("targetname", eyeName)

    local playerName = player.GetName() == "" ? "!player" : player.GetName()

    EntFireByHandle(eyeControlEntity, "setmeasuretarget", playerName, 0, null, null)
    EntFireByHandle(eyeControlEntity, "setmeasurereference", controlName, 0, null, null);
    EntFireByHandle(eyeControlEntity, "SetTargetReference", controlName, 0, null, null);
    EntFireByHandle(eyeControlEntity, "Settarget", eyeName, 0, null, null);
    EntFireByHandle(eyeControlEntity, "Enable", "", 0, null, null)

    player.SetUserData("Eye", eyePointEntity)
}

/*+--------------------------------------------------------------------------------+
|                           PCapture Vscripts Library                               |
 +---------------------------------------------------------------------------------+
| Author:                                                                           |
|     One-of-a-Kind - laVashik :D                                                   |
 +---------------------------------------------------------------------------------+
| PCapture-anims.nut                                                                 |
|       Animation module, used to quickly create animation events                    |
|       related to alpha, color, object moving                                       |
+----------------------------------------------------------------------------------+ */

if("animate" in getroottable()) {
    dev.warning("Animate module initialization skipped. Module already initialized.")
    return
}

animate <- {
    /* 
    * Smoothly changes the alpha value of an entities from the initial value to the final value over a specified time.
    * 
    * @param {pcapEntity|CBaseEntity|string} entities - The entities (or targetname) to animate.
    * @param {int} startOpacity - The initial opacity value.
    * @param {int} endOpacity - The final opacity value.
    * @param {int|float} time - The duration of the animation in seconds.
    * @param {object} EventSetting - The event settings.
    */ 
    AlphaTransition = function(entities, startOpacity, endOpacity, time, EventSetting = {eventName = null, globalDelay = 0, note = null, outputs = null}) {
        entities = _GetValidEntitiy(entities)
        if(entities[0].GetAlpha() == endOpacity)
            return 
        
        local eventName = _GetValidEventName(entities, EventSetting)
        local globalDelay = "globalDelay" in EventSetting ? EventSetting.globalDelay : 0
        local note = "note" in EventSetting ? EventSetting.note : null

        local transitionFrames = time / FrameTime();
        local alphaStep = (endOpacity - startOpacity) / transitionFrames;    

        // Smoothly change alpha on each frame
        for (local step = 0; step < transitionFrames; step++) {
            local elapsed = (FrameTime() * step) + globalDelay

            // Calculate the new alpha for the current frame
            local newAlpha = startOpacity + alphaStep * (step + 1);
            
            foreach(ent in entities) {
                local action = function() : (ent, newAlpha) {
                    ent.SetAlpha(newAlpha)
                }
                CreateScheduleEvent(eventName, action, elapsed, note)
            }
        }
        
        // Execute outputs with a specified delay, if provided
        if ("outputs" in EventSetting && EventSetting.outputs) {
            CreateScheduleEvent(eventName, EventSetting.outputs, time)
        }
    },


    /*  
    * Smoothly changes the color of entities from start to end over time. 
    *
    * @param {pcapEntity|CBaseEntity|string} entities - The entities.
    * @param {string|Vector} startColor - The starting color.
    * @param {string|Vector} endColor - The ending color.
    * @param {int|float} time - The duration in seconds.  
    * @param {object} EventSetting - The event settings.
    */
    ColorTransition = function(entities, startColor, endColor, time, EventSetting = {eventName = null, globalDelay = 0, note = null, outputs = null}) {
        entities = _GetValidEntitiy(entities)
        local eventName = _GetValidEventName(entities, EventSetting)
        local globalDelay = "globalDelay" in EventSetting ? EventSetting.globalDelay : 0
        local note = "note" in EventSetting ? EventSetting.note : null

        local transitionFrames = abs(time / FrameTime())
        for (local step = 0.0; step <= transitionFrames; step++) {
            local elapsed = (FrameTime() * step) + globalDelay

            local newColor = math.lerp.color(startColor, endColor, step / transitionFrames) 

            foreach(ent in entities) {
                local action = function() : (ent, newColor) {
                    ent.SetColor(newColor)
                }
                CreateScheduleEvent(eventName, action, elapsed, note)
            }
        }

        // Execute outputs with a specified delay, if provided
        if ("outputs" in EventSetting && EventSetting.outputs) {
            CreateScheduleEvent(eventName, EventSetting.outputs, time)
        }
    },


    /* 
    * Moves an entities from the start position to the end position over a specified time based on increments of time.
    * 
    * @param {pcapEntity|CBaseEntity|string} entities - The entities (or targetname) to animate.
    * @param {Vector} startPos - The initial position.
    * @param {Vector} endPos - The final position.
    * @param {int|float} time - The duration of the animation in seconds.
    * @param {object} EventSetting - The event settings.
    */ 
    PositionTransitionByTime = function(entities, startPos, endPos, time, EventSetting = {eventName = null, globalDelay = 0, note = null, outputs = null}) {
        entities = _GetValidEntitiy(entities)
        local eventName = _GetValidEventName(entities, EventSetting)
        local globalDelay = "globalDelay" in EventSetting ? EventSetting.globalDelay : 0

        local steps = abs(time / FrameTime())
        local coordStep = (endPos - startPos) / steps

        for (local tick = 1; tick <= steps; tick++) {
            local newPosition = startPos + (coordStep * tick)
            local elapsed = (FrameTime() * tick) + globalDelay
            local note = "note" in EventSetting ? EventSetting.note : newPosition

            foreach(ent in entities) {
                local action = function() : (ent, newPosition) {
                    ent.SetOrigin(newPosition)
                }
                CreateScheduleEvent(eventName, action, elapsed, note)
            }
            
        }

        // Execute outputs with a specified delay, if provided
        if ("outputs" in EventSetting && EventSetting.outputs) {
            CreateScheduleEvent(eventName, EventSetting.outputs, time)
        }
    },
    
    
    /* Moves an entities from the start position to the end position over a specified time based on speed.
    * 
    * @param {pcapEntity|CBaseEntity|string} entities - The entities to animate.
    * @param {Vector} startPos - The initial position.
    * @param {Vector} endPos - The final position.
    * @param {int|float} speed - The speed at which to move the entities in units per second.
    * @param {object} EventSetting - The event settings.
    * @returns {number} - The time taken to complete the animation.
    */ 
    PositionTransitionBySpeed = function(entity, startPos, endPos, speed, EventSetting = {eventName = null, globalDelay = 0, note = null, outputs = null}) {
        local entities = _GetValidEntitiy(entity)
        local eventName = _GetValidEventName(entities, EventSetting)
        local globalDelay = "globalDelay" in EventSetting ? EventSetting.globalDelay : 0

        local distance = endPos - startPos
        local dir = (endPos - startPos).normalize()

        local steps = abs(distance.Length() / speed)
        for (local tick = 1; tick <= steps; tick++) {
            local newPosition = startPos + (dir * speed * tick)
            local elapsed = (FrameTime() * tick) + globalDelay
            local note = "note" in EventSetting ? EventSetting.note : newPosition
        
            foreach(ent in entities) {
                local action = function() : (ent, newPosition) {
                    ent.SetOrigin(newPosition)
                }
                CreateScheduleEvent(eventName, action, elapsed, note)
            }

        }


        // Execute outputs with a specified delay, if provided
        if ("outputs" in EventSetting && EventSetting.outputs) {
            CreateScheduleEvent(eventName, EventSetting.outputs, time)
        }
        return steps * FrameTime()
    },


    /*
    * Changes angles of entities from start to end over time.
    *
    * @param {pcapEntity|CBaseEntity|string} entities - The entities.
    * @param {Vector} startAngles - Starting angles.  
    * @param {Vector} endAngles - Ending angles.
    * @param {int|float} time - Duration in seconds. 
    * @param {object} EventSetting - Event settings.
    */  
    AnglesTransitionByTime = function(entity, startAngles, endAngles, time, EventSetting = {eventName = null, globalDelay = 0, note = null, outputs = null}) {
        local entities = _GetValidEntitiy(entity)
        local eventName = _GetValidEventName(entities, EventSetting)
        local globalDelay = "globalDelay" in EventSetting ? EventSetting.globalDelay : 0
        local note = "note" in EventSetting ? EventSetting.note : null
    
        local transitionFrames = abs(time / FrameTime())

        for(local step = 0.0; step <= transitionFrames; step++) {
            local elapsed = (FrameTime() * step) + globalDelay
    
            local newAngle = math.lerp.sVector(startAngles, endAngles, step / transitionFrames) 
    
            foreach(ent in entities) {
                local action = function() : (ent, newAngle) {
                    ent.SetAbsAngles(newAngle)
                }
                CreateScheduleEvent(eventName, action, elapsed, note)
            }
        }

    
        // Execute outputs with a specified delay, if provided
        if ("outputs" in EventSetting && EventSetting.outputs) {
            CreateScheduleEvent(eventName, EventSetting.outputs, time)
        }
    }
}


/*
* Gets a valid event name for the entities.
* 
* @param {pcapEntity|CBaseEntity|string} entities - The entities.
* @param {object} EventSetting - The event settings.
* @returns {string} The event name. 
*/
function _GetValidEventName(entities, EventSetting) {
    if (!("eventName" in EventSetting && EventSetting.eventName)) {
        if(typeof entities == "array")
            return entities[0].GetClassname() 
    }

    // if(eventIsValid(EventSetting.eventName)) {
    //     cancelScheduledEvent(EventSetting.eventName)
    // }

    return EventSetting.eventName
}


/*
* Gets valid entity/entities from input.
*
* @param {pcapEntity|CBaseEntity|string} entities - The entity input.  
* @returns {array(pcapEntity)} Valid entity/entities.
*/ 
function _GetValidEntitiy(entities) {
    if (typeof entities == "string") {
        if(entities.find("*") == null)
            return [entLib.FindByName(entities)]
        else {
            local entities = []
            for(local ent; ent = entLib.FindByName(entities, ent);)
                entities.append(ent)
            return entities
        }
    }
            
    if (typeof entities != "pcapEntity")
            return [pcapEntity(entities)]
    
    return [entities]
}

/*+--------------------------------------------------------------------------------+
|                           PCapture Vscripts Library                               |
 +---------------------------------------------------------------------------------+
| Author:                                                                           |
|     One-of-a-Kind - laVashik :D                                                   |
 +---------------------------------------------------------------------------------+
| PCapture-Improvements.nut                                                         |
|       Overrides and improves existing standard VScripts functions.                |
|                                                                                   |
+----------------------------------------------------------------------------------+ */


// Overwriting existing functions to improve them
if("_EntFireByHandle" in getroottable()) {
    dev.warning("Improvements module initialization skipped. Module already initialized.")
    return
}


/*
* Limits frametime to avoid zero values.
* 
* @returns {number} Clamped frametime 
*/
_frametime <- FrameTime
function FrameTime() {
    local tick = _frametime()
    if(tick == 0) 
        return 0.016
    return tick
}


/*
* Wrapper for EntFireByHandle to handle PCapLib objects.
*
* @param {CBaseEntity|pcapEntity} target - Target entity.
* @param {string} action - Action.
* @param {string} value - Action value. (optional)
* @param {number} delay - Delay in seconds. (optional)
* @param {CBaseEntity|pcapEntity} activator - Activator entity. (optional)
* @param {CBaseEntity|pcapEntity} caller - Caller entity. (optional)
*/
_EntFireByHandle <- EntFireByHandle
function EntFireByHandle(target, action, value = "", delay = 0, activator = null, caller = null) {
    /* Extract the underlying entity from the pcapEntity wrapper */
    if (typeof target == "pcapEntity")
        target = target.CBaseEntity 
    if (typeof activator == "pcapEntity")
        activator = activator.CBaseEntity 
    if (typeof caller == "pcapEntity")
        caller = target.CBaseEntity 

    _EntFireByHandle(target, action, value, delay, activator, caller)
}


/*
* Retrieves a player entity with extended functionality.
* 
* @param {int} index - The index of the player (1-based).
* @returns {pcapEntity} - An extended player entity with additional methods.
*/
function GetPlayerEx(index = 1) { // TODO
    return pcapPlayer(GetPlayer())
}

class pcapPlayer extends pcapEntity {
    function EyePosition() {
        return this.CBaseEntity.EyePosition()
    }

    function EyeAngles() {
        return this.GetUserData("Eye").GetAngles()
    }

    function EyeForwardVector() {
        return this.GetUserData("Eye").GetForwardVector()
    }
}

dissolver <- entLib.CreateByClassname("env_entity_dissolver", {targetname = "@dissolver"})