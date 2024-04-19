// Utils Module Unit Tests
IncludeScript("Tests/test_exec")

utils_tests <- {
    // --- Debug Tests ---
    function debug_draw_entity_bbox_test() {
        local ent = GetPlayerEx()
        dev.DrawEntityBBox(ent, 10.0)
    },

    function debug_log_test() {
        dev.log("This is a test log message.")
    },

    function debug_warning_test() {
        dev.warning("This is a test warning message.")
        return assert(cwar.len() > 0) // Assuming the warning message is stored
    },

    function debug_error_test() {
        dev.error("This is a test error message.")
        return assert(cerr.len() > 0) // Assuming the error message is stored
    },

    function debug_format_test() {
        local formattedString = dev.format("Name: {}, Age: {}", "John", 30)
        return assert(formattedString == "Name: John, Age: 30")
    },

    // --- Macros Tests --- 
    function macros_get_from_table_test() {
        local table = {key1 = "value1", key2 = "value2"}
        return assert(macros.GetFromTable(table, "key1") == "value1" && macros.GetFromTable(table, "key3", "default") == "default")
    },

    function macros_get_dist_test() {
        local vec1 = Vector(0, 0, 0) 
        local vec2 = Vector(10, 0, 0)
        return assert(macros.GetDist(vec1, vec2) == 10)
    },

    function macros_strtovec_test() {
        local vec = macros.StrToVec("10 20 30")
        return assert(vec.x == 10 && vec.y == 20 && vec.z == 30)
    },

    function macros_get_prefix_test() {
        return assert(macros.GetPrefix("prefix-postfix") == "prefix-")
    },

    function macros_get_postfix_test() {
        return assert(macros.GetPostfix("prefix-postfix") == "-postfix")
    },

    function macros_isEqually() {
        return assert(
            macros.isEqually(11343, 11343) && 
            macros.isEqually(1.543543, 1.54354) &&
            macros.isEqually(Vector(1,2,3.43), Vector(1,2,3.43)) &&
            macros.isEqually(GetPlayer(), GetPlayer()) && 
            macros.isEqually(GetPlayerEx(), GetPlayer()) && 
            macros.isEqually(math.Quaternion.fromEuler(Vector(0, 90, 0)), math.Quaternion.fromEuler(Vector(0, 90, 0))) && 
            macros.isEqually(math.Matrix.fromEuler(Vector(0, 90, 0)), math.Matrix.fromEuler(Vector(0, 90, 0)))
        )
    }

    // --- Scripts Tests ---
    function scripts_run_script_code_delay_test() {
        local testFunc = function() {
            printl("I'm a pending print...")
        }

        RunScriptCode.delay(testFunc, 1.0)
        return assert(ScheduleEvent.GetEvent("global") != null) // Assuming the event is scheduled correctly
    },

    function scripts_run_script_code_from_str_test() {
        run_script_code_from_str_result <- 0
        local result = RandomInt(1, 100)
        RunScriptCode.fromStr("run_script_code_from_str_result = " + result)
        return assert(run_script_code_from_str_result == result) 
    },
}

// Run all tests
RunTests("Utils", utils_tests) 