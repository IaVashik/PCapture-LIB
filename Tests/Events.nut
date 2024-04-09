// Events Module Unit Tests
IncludeScript("Tests/test_exec")

events_tests <- {
    function schedule_event_test() {
        local testFunc = function(){
            return assert(true)
        }    

        CreateScheduleEvent("schedule_event_test", testFunc, 0.1)
        return assert(getEventInfo("schedule_event_test").len() == 1)
    },

    function cancel_scheduled_event_test() {
        local testFunc = function() {
            return assert(false) // This should not be called
        }

        CreateScheduleEvent("cancel_scheduled_event_test", testFunc, 0.1)
        cancelScheduledEvent("cancel_scheduled_event_test")
        return assert(eventIsValid("cancel_scheduled_event_test") == false) 
    },

    function event_info_test() {
        local testFunc = function() {
            return assert(true)
        }

        CreateScheduleEvent("event_info_test", testFunc, 0.1, "Test Note")
        local eventInfo = getEventInfo("event_info_test")
        return assert(eventInfo.len() == 1 && eventInfo[0].note == "Test Note")
    },

    function event_validity_test() {
        local testFunc = function() {
            return assert(true)
        }

        CreateScheduleEvent("event_validity_test", testFunc, 0.1)
        return assert(eventIsValid("event_validity_test"))
    },

    function get_event_note_test() {
        local testFunc = function() {
            return assert(true)
        }

        CreateScheduleEvent("get_event_note_test", testFunc, 0.1, "Test Note")
        return assert(getEventNote("get_event_note_test") == "Test Note")
    },

    function schedule_event_with_args_test() {
        local testFunc = function(arg1, arg2) {
            return assert(arg1 == 1 && arg2 == 2) 
        }

        CreateScheduleEvent("schedule_event_with_args_test", testFunc, 0.1, null, [1, 2]) 
        return assert(getEventInfo("schedule_event_with_args_test").len() == 1)
    },

    function schedule_event_with_string_action_test() {
        local testString = "printl(\"This is a test\")" 
        CreateScheduleEvent("string_script_test", testString, 0.1) 
        return assert(getEventInfo("string_script_test").len() == 1) 
    },

    function schedule_event_with_delay_test() { 
        local startTime = Time()
        local testFunc = function() : (startTime) {
            return assert(Time() >= startTime + 0.1) 
        }

        CreateScheduleEvent("test_with_delay", testFunc, 0.1) 
        return assert(getEventInfo("test_with_delay").len() == 1) 
    },

    function cancel_scheduled_event_with_delay_test() { 
        local testFunc = function() {
            return assert(false) 
        }

        CreateScheduleEvent("cancel_test_event", testFunc, 0.2) 
        cancelScheduledEvent("cancel_test_event", 0.1) 
        return assert(eventIsValid("cancel_test_event")) 
    },
}

// Run all tests
RunTests("Events", events_tests)