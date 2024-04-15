/*
 * Represents a file for reading and writing.
*/
 ::File <- class {
    // The path to the file.  
    path = null;
    // The name of the file without the extension. 
    name = null;

    /*
     * Constructor for a File object.
     *
     * @param {string} path - The path to the file.
    */
    constructor(path) {
        this.name = split(path, "/")[0] //! mega todo
        if(path.find(".log") == null) 
            path += ".log"
        this.path = path
        this._recreateCache()
    }

    /*
     * Appends text to the file.
     *
     * @param {string} text - The text to append. 
    */
    function write(text) {
        local cmd = "script " + name + ".append(\\\"" + text + "\\\");"
        this._write(cmd)
    }

    /*
     * Writes a command to the console to manipulate the file.
     *
     * @param {string} command - The command to execute. 
    */
    function _write(command) {
        SendToConsole("con_logfile cfg/" + this.path)
        SendToConsole("script printl(\"" + command + "\")")
        SendToConsole("con_logfile off")
    }

    /* 
     * Reads the lines of the file and returns them as an array.
     *
     * @returns {array} - An array of strings, where each string is a line from the file. 
    */
    function readlines() {
        this._recreateCache()
        this.updateInfo()

        if(this.name in getroottable()) 
            return getroottable()[this.name]
        return []
    }

    /* 
     * Reads the entire contents of the file and returns it as a string.
     * 
     * @returns {string} - The contents of the file as a string. 
    */
    function read() {
        local result = ""
        foreach(line in this.readlines()){
            result += line + "\n"
        }
        return result
    }

    /*
     * Recreates the cache array for the file if it doesn't exist.
    */
    function _recreateCache() {
        if(this.name in getroottable()) 
            return
        SendToConsole("script ::" + this.name + " <- []")
    }

    /*
     * Clears the contents of the file. 
    */
    function clear() {
        this._recreateCache()
        this._write("script " + name + ".clear()")
    }

    /*
     * Updates information about the file by executing it. 
    */
    function updateInfo() {
        SendToConsole("exec " + path)
    }
}