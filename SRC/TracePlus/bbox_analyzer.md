## BBox Casting Algorithm

This document describes the implementation of a highly optimized BBox (Bounding Box) Casting algorithm used for precise collision detection in a game environment. This algorithm is designed to be performant even when dealing with a large number of entities, ensuring minimal impact on frame rate.

### Algorithm Overview

The BBox Casting algorithm utilizes a multi-tiered search approach with caching and refinement techniques to efficiently determine if a ray intersects with the bounding box of any entity within the game world. This approach minimizes the number of expensive collision checks, significantly improving performance compared to a naive brute-force approach.

### Algorithm Steps:

1. **Initial Trace:** A fast, inexpensive trace using the standard `TraceLine` function is performed to get an initial hit position against the world geometry, providing a baseline for further analysis.

2. **Segment-Based Search:** The ray's trajectory from the start position to the initial hit position is divided into segments based on a predefined `JumpPercent` constant. This segmentation allows for localized searches, improving efficiency.

3. **Dirty Search (Entity Collection):** For each segment, a "dirty search" is performed using `Entities.FindByClassnameWithin()`, checking for entities within a sphere centered at the segment's midpoint. The sphere's radius is dynamically calculated based on the segment's length and a scaling factor. This search collects potential colliding entities within a broad area.

4. **Entity Filtering and Caching:** Entities found in the "dirty search" undergo filtering based on the `TracePlus.Settings` object (ignore classes, priority classes, custom filters). To avoid redundant calculations, a caching mechanism (`EntBufferTable`) stores entity information (origin, bounding box dimensions) for entities that haven't changed their position. This cached data is reused in subsequent checks.

5. **Fast Search (Coarse Collision Check):** If the "dirty search" yields any filtered entities, a "fast search" is initiated within the current segment. This search iterates through a predefined number of points along the segment, checking if the distance between each point and the center of each buffered entity is less than the entity's bounding radius (half the length of the entity's bounding box diagonal). This provides a quick initial check for potential collisions.

6. **Deep Search (Precise Collision Check):** If the "fast search" identifies a potential collision (a point within an entity's bounding radius), a "deep search" is initiated. This search focuses on a smaller region around the potential collision point, iterating through a finer set of points determined by the `depthAccuracy` setting in `TracePlus.Settings`. For each point, a precise `PointInBBox()` check is performed to determine if the point lies within the entity's bounding box.

7. **Binary Refinement (Optional):** If the `bynaryRefinement` setting in `TracePlus.Settings` is enabled, and a point is found inside the bounding box during the "deep search," an additional binary refinement search is performed. This search iteratively narrows down the hit point to a more precise location within the bounding box, improving accuracy, especially for surface normal calculations.

8. **Result Handling:** If a collision is confirmed during the "deep search" (with or without binary refinement), the algorithm returns the refined hit point and the corresponding entity, indicating a successful hit. If no collision is found within a segment, the entity buffer is cleared, and the algorithm proceeds to the next segment.

9. **Final Result:** If no intersection is found after processing all segments, the algorithm returns the initial hit position obtained in the first step and `null` for the entity, indicating that the ray did not hit any entity's bounding box.

### Optimizations:

*   **Segment-Based Search:** Dividing the ray into segments and performing a coarse "dirty search" before a more precise "deep search" drastically reduces unnecessary checks, particularly when entities are sparsely distributed.
*   **Entity Filtering and Caching:** Using `TracePlus.Settings` and the `EntBufferTable` avoids redundant checks and calculations for ignored entities or entities that haven't moved.
*   **Early Termination:** The "fast search" and "deep search" are terminated as soon as a potential or confirmed hit is detected, preventing unnecessary iterations.
*   **Dynamic Search Radius:** The search radius for `FindByClassnameWithin()` is dynamically adjusted based on the segment's length, ensuring that the search area is appropriate for the current segment.
*   **Binary Refinement:** The optional binary refinement step further improves the hit point accuracy when enabled.

### Code Example:

```squirrel
// ... (BufferedEntity class, JumpPercent constant, EntBufferTable) ...

function TraceLineAnalyzer::Trace(startPos, endPos, ignoreEntities, note = null) {
    // ... (Initial Trace, entBuffer initialization, halfSegment, segmentsLenght, searchRadius calculations) ...

    for (local segment = 0; segment < 1; segment += JumpPercent) {
        // ... ("Dirty Search" logic) ...

        // ... ("Fast Search" logic) ...

        // ... ("Deep Search" logic) ...

        // ... (Binary Refinement logic - optional) ...

        // ... (Cleanup buffer) ...
    }

    // ... (Return result) ...
}
```

### Conclusion:

The BBox Casting algorithm implemented here presents a highly optimized solution for accurate and efficient collision detection in a game environment. By utilizing a tiered search strategy, caching relevant data, employing early termination techniques, and offering optional binary refinement, this algorithm minimizes computational overhead and ensures smooth gameplay even in scenarios involving numerous entities. 