## Calculate Normal Algorithms

This document describes the algorithms implemented in the `calculate_normal.nut` file for determining the impact normal of a surface hit by a trace. Three distinct algorithms are employed, each tailored for different scenarios:

### 1. Three-Ray Method for World Geometry (`CalculateImpactNormal`)

This algorithm calculates the impact normal for surfaces that are part of the world geometry (not dynamic entities). It's based on the "three-ray method," which involves performing three traces to determine the orientation of the surface at the hit point.

**Steps:**

1. **Calculate Trace Direction:** The normalized direction vector of the original trace (from start position to hit position) is calculated.

2. **Determine New Start Positions:** Two new start positions for additional traces are calculated by offsetting the original start position slightly along two vectors perpendicular to the trace direction. These offsets ensure that the additional traces will hit the surface at different points, allowing for the calculation of the normal vector.

3. **Perform Additional Traces:** Two cheap traces are performed from the new start positions in the same direction as the original trace. The hit positions of these traces are recorded as intersection points.

4. **Calculate Normal Vector:** The normal vector of the surface is calculated using the cross product of two edge vectors formed by the hit position of the original trace and the two intersection points obtained from the additional traces. The resulting vector is normalized to have a length of 1.

**Limitations:**

This method is primarily suitable for world geometry because it relies on the ability to perform cheap traces in close proximity to the hit point without hitting other entities.

### 2. Optimized Bounding Box Normal Calculation (`CalculateImpactNormalFromBbox`)

This algorithm calculates the impact normal for dynamic entities using an optimized approach based on the entity's bounding box. It leverages the property that one of the coordinates of the hit point is likely to be the same (or very close) across some four vertices of the bounding box.

**Steps:**

1. **Retrieve Bounding Box Vertices:** The eight vertices of the hit entity's bounding box are retrieved.

2. **Identify Closest Vertices:** A specialized function `_getFaceVertices` is used to identify the four vertices that form the face of the bounding box closest to the hit point. This function relies on finding vertices with nearly identical coordinates along one of the axes (X, Y, or Z).

3. **Calculate Face Normal:** If four appropriate vertices are found, the normal vector of the face is calculated using the cross product of two edge vectors of the face.

4. **Verify Normal Direction:** The dot product of the face normal and the trace direction vector is calculated. If the dot product is positive, it indicates that the normal vector is pointing in the wrong direction (towards the trace origin), and it's inverted.

5. **Fallback to `CalculateImpactNormalFromBbox2`:** If `_getFaceVertices` fails to find four suitable vertices (e.g., due to an inaccurate hit point), the algorithm falls back to the `CalculateImpactNormalFromBbox2` method.

### 3. Fallback Bounding Box Normal Calculation (`CalculateImpactNormalFromBbox2`)

This algorithm serves as a fallback when the `CalculateImpactNormalFromBbox` method cannot determine the normal vector reliably. It provides a less precise but more robust way to estimate the normal using the three closest vertices of the bounding box.

**Steps:**

1. **Retrieve Bounding Box Vertices:** The eight vertices of the hit entity's bounding box are retrieved.

2. **Find Three Closest Vertices:** The three vertices closest to the hit point are identified based on their Euclidean distance.

3. **Calculate Triangle Normal:** The normal vector of the triangle formed by the three closest vertices is calculated using the cross product of two edge vectors of the triangle.

4. **Verify Normal Direction:** Similar to the previous algorithm, the dot product of the triangle normal and the trace direction vector is checked, and the normal vector is inverted if necessary.

**Limitations:**

This method can be less accurate, especially for rectangular objects, as the three closest vertices might not always represent the actual surface orientation at the hit point. For example, if the hit point is near a corner of a rectangular object, the closest vertices might be on opposite corners, leading to an incorrect normal calculation.


**Conclusion:**

The `calculate_normal.nut` file provides three different algorithms for calculating impact normals, each with its own strengths and limitations. The choice of algorithm depends on the type of surface being hit (world geometry or dynamic entity) and the desired level of accuracy. The optimized `CalculateImpactNormalFromBbox` method is generally preferred for dynamic entities, while the fallback `CalculateImpactNormalFromBbox2` method provides a more robust but potentially less precise alternative. The `CalculateImpactNormal` method is suitable for world geometry where the three-ray method can be applied reliably.

