/*+---------------------------------------------------------------------------------+
|                     Advanced TraceLine Library for Portal 2                       |
+-----------------------------------------------------------------------------------+
| Author:                                                                           |
|     One-of-a-Kind - laVashik :D                                                   |
+-----------------------------------------------------------------------------------+ */

IncludeScript("pcapture-lib/SRC/TracePlus/pcapture-lib")
IncludeScript("pcapture-lib/SRC/TracePlus/TraceSettings")

//* Default settings for bboxcast traces.
::defaultSettings <- TraceSettings.new()


IncludeScript("pcapture-lib/SRC/TracePlus/TraceResult")
IncludeScript("pcapture-lib/SRC/TracePlus/CheapTrace")
IncludeScript("pcapture-lib/SRC/TracePlus/TraceLineAnalyzer")
IncludeScript("pcapture-lib/SRC/TracePlus/BboxCasting")
IncludeScript("pcapture-lib/SRC/TracePlus/PortalCasting")

IncludeScript("pcapture-lib/SRC/TracePlus/Presets")

IncludeScript("pcapture-lib/SRC/TracePlus/utils/ImpactNormal")
IncludeScript("pcapture-lib/SRC/TracePlus/utils/BBoxDisabler")