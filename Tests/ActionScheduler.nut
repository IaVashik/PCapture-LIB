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

        ScheduleEvent.Add("event_info_test", testFunc, 0.1, null)
        local eventInfo = ScheduleEvent.GetEvent("event_info_test")
        return assert(eventInfo.len() == 1)
    },

    function add_new_actions_test() {
        local actions = List()
        for(local i = 50; i >= 0; i--) {
            actions.append(ScheduleAction(this, "1 + 1", RandomFloat(1, 10), null))
        }

        ScheduleEvent.AddActions("add_new_actions_test", actions, false)
        
        local list = ScheduleEvent.GetEvent("add_new_actions_test")
        for(local i = 1; i < list.len(); i++) {
            if(list[i - 1] > list[i]) {
                return assert(false)
            }
        }
    },

    function add_actions_test() {
        local create = function() {
            local actions = List()
            for(local i = 30; i >= 0; i--) {
                actions.append(ScheduleAction(this, "1 + 1", RandomFloat(1, 10), null))
            }
            return actions
        }

        ScheduleEvent.AddActions("add_actions_test", create(), false)
        ScheduleEvent.AddActions("add_actions_test", create(), false)
        ScheduleEvent.AddActions("add_actions_test", create(), false)
        
        local list = ScheduleEvent.GetEvent("add_actions_test")
        
        for(local i = 1; i < list.len(); i++) {
            if(list[i - 1] >= list[i]) {
                return assert(false)
            }
        }
    },

    function add_new_actions_nosort_test() {
        local actions = List()
        for(local i = 50; i >= 0; i--) {
            actions.append(ScheduleAction(this, "1 + 1", (50 - i.tofloat()) / 10, null))
        }

        ScheduleEvent.AddActions("add_new_actions_nosort_test", actions, true)

        local list = ScheduleEvent.GetEvent("add_new_actions_nosort_test")
        for(local i = 1; i < list.len(); i++) {
            if(list[i - 1] >= list[i]) {
                return assert(false)
            }
        }
    },

    function add_actions_nosort_test() {
        local create = function(delay) {
            local actions = List()
            for(local i = 5; i >= 0; i--) {
                actions.append(ScheduleAction(this, "1 + 1", (5 - i.tofloat()) / 10 + delay, null))
            }
            return actions
        }

        ScheduleEvent.AddActions("add_actions_nosort_test", create(0), true)
        // ScheduleEvent.AddActions("add_actions_nosort_test", create(1), true)
        // ScheduleEvent.AddActions("add_actions_nosort_test", create(3), true)
        // ScheduleEvent.AddActions("add_actions_nosort_test", create(0.5), true)
        // ScheduleEvent.AddActions("add_actions_nosort_test", create(4), true)
        // ScheduleEvent.AddActions("add_actions_nosort_test", create(2), true)
        ScheduleEvent.AddActions("add_actions_nosort_test", create(0.3), true)
        
        local list = ScheduleEvent.GetEvent("add_actions_nosort_test")
        printl(list)
        for(local i = 1; i < list.len(); i++) {
            if(list[i - 1] >= list[i]) {
                printl(list[i - 1] + " > " + list[i] + " {"+i+"}")
                return assert(false)
            }
        }
    },

    function event_validity_test() {
        local testFunc = function() {
            return assert(true)
        }

        ScheduleEvent.Add("event_validity_test", testFunc, 0.1)
        return assert(ScheduleEvent.IsValid("event_validity_test"))
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
        local testFunc = function(startTime) {
            return assert(Time() >= startTime + 0.1) 
        }

        ScheduleEvent.Add("test_with_delay", testFunc, 0.1, [startTime]) 
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
    something = false
    constructor() {}

    function theta() {
        printl("Hello, Theta!")
        this.something = true
    }

    function test() {
        ScheduleEvent.Add("this_test_event", theta, 0.2, null, this) 
        ScheduleEvent.Add("this_test_event", function() {
            if(!this.something) throw("WTF BRO?")
        }, 0.3, null, this) 
    }
}

// Run all tests
RunTests("Events", events_tests)