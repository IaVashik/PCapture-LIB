/* 
 * Represents a scheduled event. 
 *
 * This class encapsulates information about an event that is scheduled to be executed at a later time. 
*/
 ::ScheduleEvent <- class {
    //  The entity that created the event. * 
    caller = null;
    // The action to execute when the event is triggered.  
    action = null;
    // The time at which the event is scheduled to be executed. 
    timeDelay = null;
    // An optional note describing the event.  
    note = null;
    // Optional arguments to pass to the action function.  
    args = null;

    /*
     * Constructor for a ScheduleEvent object.
     *
     * @param {pcapEntity} caller - The entity that created the event.
     * @param {string|function} action - The action to execute when the event is triggered.
     * @param {number} timeDelay - The time at which the event is scheduled to be executed.
     * @param {string|null} note - An optional note describing the event. 
     * @param {array|null} args - Optional arguments to pass to the action function. 
    */
    constructor(caller, action, timeDelay, note = null, args = null) {
        this.caller = caller

        this.action = action
        this.timeDelay = timeDelay
        this.note = note

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

        if(!args) {
            return action.call(caller)
        }

        local actionArgs = [caller]
        actionArgs.extend(args)
        return action.acall(actionArgs)
    }

    function _typeof() return "ScheduleEvent"
    function _tostring() return "[Caller] " + caller + "\n[Action] " + action + "\n[TimeDelay] " + timeDelay + "\n[Note] " + note 
    function _cmp(other) {    
        if (this.timeDelay > other.timeDelay) {
            return 1;
        } else if (this.timeDelay < other.timeDelay) {
            return -1;
        } else {
            return 0; 
        }
    }
}