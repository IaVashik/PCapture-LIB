/*+--------------------------------------------------------------------------------+
|                           PCapture Vscripts Library                               |
 +---------------------------------------------------------------------------------+
| Author:                                                                           |
|     One-of-a-Kind - laVashik                                                      |
 +---------------------------------------------------------------------------------+
| pcapture-lib                                                                  |
|       The main file in the library. initializes required parts of the library     |
|    GitHud repo: https://github.com/IaVashik/PCapture-LIB                          |
+----------------------------------------------------------------------------------+ */

local version = "PCapture-Lib 4.0 Debug"
local rootScope = getroottable()

// `Self` must be in any case, even if the script is run directly by the interpreter
if (!("self" in this)) {
    self <- Entities.First()
} else {
    getroottable()["self"] <- self
}

if("LIB_VERSION" in getroottable() && version.find("Debug") == null) {
    printl("\n")
    dev.warning("PCapture-Lib already initialized.")
    if(LIB_VERSION != version) {
        dev.error("Attempting to initialize different versions of the PCapture-Lib library!")
        dev.fprint("Version \"{}\" != \"{}\"", LIB_VERSION, version)
    }
    return
}


// --- Global Tables Initialization --- \\
::pcapEntityCache <- {}
::EntitiesScopes <- {}
::TracePlusIgnoreEnts <- {}
// ------------------------------------ \\

// --- TODO RENAME SECTION --- \\
::LIB_VERSION <- version
::PCaptureLibInited <- true
const ALWAYS_PRECACHED_MODEL = "models/weapons/w_portalgun.mdl" // needed for pcapEntity::EmitSoundEx
const MAX_PORTAL_CAST_DEPTH = 4
::PCLIB_DEFAULT_FEATURES <- {
    TracePlus = true,
    Math = true,
    UtilsExtra = true,
    HUD = true,
    ScriptEvents = true,
    Animations = true,
}
// --------------------------- \\


/// --------- CORE MODULES --------- \\\
DoIncludeScript("PCapture-LIB/SRC/DataTypesEx/init", rootScope)
DoIncludeScript("PCapture-LIB/SRC/ActionScheduler/init", rootScope)
DoIncludeScript("PCapture-LIB/SRC/EntitiesEx/init", rootScope)
DoIncludeScript("PCapture-LIB/SRC/Utils/init", rootScope)
/// ---------------------------------- \\\


/// --------- FEATURES MODULES --------- \\\
if(!("PCLIB_FEATURES" in getroottable())) {
    // NOT IMPLEMENTED YET
}

DoIncludeScript("PCapture-LIB/SRC/FEATURES/Math/init", rootScope)
DoIncludeScript("PCapture-LIB/SRC/FEATURES/TracePlus/init", rootScope)
DoIncludeScript("PCapture-LIB/SRC/FEATURES/Animations/init", rootScope)
DoIncludeScript("PCapture-LIB/SRC/FEATURES/ScriptEvents/init", rootScope)
DoIncludeScript("PCapture-LIB/SRC/FEATURES/HUD/init", rootScope)
DoIncludeScript("PCapture-LIB/SRC/FEATURES/UtilsExtra/init", rootScope)
/// ------------------------------------ \\\


/*
 * Prints information about the PCapture library upon initialization.
 *
 * This includes the library name, version, author, and a link to the GitHub repository.
*/
printl("\n----------------------------------------")
printl("Welcome to " + LIB_VERSION)
printl("Author: laVashik Production") // The God of VScripts :P
printl("GitHub: https://github.com/IaVashik/PCapture-LIB")
printl("----------------------------------------\n")