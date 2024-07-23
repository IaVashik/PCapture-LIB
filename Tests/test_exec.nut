IncludeScript("SRC/PCapture-Lib")

function RunTests(testName, tests_table) {
    dev.fprint("\n{} tests are running...", testName)
    printl("-------------------------------------------------")
    
    local passed_tests = tests_table.len()
    local unsuccessful = List()
    foreach(name, test_func in tests_table) {
        test_func()
        try {
        } catch(exception) {
            dev.fprint("{} test error: function {} ({})", testName, name, exception)
            unsuccessful.append(name)
            passed_tests--
        }
    }

    local resTest = "Tests passed successfully!"
    if(unsuccessful.len() > 0) {
        resTest = macros.format("{} tests with error:\n* {}", testName, unsuccessful.join("\n* "))
        printl("")
    } 
    dev.fprint("~~ {} tests result: {}/{} passed. ~~", testName, passed_tests, tests_table.len())
    printl(resTest)
    printl("-------------------------------------------------\n")
}

function RunAllTests() {
    IncludeScript("Tests/Math")
    IncludeScript("Tests/IDT")
    IncludeScript("Tests/Utils")
    IncludeScript("Tests/ActionScheduler")
}

local stack
    for(local i = 1; stack = getstackinfos(i); i++)
        macros.fprint("*FUNCTION [{}()] {} line [{}]", stack.func, stack.src, stack.line)