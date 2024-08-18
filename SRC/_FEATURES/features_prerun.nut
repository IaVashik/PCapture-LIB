if(_version_.find("Squirrel 3") != null) {
    ::IsVSquirrel3 <- true
    printl("Is VSquirrel 3+")
    IncludeScript("PCapture-LIB/SRC/_FEATURES/Squirrel3/TracePlus/bbox_analyzer")
    IncludeScript("PCapture-LIB/SRC/_FEATURES/Squirrel3/TracePlus/calculate_normal")
}