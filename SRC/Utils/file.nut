::File <- class {
    path = null;
    name = null;

    constructor(path) {
        this.name = split(path, "/")[0] //! mega todo
        if(path.find(".log") == null) 
            path += ".log"
        this.path = path
        this._recreateCache()
    }

    function write(text) {
        local cmd = "script " + name + ".append(\\\"" + text + "\\\");"
        this._write(cmd)
    }

    function _write(command) {
        SendToConsole("con_logfile cfg/" + this.path)
        SendToConsole("script printl(\"" + command + "\")")
        SendToConsole("con_logfile off")
    }

    function readlines() {
        this._recreateCache()
        this.updateInfo()

        if(this.name in getroottable()) 
            return getroottable()[this.name]
        return []
    }

    function read() {
        local result = ""
        foreach(line in this.readlines()){
            result += line + "\n"
        }
        return result
    }

    function _recreateCache() {
        if(this.name in getroottable()) 
            return
        SendToConsole("script ::" + this.name + " <- []")
    }

    function clear() {
        this._recreateCache()
        this._write("script " + name + ".clear()")
    }

    function updateInfo() {
        SendToConsole("exec " + path)
    }
}