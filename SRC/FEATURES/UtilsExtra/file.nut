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
        path = split(path, "/").top()
        this.name = split(path, "/").top()

        if(path.find(".log") == null) {
            path += ".log"
        } else {
            this.name = this.name.slice(0, -4)
        }
        
        this.path = path
        if(!(this.name in getroottable()))
            getroottable()[this.name] <- []
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

    function writeRawData(text) {
        this._write(text)
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
     * Clears the contents of the file. 
    */
    function clear() {
        this._write("script " + name + ".clear()")
    }

    /*
     * Updates information about the file by executing it. 
    */
    function updateInfo() {
        getroottable()[this.name].clear()
        SendToConsole("exec " + path)
    }
}