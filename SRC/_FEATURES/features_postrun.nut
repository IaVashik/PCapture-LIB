/* 
* Features Flags (TODO):
  - Squirrel 3 (auto)
  - Cheap Entities Finder (for bboxcast)
  - Replace Entities to cheap version
  - Replace "self" to "pcapEntity"?
*/

if("IsVSquirrel3" in getroottable()) {
    IncludeScript("PCapture-LIB/SRC/_FEATURES/Squirrel3/Utils/macros_sq3")
} 

if("FeatureCheapEnts" in getroottable()) {
    printl("Feature \"EntitiesFinder\" enabled!")
    IncludeScript("PCapture-LIB/SRC/_FEATURES/EntitiesFinder/init.nut")
}

