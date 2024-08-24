## BBox Casting Algorithm

This document describes the implementation of a highly optimized BBox (Bounding Box) Casting algorithm used for precise collision detection in a game environment. This algorithm is designed to be performant even when dealing with a large number of entities, ensuring minimal impact on frame rate.

### Algorithm Overview

The BBox Casting algorithm utilizes a three-tiered search approach to efficiently determine if a ray intersects with the bounding box of any entity within the game world. This approach minimizes the number of expensive collision checks, significantly improving performance compared to a naive brute-force approach.

### Algorithm Steps:

1. **Initial Trace:** A fast, inexpensive trace is performed to get an initial hit position, providing a baseline for further analysis.

2. **Dirty Search:** The ray's trajectory is divided into segments. For each segment, a "dirty" search is performed using `Entities.FindByClassnameWithin()`, checking for entities within a large sphere centered at the segment's midpoint. The radius of this sphere is calculated based on the segment's length. All entities found in this search, and that pass an initial filtering (`shouldHitEntity`), are added to a temporary buffer.

3. **Fast Search:** If the "dirty search" finds any entities within the current segment, a "fast search" is initiated. This search iterates through a predefined number of points within the segment, checking if the distance between the point and the center of each buffered entity is less than the entity's bounding box radius. If a point is found to be within an entity's bounding box radius, the point is marked as the "closest point" and the "fast search" is terminated.

4. **Deep Search:** If a "closest point" is found during the "fast search", a "deep search" is initiated. This search focuses on a smaller region around the "closest point," iterating through a finer set of points. For each point, a precise `PointInBBox()` check is performed to determine if the point lies within any of the buffered entities' bounding boxes. If a point is found to be inside an entity's bounding box, the algorithm returns the point and the corresponding entity, indicating a successful hit.

5. **Buffer Cleanup:** After each segment is processed, the entity buffer is cleared to prepare for the next segment.

6. **Final Result:** If no intersection is found after processing all segments, the algorithm returns the initial hit position obtained in the first step, indicating that the ray did not hit any entity.

### Optimizations:

- **Segment-Based Search:** Dividing the ray into segments and performing a coarse "dirty search" before a more precise "deep search" drastically reduces unnecessary checks, particularly when entities are sparsely distributed.
- **Buffered Entities:** Storing relevant entity data (origin, bounding box dimensions) in a temporary buffer avoids redundant calculations during the "fast" and "deep" searches.
- **Early Termination:** The "fast search" and "deep search" are terminated as soon as a potential hit is detected, preventing unnecessary iterations.
- **Dynamic Radius:** The search radius for `FindByClassnameWithin()` is dynamically adjusted based on the segment's length, ensuring that the search area is appropriate for the current segment.

### Code Example:

```squirrel
// ... (BufferedEntity class, JumpPercent constant) ...

function TraceLineAnalyzer::Trace(startPos, endPos, ignoreEntities, note = null) {
    // ... (Initial Trace, entBuffer initialization, halfSegment, segmentsLenght, searchRadius calculations) ...

    for (local segment = 0; segment < 1; segment += JumpPercent) {
        // ... ("Dirty Search" logic) ...

        // ... ("Fast Search" logic) ...

        // ... ("Deep Search" logic) ...

        // ... (Cleanup buffer) ...
    }

    // ... (Return result) ...
}

// ... (PointInBBox function) ... 
```

### Conclusion:

The BBox Casting algorithm implemented here presents a highly optimized solution for accurate and efficient collision detection in a game environment. By utilizing a tiered search strategy, buffering relevant data, and employing early termination techniques, this algorithm minimizes computational overhead and ensures smooth gameplay even in scenarios involving numerous entities. 
