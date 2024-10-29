/*+--------------------------------------------------------------------------------+
|                           PCapture Vscripts Library                              |
+----------------------------------------------------------------------------------+
| Author:                                                                          |
|     Data Structure Maestro - laVashik ^v^                                        |
+----------------------------------------------------------------------------------+
|   The Improved Data Types module, offering enhanced versions of standard VScripts|
|   data structures like arrays, lists, and trees for efficient data management.   |
+----------------------------------------------------------------------------------+ */

::pcapEntityCache <- {}

IncludeScript("PCapture-LIB/SRC/IDT/entity")
IncludeScript("PCapture-LIB/SRC/IDT/entity_creator")

IncludeScript("PCapture-LIB/SRC/IDT/array")
IncludeScript("PCapture-LIB/SRC/IDT/list")
IncludeScript("PCapture-LIB/SRC/IDT/tree_sort")

// dissolve entity for pcapEnts
if(("dissolver" in getroottable()) == false) {
    ::dissolver <- entLib.CreateByClassname("env_entity_dissolver", {targetname = "@dissolver"})
} 