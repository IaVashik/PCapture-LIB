math["lerp"] <- {}
local lerp = math["lerp"]


/*
 * Performs linear interpolation (lerp) between start and end based on the parameter t.
 *
 * @param {number} start - The starting value.
 * @param {number} end - The ending value.
 * @param {number} t - The interpolation parameter.
 * @returns {number} - The interpolated value.
*/
lerp["number"] <- function(start, end, t) {
    return start * (1 - t) + end * t;
}


/*
 * Performs linear interpolation (lerp) between two vectors.
 *
 * @param {Vector} start - The starting vector.
 * @param {Vector} end - The ending vector.
 * @param {number} t - The interpolation parameter.
 * @returns {Vector} - The interpolated vector.
*/
lerp["vector"] <- function(start, end, t) {
    return Vector(this.number(start.x, end.x, t), this.number(start.y, end.y, t), this.number(start.z, end.z, t));
}


/*
 * Performs linear interpolation (lerp) between two colors.
 *
 * @param {Vector|string} start - The starting color vector or string representation (e.g., "255 0 0").
 * @param {Vector|string} end - The ending color vector or string representation.
 * @param {number} t - The interpolation parameter.
 * @returns {string} - The interpolated color string representation (e.g., "128 64 0").
*/
lerp["color"] <- function(start, end, t) {
    if (type(start) == "string") {
        start = macros.StrToVec(start)
    }
    if (type(end) == "string") {
        end = macros.StrToVec(end)
    }

    return floor(this.number(start.x, end.x, t)) + " " + floor(this.number(start.y, end.y, t)) + " " + floor(this.number(start.z, end.z, t))
}

// SLERP for vector 
lerp["sVector"] <- function(start, end, t) {
    local q1 = math.Quaternion.fromEuler(start)
    local q2 = math.Quaternion.fromEuler(end)
    return q1.slerp(q2, t).toVector()
}

/*
 * Performs smooth interpolation between two values using a smoothstep function.
 *
 * @param {number} edge0 - The lower edge of the interpolation range.
 * @param {number} edge1 - The upper edge of the interpolation range.
 * @param {number} value - The interpolation parameter.
 * @returns {number} - The interpolated value.
*/
lerp["SmoothStep"] <- function(edge0, edge1, value) {
    local t = math.clamp((value - edge0) / (edge1 - edge0), 0.0, 1.0);
    return t * t * (3.0 - 2.0 * t)
}


/*
 * Performs linear interpolation between two values.
 *
 * @param {number} f1 - The start value.
 * @param {number} f2 - The end value.
 * @param {number} i1 - The start interpolation parameter.
 * @param {number} i2 - The end interpolation parameter.
 * @param {number} value - The interpolation parameter.
 * @returns {number} - The interpolated value.
*/
lerp["FLerp"] <- function( f1, f2, i1, i2, value ) {
    return f1 + (f2 - f1) * (value - i1) / (i2 - i1);
}


// More info here: https://gizma.com/easing/

lerp["InSine"] <- function(t) { 
    return 1 - cos((t * PI) / 2);
}

lerp["OutSine"] <- function(t) { 
    return sin((t * PI) / 2);
}

lerp["InOutSine"] <- function(t) { 
    return -(cos(PI * t) - 1) / 2;
}

lerp["InQuad"] <- function(t) { 
    return t * t; 
}

lerp["OutQuad"] <- function(t) { 
    return 1 - (1 - t) * (1 - t); 
}

lerp["InOutQuad"] <- function(t) { 
    return t < 0.5 ? 2 * t * t : 1 - pow(-2 * t + 2, 2) / 2;
}

lerp["InCubic"] <- function(t) { 
    return t * t * t;
}

lerp["OutCubic"] <- function(t) { 
    return 1 - pow(1 - t, 3);
}

lerp["InOutCubic"] <- function(t) { 
    return t < 0.5 ? 4 * t * t * t : 1 - pow(-2 * t + 2, 3) / 2;
}

lerp["InQuart"] <- function(t) {
    return t * t * t * t; 
}

lerp["OutQuart"] <- function(t) { 
    return 1 - pow(1 - t, 4);
}

