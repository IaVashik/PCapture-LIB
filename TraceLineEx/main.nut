/*+--------------------------------------------------------------------------------+
|                           PCapture Vscripts Library                               |
 +---------------------------------------------------------------------------------+
| Author:                                                                           |
|     One-of-a-Kind - laVashik :D                                                   |
 +---------------------------------------------------------------------------------+
| PCapture-bboxcast.nut                                                             |
|       Improved BBoxCast. More info here:                                          |
|       https://github.com/IaVashik/portal2-BBoxCast                                |
+----------------------------------------------------------------------------------+ */

IncludeScript("pcapture-lib/TraceLineEx/Settings")

//* Default settings for bboxcast traces.
::defaultSettings <- TraceSettings.new()


IncludeScript("pcapture-lib/TraceLineEx/CheapTrace")
IncludeScript("pcapture-lib/TraceLineEx/Trace")
IncludeScript("pcapture-lib/TraceLineEx/BboxCastings")
IncludeScript("pcapture-lib/TraceLineEx/PortalCastings")

// IncludeScript("pcapture-lib/TraceLineEx/Presets")

IncludeScript("pcapture-lib/TraceLineEx/utils/ImpactNormal")
IncludeScript("pcapture-lib/TraceLineEx/utils/BBoxDisabler")