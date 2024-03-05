// Include the PCapture library
IncludeScript("pcapture-lib/SRC/pcapture-lib") 

// Find a weighted cube entity
local cargo = entLib.FindByClassname("prop_weighted_cube")

// Error if no cube found
if(cargo == null)
    return dev.error("There is not a single prop_weighted_cube on the map")

// Set render mode to transparent 
cargo.SetKeyValue("rendermode", 5)

// Fade opacity from 255 to 125 over 1 second
animate.AlphaTransition(cargo, 255, 125, 1)

// Transition color from white to orange over 1 second after 0.5 second delay 
animate.ColorTransition(cargo, "255 255 255", "255 125 0", 1, {globalDelay = 0.5})

// Move cube to Vector(0, 0, 0) at a speed of 1 unit/s after 1 second delay
animate.PositionTransitionBySpeed(cargo, cargo.GetOrigin(), Vector(), 1, {eventName = "cargo_move", globalDelay = 1})

// Transition color back to white over 1.5 seconds after 1.5 second delay
// Cancel "cargo_move" event on completion 
animate.ColorTransition(cargo, "255 125 0", "255 255 255", 1.5, {globalDelay = 1.5, outputs = function() {
        cancelScheduledEvent("cargo_move")
    }
})


// Additional commands to configure the environment
EntFireByHandle(self, "runscriptcode", "SendToConsole(\"developer 1\")", 1, null, null)