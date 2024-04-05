math["min"] <- function(...) {
    local min = vargv[0]
    for(local i = 0; i< vargc; i++) {
        if(min > vargv[i])
            min = vargv[i]
    }
    
    return min
}


math["max"] <- function(...) {
    local max = vargv[0]
    for(local i = 0; i< vargc; i++) {
        if(vargv[i] > max)
            max = vargv[i]
    }

    return max
}


/* Clamps an integer value within the specified range.
*
* @param {int|float} int - The value to clamp.
* @param {int|float} min - The minimum value.
* @param {int|float} max - The maximum value (optional).
* @returns {int|float} - The clamped value.
*/
math["clamp"] <- function(int, min, max = 99999) { 
    if ( int < min ) return min;
    if ( int > max ) return max;
    return int
}


math["round"] <- function(val, int = 1000) {
    return floor(val * int + 0.5) / int
}


/* Returns the sign of a number.
*
* @param {int|float} x - The number.
* @returns {int} - The sign of the number (-1, 0, or 1).
*/
math["Sign"] <- function(x) {
    if (x > 0) {
        return 1;
    } else if (x < 0) {
        return -1;
    } else {
        return 0;
    }
}


/* Copies the sign of one value to another.
*
* @param {int|float} value - The value to copy the sign to.
* @param {int|float} sign - The sign to copy.
* @returns {int|float} - The value with the copied sign.
*/
math["copysign"] <- function(value, sign) {
    if (sign < 0 || value < 0) {
        return -value;
    }
    return value
}


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
math["RemapVal"] <- function( val, A, B, C, D )
{
    if ( A == B )
    {
        if ( val >= B )
            return D;
        return C;
    };
    return C + (D - C) * (val - A) / (B - A);
}   