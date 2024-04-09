IncludeScript("Tests/test_exec")

template_tests <- {
    function some_test() {
        return assert(4 == 2*2)
    },

    function some_test_2() {
        return assert(true)
    },

    function some_test_3() {
        return assert(4 == 5)
    },
}

// Run all tests
RunTests("Template", template_tests)