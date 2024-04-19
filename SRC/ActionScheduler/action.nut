/* 
 * Represents a scheduled event. 
 *
 * This class encapsulates information about an event that is scheduled to be executed at a later time. 
*/
 ::ScheduleAction <- class {
    //  The entity that created the event. * 
    caller = null;
    // The action to execute when the event is triggered.  
    action = null;
    // The time at which the event is scheduled to be executed. 
    executeTime = null;
    // An optional note describing the event.  
    note = null;
    // Optional arguments to pass to the action function.  
    args = null;

    /*
     * Constructor for a ScheduleAction object.
     *
     * @param {pcapEntity} caller - The entity that created the event.
     * @param {string|function} action - The action to execute when the event is triggered.
     * @param {number} timeDelay - The time at which the event is scheduled to be executed.
     * @param {array|null} args - Optional arguments to pass to the action function. 
     * @param {string|null} note - An optional note describing the event. 
    */
    constructor(caller, action, timeDelay, args = null, note = null) {
        this.caller = caller

        this.action = action
        this.executeTime = timeDelay + Time()
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

    // TODO
    function GetInfo() return "[Caller] " + caller + "\n[Action] " + action + "\n[executeTime] " + executeTime + "\n[Note] " + note 
    function _typeof() return "ScheduleAction"
    function _tostring() return "ScheduleAction: (" + this.executeTime + ")"
    function _cmp(other) {    
        if (this.executeTime > other.executeTime) {
            return 1;
        } else if (this.executeTime < other.executeTime) {
            return -1;
        } else {
            return 0; 
        }
    }
}