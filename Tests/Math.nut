IncludeScript("Tests/test_exec")

// Math module unit tests
math_tests <- {
    // Test the lerp function for integers
    function lerp_int() {
        local result = math.lerp.number(0, 100, 0.5)
        return assert(result == 50)
    },

    // Test the lerp function for vectors
    function lerp_vector() {
        local start = Vector(0, 0, 0)
        local end = Vector(10, 10, 10)
        local result = math.lerp.vector(start, end, 0.5)
        return assert(math.vector.isEqually(result, Vector(5, 5, 5)))
    },

    // Test the lerp function for colors
    function lerp_color() {
        local start = "0 0 0"
        local end = "255 255 255"
        local result = math.lerp.color(start, end, 0.5)
        return assert(result == "127 127 127") // todo mb 128?
    },

    // Test the slerp function for vectors
    function slerp_vector() {
        local start = Vector(1, 0, 0)
        local end = Vector(0, 1, 0)
        local result = math.lerp.sVector(start, end, 0.5)
        local expected = Vector(0.5, 0.5, 0) //? why i get 0.500000, 0.500019, {0.002182}? 
        return assert(math.vector.isEqually(result, expected))
    },

    // function ang2quad2vector() { 
    //     local vec = Vector(124, 92.2, 0)
    //     local q = math.Quaternion.fromEuler(vec)
    //     local result = q.toVector()
    //     return assert(math.vector.isEqually(result, vec))
    // },

    // Test the spline function
    function spline() {
        local result = math.lerp.spline(0.5)
        return assert(result == 0.5)
    },

    // Test the SmoothStep function
    function SmoothStep() {
        local result = math.lerp.SmoothStep(0, 1, 0.5)
        return assert(result == 0.5)
    },

    // Test the FLerp function
    function FLerp() {
        local result = math.lerp.FLerp(0, 10, 0, 1, 0.5)
        return assert(result == 5)
    },

    // Test the SmoothCurve function
    function SmoothCurve() {
        local result = math.lerp.SmoothCurve(0.5)
        return assert(result == 0.5)
    },

    // Test the SmoothProgress function
    function SmoothProgress() {
        local result = math.lerp.SmoothProgress(0.5)
        return assert(result == 0.5)
    },

    // Test the min function
    function min() {
        local result = math.min(1, 2, 3, 0, -1)
        return assert(result == -1)
    },

    // Test the max function
    function max() {
        local result = math.max(1, 2, 3, 0, -1)
        return assert(result == 3)
    },

    // Test the clamp function
    function clamp() {
        local result1 = math.clamp(5, 0, 10)
        local result2 = math.clamp(-1, 0, 10)
        local result3 = math.clamp(11, 0, 10)
        return assert(result1 == 5 && result2 == 0 && result3 == 10)
    },

    // Test the vector clamp function
    function vector_clamp() {
        local result = math.vector.clamp(Vector(15,3,-5), 0, 10)
        return assert(result.x == 10 && result.y == 3 && result.z == 0)
    },

    function vector_abs() {
        local result = math.vector.abs(Vector(15,-3,-5))
        return assert(result.x == 15 && result.y == 3 && result.z == 5)
    },

    // Test the vector.round function
    function roundVector() {
        local vector = Vector(1.2345, 6.7890, -0.1234)
        local result = math.vector.round(vector, 1000)
        return assert(math.vector.isEqually(result, Vector(1.235, 6.789, -0.123)))
    },

    // Test the Sign function
    function Sign() {
        local result1 = math.Sign(10)
        local result2 = math.Sign(-5)
        local result3 = math.Sign(0)
        return assert(result1 == 1 && result2 == -1 && result3 == 0)
    },

    // Test the copysign function
    function copysign() {
        local result1 = math.copysign(5, -1)
        local result2 = math.copysign(-3, 1)
        return assert(result1 == -5 && result2 == 3)
    },

    // Test the RemapVal function
    function RemapVal() {
        local result1 = math.RemapVal(5, 0, 10, 0, 100)
        local result2 = math.RemapVal(2.5, 0, 5, 10, 20)
        return assert(result1 == 50 && result2 == 15)
    },
    
    // Test the rotateVector function
    function rotateVector() {
        local vector = Vector(1, 0, 0)
        local angle = Vector(0, 90, 0)
        local result = math.vector.rotate(vector, angle)
        local expected = Vector(0, 1, 0)
        return assert(math.vector.isEqually(result, expected))
    },

    // Test the unrotateVector function
    function unrotateVector() {
        local vector = Vector(0, 1, 0)
        local angle = Vector(0, 90, 0)
        local result = math.vector.unrotate(vector, angle)
        local expected = Vector(1, 0, 0)
        return assert(math.vector.isEqually(result, expected))
    },

    // Test the random function
    function random() {
        local result = math.vector.random(0, 10)
        return assert(result.x >= 0 && result.x <= 10 && 
                      result.y >= 0 && result.y <= 10 &&
                      result.z >= 0 && result.z <= 10) 
    },

    // Test the reflect function
    function reflect() { 
        local dir = Vector(1, 0, 0)
        local normal = Vector(0, 1, 0)
        local result = math.vector.reflect(dir, normal)
        local expected = Vector(1, 0, 0) 
        return assert(math.vector.isEqually(result, expected)) 
    },

    // Test the resize function
    function resize() { 
        local vector = Vector(2, 4, 6)
        local result = math.vector.resize(vector, 10)
        
        vector.Norm() 
        local expected = vector * 10  

        return assert(math.vector.isEqually(result, expected))
    },

    // Quaternion tests
    function Quaternion_fromEuler() {
        local angles = Vector(0, 90, 0)
        local quat = math.Quaternion.fromEuler(angles)
        local expected = math.Quaternion(0, 0, 0.707107, 0.707107)
        
        return assert(quat.isEqually(expected))
    },

    function Quaternion_fromVector() {
        local vector = Vector(1, 2, 3)
        local quat = math.Quaternion.fromVector(vector)
        return assert(quat.x == 1 && quat.y == 2 && quat.z == 3 && quat.w == 0)
    },

    function Quaternion_rotateVector() {
        local vector = Vector(1, 0, 0)
        local angle = Vector(0, 90, 0)
        local quat = math.Quaternion.fromEuler(angle)
        local result = quat.rotateVector(vector)
        local expected = Vector(0, 1, 0)
        return assert(math.vector.isEqually(result, expected))
    },

    function Quaternion_unrotateVector() {
        local vector = Vector(0, 1, 0)
        local angle = Vector(0, 90, 0)
        local quat = math.Quaternion.fromEuler(angle) 
        local result = quat.unrotateVector(vector)
        local expected = Vector(1, 0, 0)
        return assert(math.vector.isEqually(result, expected))
    },

    function Quaternion_slerp() {
        local start = math.Quaternion.fromEuler(Vector(0, 0, 0))
        local end = math.Quaternion.fromEuler(Vector(0, 90, 0))
        local result = start.slerp(end, 0.5) 
        local expected = math.Quaternion.fromEuler(Vector(0, 45, 0))
        return assert(result.isEqually(expected))
    },

    function Quaternion_normalize() {
        local quat = math.Quaternion(1, 2, 3, 4)
        local result = quat.normalize()
        return assert(math.round(result.length(), 10000) == 1)
    },

    function Quaternion_dot() {
        local q1 = math.Quaternion(1, 2, 3, 4)
        local q2 = math.Quaternion(5, 6, 7, 8)
        local result = q1.dot(q2)
        return assert(result == 70)
    },

    function Quaternion_length() {
        local quat = math.Quaternion(1, 2, 3, 4)
        local result = quat.length()
        return assert(math.round(result, 10000) == 5.4772)
    },

    function Quaternion_inverse() {
        local quat = math.Quaternion(1, 2, 3, 4)
        local result = quat.inverse()
        return assert(math.round(result.length(), 100) == 0.18) 
    },

    function Quaternion_toAxisAngle() { 
        local quat = math.Quaternion(0.7071, 0, 0, 0.7071) 
        local result = quat.toAxisAngle() 
        local expectedAxis = Vector(1, 0, 0) 
        local expectedAngle = 1.57082 // 90 * PI / 180 
        return assert(math.vector.isEqually(result.axis, expectedAxis) && math.round(result.angle) == math.round(expectedAngle)) 
    },

    // Matrix tests 
    function Matrix_fromEuler() {
        local angles = Vector(0, 90, 0)
        local matrix = math.Matrix.fromEuler(angles)
        local expected = math.Matrix(
            0, -1, 0,
            1, 0, 0,
            0, 0, 1
        )
        return assert(matrix.isEqually(expected))
    },
    
    function Matrix_rotateVector() {
        local vector = Vector(1, 0, 0)
        local angle = Vector(0, 90, 0)
        local matrix = math.Matrix.fromEuler(angle)
        local result = matrix.rotateVector(vector)
        local expected = Vector(0, 1, 0)
        return assert(math.vector.isEqually(result, expected))
    },

    function Matrix_unrotateVector() { 
        local vector = Vector(0, 1, 0) 
        local angle = Vector(0, 90, 0) 
        local matrix = math.Matrix.fromEuler(angle) 
        local result = matrix.unrotateVector(vector) 
        local expected = Vector(1, 0, 0) 
        return assert(math.vector.isEqually(result, expected)) 
    },

    function Matrix_transpose() { 
        local matrix = math.Matrix( 
            1, 2, 3, 
            4, 5, 6, 
            7, 8, 9 
        ) 
        local result = matrix.transpose() 
        local expected = math.Matrix( 
            1, 4, 7, 
            2, 5, 8, 
            3, 6, 9 
        ) 
        return assert(result.isEqually(expected)) 
    }, 
 
    function Matrix_inverse() { 
        local matrix = math.Matrix( 
            1, 2, 3, 
            0, 1, 4, 
            5, 6, 0 
        ) 
        local result = matrix.inverse() 
        local expected = math.Matrix( 
            -24, 18, 5, 
            20, -15, -4, 
            -5, 4, 1 
        ) 
        return assert(result.isEqually(expected))
    }, 

    function Matrix_determinant() { 
        local matrix = math.Matrix( 
            1, 2, 3, 
            0, 1, 4, 
            5, 6, 0 
        ) 
        local result = matrix.determinant() 
        return assert(result == 1) 
    }, 

    function Matrix_scale() { 
        local matrix = math.Matrix( 
            1, 2, 3, 
            4, 5, 6, 
            7, 8, 9 
        ) 
        local result = matrix.scale(2) 
        local expected = math.Matrix( 
            2, 4, 6, 
            8, 10, 12, 
            14, 16, 18 
        ) 
        return assert(result.isEqually(expected)) 
    }, 
}

// Run all tests
RunTests("Math", math_tests)