IncludeScript("pcapture-lib/SRC/pcapture-lib")

// Custom settings for ignoring certain classes of entities
customSettings <- TraceSettings.new({ignoreClass = ["viewmodel", "weapon_", "info_target", "func_illusionary"]})
customSettings.EnablePortalTracing()

lastEntity <- null

// Loop function for continuous ray tracing
function LoopFunction() {
    // Perform a trace from the player's eyes with a maximum distance of 1000 units using custom settings
    local bboxTrace = bboxcast.TracePlayerEyes(1000, null, customSettings)
    dev.drawbox(bboxTrace.GetHitpos(), Vector(125, 125, 125))

    local entity = bboxTrace.GetEntity()

    // Reset color for the previously hit entity
    if (lastEntity != entity) {
        EntFireByHandle(lastEntity, "Color", "255 255 255", 0, null, null)
    }

    // Handle whether the trace hit the world or an entity
    if (bboxTrace.DidHitWorld()) {
        entity = "Worldspawn"
    }
    else {
        // Set color for the currently hit entity
        entity.SetColor("255 125 0")
        lastEntity = entity
    }

    dev.log("You are looking at: " + entity)

    // Schedule the next iteration of the loop
    RunScriptCode.delay("LoopFunction()", FrameTime())
}

// Start the loop function
LoopFunction()


// Additional commands to configure the environment
EntFireByHandle(self, "runscriptcode", "SendToConsole(\"developer 1\")", 1, null, null)