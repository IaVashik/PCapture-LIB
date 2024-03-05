// Include the main PCapture library script, which contains utility functions and event handling.
IncludeScript("pcapture-lib/SRC/pcapture-lib")

// Define a function that logs "Hello world!" and reschedules itself to run again after a specified delay.
function helloLoop(loopDelay) {
    // Log the message to the console if developer mode is enabled.
    dev.log("Hello world!")
    
    // Create a scheduled event named "helloLoop" that calls the helloLoop function again 
    // with the same delay after the specified loopDelay has passed.
    CreateScheduleEvent("helloLoop", function() : (loopDelay) {
        helloLoop(loopDelay)
    }, loopDelay)
}

// Start the helloLoop function with a delay of 1 second.
helloLoop(1)

// Cancel the scheduled event "helloLoop" after 10 seconds.
cancelScheduledEvent("helloLoop", 10)

// Delay the execution of the "printl" function, which prints "STOP!" to the console, by 10.1 seconds.
RunScriptCode.delay("printl(\"STOP!\")", 10.1)