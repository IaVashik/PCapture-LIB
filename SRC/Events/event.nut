
::ScheduleEvent <- class {
    caller = null;
    action = null;
    timeDelay = null;
    note = null;
    args = null;

    constructor(caller, action, timeDelay, note = null, args = null) {
        this.caller = caller

        this.action = action
        this.timeDelay = timeDelay
        this.note = note

        this.args = args
    }

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