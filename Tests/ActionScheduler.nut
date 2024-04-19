// Events Module Unit Tests
IncludeScript("Tests/test_exec")

events_tests <- {
    function schedule_event_test() {
        local testFunc = function(){
            return assert(true)
        }    

        ScheduleEvent.Add("schedule_event_test", testFunc, 0.1)
        return assert(ScheduleEvent.GetEvent("schedule_event_test").len() == 1)
    },

    function cancel_scheduled_event_test() {
        local testFunc = function() {
            return assert(false) // This should not be called
        }

        ScheduleEvent.Add("cancel_scheduled_event_test", testFunc, 0.1)
        ScheduleEvent.Cancel("cancel_scheduled_event_test")
        return assert(ScheduleEvent.IsValid("cancel_scheduled_event_test") == false) 
    },

    function event_info_test() {
        local testFunc = function() {
            return assert(true)
        }

        ScheduleEvent.Add("event_info_test", testFunc, 0.1, null, "Test Note")
        local eventInfo = ScheduleEvent.GetEvent("event_info_test")
        return assert(eventInfo.len() == 1 && eventInfo[0].note == "Test Note")
    },

    function event_validity_test() {
        local testFunc = function() {
            return assert(true)
        }

        ScheduleEvent.Add("event_validity_test", testFunc, 0.1)
        return assert(ScheduleEvent.IsValid("event_validity_test"))
    },

    function get_event_note_test() {
        local testFunc = function() {
            return assert(true)
        }

        ScheduleEvent.Add("get_event_note_test", testFunc, 0.1, null, "Test Note")
        return assert(ScheduleEvent.GetNote("get_event_note_test") == "Test Note")
    },

    function schedule_event_with_args_test() {
        local testFunc = function(arg1, arg2) {
            return assert(arg1 == 1 && arg2 == 2) 
        }

        ScheduleEvent.Add("schedule_event_with_args_test", testFunc, 0.1, [1, 2], null) 
        return assert(ScheduleEvent.GetEvent("schedule_event_with_args_test").len() == 1)
    },

    function schedule_event_with_string_action_test() {
        local testString = "printl(\"This is a test\")" 
        ScheduleEvent.Add("string_script_test", testString, 0.1) 
        return assert(ScheduleEvent.GetEvent("string_script_test").len() == 1) 
    },

    function schedule_event_with_delay_test() { 
        local startTime = Time()
        local testFunc = function() : (startTime) {
            return assert(Time() >= startTime + 0.1) 
        }

        ScheduleEvent.Add("test_with_delay", testFunc, 0.1) 
        return assert(ScheduleEvent.GetEvent("test_with_delay").len() == 1) 
    },

    function cancel_scheduled_event_with_delay_test() { 
        local testFunc = function() {
            return assert(false) 
        }

        ScheduleEvent.Add("cancel_test_event", testFunc, 0.2) 
        ScheduleEvent.Cancel("cancel_test_event", 0.1) 
        return assert(ScheduleEvent.IsValid("cancel_test_event")) 
    },

    function cancel_test_event() { 
        local x = ThisTest()
        x.test()
    },
}

class ThisTest {
    constructor() {}

    function theta() {
        printl("Hello, Theta!")
    }

    function test() {
        ScheduleEvent.Add("this_test_event", theta, 0.2) 
    }
}

// Run all tests
RunTests("Events", events_tests)