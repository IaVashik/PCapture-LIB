/*
 * Represents a scheduled action.
 *
 * This class encapsulates information about an action that is scheduled to be executed at a specific time.
*/
 ::ScheduleAction <- class {
    //  The entity that created the event. * 
    caller = null;
    // The action to execute when the scheduled time arrives.  
    action = null;
    // The time at which the action is scheduled to be executed. 
    executionTime = null;
    // Optional arguments to pass to the action function.  
    args = null;

    /*
     * Constructor for a ScheduleAction object.
     *
     * @param {pcapEntity} caller - The entity that created the event.
     * @param {string|function} action - The action to execute when the event is triggered.
     * @param {number} delay - The time at which the event is scheduled to be executed.
     * @param {array|null} args - Optional arguments to pass to the action function. 
    */
    constructor(caller, action, delay, args = null) {
        this.caller = caller

        this.action = action
        this.executionTime = delay + Time()

        this.args = args
    }

    /* 
     * Executes the scheduled action. 
     *
     * If the action is a string, it is compiled into a function before execution.
     * If arguments are provided, they are passed to the action function. 
     *
     * @returns {any} - The result of the action function. 
    */
    function run() {
        if(type(action) == "string")
            action = compilestring(action)

        if(args == null) {
            return action.call(caller)
        }
        
        if(typeof args != "array" && typeof args != "arrayLib" && typeof args != "List") {
            throw("Invalid arguments for ScheduleEvent! The argument must be itterable, not (" + args + ")")
        }

        local actionArgs = [caller]
        actionArgs.extend(this.args)
        return action.acall(actionArgs)
    }

    function GetInfo() return "[Caller] " + caller + "\n[Action] " + action + "\n[executionTime] " + executionTime
    function _typeof() return "ScheduleAction"
    function _tostring() return "ScheduleAction: (" + this.executionTime + ")"
    function _cmp(other) {    
        if (this.executionTime > other.executionTime) {
            return 1;
        } else if (this.executionTime < other.executionTime) {
            return -1;
        } else {
            return 0; 
        }
    }
}