math["Matrix"] <- class {
    a = 1; b = 0; c = 0;
    d = 0; e = 1; f = 0;
    g = 0; h = 0; k = 1;

    constructor(a, b, c,
                d, e, f
                g, h, k
        ) {
            this.a = a; this.b = b; this.c = c;
            this.d = d; this.e = e; this.f = f;
            this.g = g; this.h = h; this.k = k;
        }
    /*
    * Creates a rotation matrix from Euler angles.
    *
    * @param {Vector} angles - Euler angles in degrees (pitch, yaw, roll).
    * @returns {Matrix} - The rotation matrix.
    */
    function fromEuler(angles) {
        local sinX = sin(-angles.z / 180 * PI);
        local cosX = cos(-angles.z / 180 * PI);
        local sinY = sin(-angles.x / 180 * PI);
        local cosY = cos(-angles.x / 180 * PI);
        local sinZ = sin(-angles.y / 180 * PI);
        local cosZ = cos(-angles.y / 180 * PI);
        return math.Matrix(
            cosY * cosZ, -sinX * -sinY * cosZ + cosX * sinZ, cosX * -sinY * cosZ + sinX * sinZ,
            cosY * -sinZ, -sinX * -sinY * -sinZ + cosX * cosZ, cosX * -sinY * -sinZ + sinX * cosZ,
            sinY, -sinX * cosY, cosX * cosY
        );
    }

    /*
    * Rotates a point using the matrix.
    *
    * @param {Vector} point - The point to rotate.
    * @returns {Vector} - The rotated point.
    */
    function rotateVector(point) {
        return Vector(
            point.x * this.a + point.y * this.b + point.z * this.c,
            point.x * this.d + point.y * this.e + point.z * this.f,
            point.x * this.g + point.y * this.h + point.z * this.k
        );
    }

    /*
    * Unrotates a point using the matrix.
    *
    * @param {Vector} point - The point to unrotate.
    * @returns {Vector} - The unrotated point.
    */
    function unrotateVector(point) {
        return Vector(
            point.x * this.a + point.y * this.d + point.z * this.g,
            point.x * this.b + point.y * this.e + point.z * this.h,
            point.x * this.c + point.y * this.f + point.z * this.k
        );
    }

    /*
    * Транспонирует матрицу.
    *
    * @returns {Matrix} - Транспонированная матрица.
    */
    function transpose() {
        return math.Matrix(
            this.a, this.d, this.g,
            this.b, this.e, this.h,
            this.c, this.f, this.k
        );
    }

    /*
    * Вычисляет обратную матрицу.
    *
    * @returns {Matrix} - Обратная матрица.
    */
    function inverse() {
        local det = this.determinant();
        if (det == 0) {
            throw "Matrix is singular (determinant is zero)"
        }
        local invDet = 1 / det;
        return math.Matrix(
            (this.e * this.k - this.f * this.h) * invDet,
            (this.c * this.h - this.b * this.k) * invDet,
            (this.b * this.f - this.c * this.e) * invDet,
            (this.f * this.g - this.d * this.k) * invDet,
            (this.a * this.k - this.c * this.g) * invDet,
            (this.c * this.d - this.a * this.f) * invDet,
            (this.d * this.h - this.e * this.g) * invDet,
            (this.b * this.g - this.a * this.h) * invDet,
            (this.a * this.e - this.b * this.d) * invDet
        );
    }

    /*
    * Вычисляет детерминант матрицы.
    *
    * @returns {number} - Детерминант матрицы.
    */
    function determinant() {
        return this.a * (this.e * this.k - this.f * this.h) -
               this.b * (this.d * this.k - this.f * this.g) +
               this.c * (this.d * this.h - this.e * this.g);
    }

    /*
    * Масштабирует матрицу на заданный коэффициент.
    *
    * @param {number} factor - Коэффициент масштабирования.
    * @returns {Matrix} - Масштабированная матрица.
    */
    function scale(factor) {
        return math.Matrix(
            this.a * factor, this.b * factor, this.c * factor,
            this.d * factor, this.e * factor, this.f * factor,
            this.g * factor, this.h * factor, this.k * factor
        );
    }

    /*
    * Сдвигает матрицу на заданный вектор.
    *
    * @param {Vector} vector - Вектор сдвига.
    * @returns {Matrix} - Сдвинутая матрица.
    */
    function translate(vector) {
        return math.Matrix(
            this.a, this.b, this.c,
            this.d, this.e, this.f,
            this.g + vector.x, this.h + vector.y, this.k + vector.z
        );
    }

    /*
    * Вращает матрицу вокруг оси X на заданный угол.
    *
    * @param {number} angle - Угол поворота в радианах.
    * @returns {Matrix} - Повернутая матрица.
    */
    function rotateX(angle) {
        local sinAngle = sin(angle);
        local cosAngle = cos(angle);
        return math.Matrix(
            1, 0, 0,
            0, cosAngle, -sinAngle,
            0, sinAngle, cosAngle
        ) * this;
    }

    /*
    * Multiplies two matrices.
    *
    * @param {Matrix} other - The other matrix.
    * @returns {Matrix} - The result of the multiplication.
    */
    function _mul(other) {
        return math.Matrix(
            this.a * other.a + this.b * other.d + this.c * other.g,
            this.a * other.b + this.b * other.e + this.c * other.h,
            this.a * other.c + this.b * other.f + this.c * other.k,
            this.d * other.a + this.e * other.d + this.f * other.g,
            this.d * other.b + this.e * other.e + this.f * other.h,
            this.d * other.c + this.e * other.f + this.f * other.k,
            this.g * other.a + this.h * other.d + this.k * other.g,
            this.g * other.b + this.h * other.e + this.k * other.h,
            this.g * other.c + this.h * other.f + this.k * other.k
        );
    }

    /*
    * Складывает две матрицы.
    *
    * @param {Matrix} other - Другая матрица.
    * @returns {Matrix} - Результат сложения.
    */
    function _add(other) {
        return math.Matrix(
            this.a + other.a, this.b + other.b, this.c + other.c,
            this.d + other.d, this.e + other.e, this.f + other.f,
            this.g + other.g, this.h + other.h, this.k + other.k
        );
    }

    /*
    * Вычитает две матрицы.
    *
    * @param {Matrix} other - Другая матрица.
    * @returns {Matrix} - Результат вычитания.
    */
    function _sub(other) {
        return math.Matrix(
            this.a - other.a, this.b - other.b, this.c - other.c,
            this.d - other.d, this.e - other.e, this.f - other.f,
            this.g - other.g, this.h - other.h, this.k - other.k
        );
    }
}