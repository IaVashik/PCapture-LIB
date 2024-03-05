// Include the main PCapture library script, which contains utility functions and event handling.
IncludeScript("pcapture-lib/SRC/pcapture-lib")

// Define a function that prints an incrementing integer and reschedules itself with the incremented value.
function addOne(loopDelay, int = 0) {
    // Print the current integer and the next integer after incrementing by 1 to the console.
    fprint("{} + 1 = {}!", int, int+1)

    // Create a scheduled event named "loop" that calls the addOne function again with the incremented integer
    // and the same delay after the specified loopDelay has passed.
    CreateScheduleEvent("loop", function() : (loopDelay, int) {
        addOne(loopDelay, int + 1)
    }, loopDelay)
}

// Start the addOne function with a delay equal to the frame time (time between frames).
addOne(FrameTime())