/*+--------------------------------------------------------------------------------+
|                           PCapture Vscripts Library                              |
+----------------------------------------------------------------------------------+
| Author:                                                                          |
|     Data Structure Maestro - laVashik ^v^                                        |
+----------------------------------------------------------------------------------+
|   TODO                                                                           |
|                                                                                  |
+----------------------------------------------------------------------------------+ */

IncludeScript("PCapture-LIB/SRC/EntitiesEx/entity")
IncludeScript("PCapture-LIB/SRC/EntitiesEx/entity_creator")

// dissolve entity for PCapEntity
if(("dissolver" in getroottable()) == false) {
    ::dissolver <- entLib.CreateByClassname("env_entity_dissolver", {targetname = "@dissolver"})
} 

// Garbage collector for `PCapEntity::EntitiesScopes` 
ScheduleEvent.AddInterval("global", function() {
    foreach(ent, _ in EntitiesScopes) {
        if(!ent || !ent.IsValid()) {
            delete EntitiesScopes[ent]
        }
    }
}, 5, 0)