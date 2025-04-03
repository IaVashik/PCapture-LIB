/*+--------------------------------------------------------------------------------+
|                           PCapture Vscripts Library                              |
+----------------------------------------------------------------------------------+
| Author:                                                                          |
|     Ray Tracing Virtuoso - laVashik ˙▿˙                                          |
+----------------------------------------------------------------------------------+
|       The TracePlus module, taking ray tracing to the next level with advanced   |
|       features like portal support and precise collision detection algorithms.   |
+----------------------------------------------------------------------------------+ */

::TracePlus <- {
    Result = {},
    Portals = {},
    FromEyes = {},

    Settings = null,
    defaultSettings = null,

    Cheap = null,
    Bbox = null,
}

IncludeScript("PCapture-LIB/SRC/FEATURES/TracePlus/results")
IncludeScript("PCapture-LIB/SRC/FEATURES/TracePlus/trace_settings")
TracePlus.defaultSettings = TracePlus.Settings.new()

IncludeScript("PCapture-LIB/SRC/FEATURES/TracePlus/cheap_trace")
IncludeScript("PCapture-LIB/SRC/FEATURES/TracePlus/bboxcast")
IncludeScript("PCapture-LIB/SRC/FEATURES/TracePlus/portal_casting")

IncludeScript("PCapture-LIB/SRC/FEATURES/TracePlus/bbox_analyzer")
IncludeScript("PCapture-LIB/SRC/FEATURES/TracePlus/calculate_normal")