lerp["InOutQuart"] <- function(t) { 
    return t < 0.5 ? 8 * t * t * t * t : 1 - pow(-2 * t + 2, 4) / 2;
}

lerp["InQuint"] <- function(t) { 
    return t * t * t * t * t;
}

lerp["OutQuint"] <- function(t) { 
    return 1 - pow(1 - t, 5);
}

lerp["InOutQuint"] <- function(t) { 
    return t < 0.5 ? 16 * t * t * t * t * t : 1 - pow(-2 * t + 2, 5) / 2;
}

lerp["InExpo"] <- function(t) { 
    return t == 0 ? 0 : pow(2, 10 * t - 10);
}

lerp["OutExpo"] <- function(t) { 
    return t == 1 ? 1 : 1 - pow(2, -10 * t);
}

lerp["InOutExpo"] <- function(t) { 
    return t == 0 ? 0 : t == 1 ? 1 : t < 0.5 ? pow(2, 20 * t - 10) / 2 : (2 - pow(2, -20 * t + 10)) / 2;
}

lerp["InCirc"] <- function(t) { 
    return 1 - sqrt(1 - pow(t, 2));
}

lerp["OutCirc"] <- function(t) { 
    return sqrt(1 - pow(t - 1, 2));
}

lerp["InOutCirc"] <- function(t) { 
    return t < 0.5 ? (1 - sqrt(1 - pow(2 * t, 2))) / 2 : (sqrt(1 - pow(-2 * t + 2, 2)) + 1) / 2;
}

lerp["InBack"] <- function(t) { 
    local c1 = 1.70158;
    local c3 = c1 + 1;
    return c3 * t * t * t - c1 * t * t;
}

lerp["OutBack"] <- function(t) { 
    local c1 = 1.70158;
    local c3 = c1 + 1;
    return 1 + c3 * pow(t - 1, 3) + c1 * pow(t - 1, 2);
}

lerp["InOutBack"] <- function(t) { 
    local c1 = 1.70158;
    local c2 = c1 * 1.525;
    return t < 0.5
       ? (pow(2 * t, 2) * ((c2 + 1) * 2 * t - c2)) / 2
       : (pow(2 * t - 2, 2) * ((c2 + 1) * (t * 2 - 2) + c2) + 2) / 2;
}

lerp["InElastic"] <- function(t) { 
    local c4 = (2 * PI) / 3;
    return t == 0
        ? 0
        : t == 1
        ? 1
        : -pow(2, 10 * t - 10) * sin((t * 10 - 10.75) * c4);
}

lerp["OutElastic"] <- function(t) { 
    local c4 = (2 * PI) / 3;
    return t == 0
    ? 0
    : t == 1
    ? 1
    : pow(2, -10 * t) * sin((t * 10 - 0.75) * c4) + 1;
}

lerp["InOutElastic"] <- function(t) { 
    local c5 = (2 * PI) / 4.5;
    return t == 0
    ? 0
    : t == 1
    ? 1
    : t < 0.5
    ? -(pow(2, 20 * t - 10) * sin((20 * t - 11.125) * c5)) / 2
    : (pow(2, -20 * t + 10) * sin((20 * t - 11.125) * c5)) / 2 + 1;
}

lerp["InBounce"] <- function(t) { 
    return 1 - math.lerp.OutBounce(1 - t); // todo
}

lerp["OutBounce"] <- function(t) { 
    local n1 = 7.5625;
    local d1 = 2.75;
    if (t < 1 / d1) {
    return n1 * t * t;
    } else if (t < 2 / d1) {
        return n1 * (t -= 1.5 / d1) * t + 0.75;
    } else if (t < 2.5 / d1) {
        return n1 * (t -= 2.25 / d1) * t + 0.9375;
    } else {
        return n1 * (t -= 2.625 / d1) * t + 0.984375;
    }
}

lerp["InOutBounce"] <- function(t) { 
    return t < 0.5
    ? (1 - math.lerp.OutBounce(1 - 2 * t)) / 2
    : (1 + math.lerp.OutBounce(2 * t - 1)) / 2;
}