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

const MAX_PORTAL_CAST_DEPTH = 7

IncludeScript("SRC/TracePlus/results")
IncludeScript("SRC/TracePlus/trace_settings")
TracePlus.defaultSettings = TracePlus.Settings.new()

IncludeScript("SRC/TracePlus/cheap_trace")
IncludeScript("SRC/TracePlus/bboxcast")
IncludeScript("SRC/TracePlus/portal_casting")

IncludeScript("SRC/TracePlus/bbox_analyzer")
IncludeScript("SRC/TracePlus/calculate_normal")