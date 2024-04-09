::TracePlus <- {
    Result = {},
    Portals = {},
    FromEyes = {},

    Settings = null,
    defaultSettings = null,

    Cheap = null,
    Bbox = null,
}


IncludeScript("SRC/TracePlus/results")
IncludeScript("SRC/TracePlus/settings")
TracePlus.defaultSettings = TracePlus.Settings.new()

IncludeScript("SRC/TracePlus/cheap_trace")
IncludeScript("SRC/TracePlus/bboxcast")
IncludeScript("SRC/TracePlus/portal_casting")

IncludeScript("SRC/TracePlus/bbox_analyzer")
IncludeScript("SRC/TracePlus/calculate_normal")
