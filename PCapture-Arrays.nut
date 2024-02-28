/*+--------------------------------------------------------------------------------+
|                           PCapture Vscripts Library                               |
 +---------------------------------------------------------------------------------+
| Author:                                                                           |
|     One-of-a-Kind - laVashik :D                                                   |
 +---------------------------------------------------------------------------------+
| PCapture-array.nut                                                                 |
|       Improved arrays module. Contains easy output in the console                  |
|       and additional features to simplify life                                     |
+----------------------------------------------------------------------------------+ */

if("arrayLib" in getroottable()) {
    dev.warning("Enhanced arrays module initialization skipped. Module already initialized.")
    return
}

/*
* Enhanced arrays module.
*/
::arrayLib <- class {

    /* The internal array. */
    arr = null
    
    /* The internal table representation. */
    table = null;
    
    /* Whether the internal table is valid. */
    tableIsValid = false
    
    /*
    * Constructor.
    *
    * @param {array} array - The initial array.
    */
    constructor(array = []) {
        this.arr = array
        this.table = {}
    }

    /*
    * Create a new arrayLib instance from arguments.
    *
    * @param {...any} vargv - The values for the array.
    * @returns {arrayLib} - The new arrayLib instance. 
    */
    function new(...) {
        local arr = array(vargc)
        for(local i = 0; i< vargc; i++) {
            arr[i] = vargv[i]
        }
        return arrayLib(arr)
    }

    /*
    * Append a value to the array.
    *
    * @param {any} val - The value to append.
    * @returns {int} - The new array length.
    */
    function append(val) {
        this._pushToTable(val)
        arr.append(val);
        return this
    }

    /*
    * Apply a function to each element.
    *
    * @param {Function} func - The function to apply.
    */
    function apply(func) {
        foreach(idx, value in arr) {
            arr[idx] = func(value)
        }
        this.totable(true)
        return this
    }

    /*
    * Clear the array and table.
    */
    function clear() {
        this.arr.clear()
        this.table.clear()
        this.tableIsValid = false
        return this
    }

    /*
    * Extend the array with another array.
    *
    * @param {array} other - The array to extend from.
    */
    function extend(other) {
        if(typeof other == "arrayLib") {
            other = other.arr
        }
        arr.extend(other);
        this.totable(true)
        return this
    }

    /*
    * Filter the array by a predicate function.
    *
    * @param {Function} func(inx, val, newArr) - The predicate function. 
    * @returns {arrayLib} - The filtered array.
    */
    function filter(func) {
        local newArray = arrayLib([])
        foreach(idx, val in arr) {
            if(func(idx, val, newArray))
                newArray.append(val)
        }
        return newArray
    }

    /*
    * Check if the array contains a value.
    *
    * @param {any} match - The value to find.
    * @returns {boolean} - Whether the value is found.
    */
    function find(match) {
        if(!this.tableIsValid) this.totable()
        return match in this.table
    }

    /*
    * Search for a value in the array.
    *
    * @param {any|Function} match - The value or predicate to search for.
    * @returns {int|null} - The index of the match or null.
    */
    function search(match) {
        if(typeof match == "function") {
            foreach(idx, val in arr) {
                if(match(val))
                    return idx
            }
        }
        else {
            foreach(idx, val in arr) {
                if(val == match)
                    return idx
            }
        }

        return null
    }

    /*
    * Insert a value into the array.
    *
    * @param {int} idx - The index to insert at.
    * @param {any} val - The value to insert.
    */
    function insert(idx, val) {
        this._pushToTable(val)
        return arr.insert(idx, val)
    }

    /*
    * Get the array length.
    *
    * @returns {int} - The array length.
    */
    function len() {
        return arr.len()
    }

    /*
    * Map the array to a new array via a function.
    *
    * @param {Function} func - The mapping function.
    * @returns {arrayLib} - The mapped array.
    */
    function map(func) {
        local newArray = array(this.len())
        foreach(idx, value in arr) {
            newArray[idx] = func(value)
        }
        return arrayLib(newArray)
    }

    /*
    * Pop a value off the end of the array.
    *
    * @returns {any} - The popped value.
    */
    function pop() {
        local pop = arr.pop()
        this._deleteFromTable(pop)
        return pop
    }

    /*
    * Append a value to the array.
    *
    * @param {any} val - The value to append.
    */
    function push(val) {
        this.append(val)
    }

    // function reduce(func) {

    // }

    /*
    * Remove an element by index.
    *
    * @param {int} idx - The index to remove.
    */
    function remove(idx) {
        this._deleteFromTable(arr[idx])
        arr.remove(idx);
    }

    /*
    * Resize the array.
    *
    * @param {int} size - The new size.
    * @param {any} fill - The fill value for new slots.
    */
    function resize(size, fill = null) {
        arr.resize(size, fill);
        this.totable(true)
    }

    /*
    * Reverse the array in-place.
    *
    * @returns {arrayLib} - The reversed array.
    */
    function reverse() {
        arr.reverse();
        return this
    }

    /*
    * Slice a portion of the array.
    *
    * @param {int} start - The start index.
    * @param {int} end - The end index.
    * @returns {arrayLib} - The sliced array.
    */
    function slice(start, end = null) {
        return arrayLib(arr.slice(start, end || this.len()))
    }

    /*
    * Sort the array.
    *
    * @param {Function} func - Optional compare function.
    * @returns {arrayLib} - The sorted array.
    */
    function sort(func = null) {
        func ? arr.sort(func) : arr.sort()
        return this
    }

    /*
    * Get the last element.
    *
    * @returns {any} - The last element.
    */
    function top() {
        return arr.top();
    }

    /*
    * Join the array into a string.
    *
    * @param {string} joinstr - The separator string.
    * @returns {string} - The joined string.
    */
    function join(joinstr = "") {
        if(this.len() == 0) return ""
        
        local string = ""
        foreach(elem in this.arr) {
            string += elem + joinstr
        }
        return joinstr.len() != 0 ? string.slice(0, joinstr.len() * -1) : string
    }

    /*
    * Retrieve the element at the specified index in the array.
    *
    * @param {integer} idx - The index of the element to retrieve.
    * @param {any} defaultVal - Optional default value to return if the index is out of bounds. Defaults to null.
    * @returns {any} - The element at the specified index or the default value if the index is out of bounds.
    */
    function get(idx, defaultVal = null) {
        if(this.len() > idx)
            return this.arr[idx]
        return defaultVal
    }

    /*
    * Convert the array to a table.
    *
    * @param {boolean} reacreate - Whether to recreate the table.
    * @returns {table} - The table representation.
    */
    function totable(reacreate = false) {
        if(this.table.len() > 0 && !reacreate) return this.table

        tableIsValid = true
        this.table.clear()
        foreach(element in arr) {
            this.table[element] <- null
        }
        return this.table
    }

    /*
    * Delete a value from the internal table.
    *
    * @param {any} val - The value to delete.
    */
    function _deleteFromTable(val) {
        if(val in this.table)
            this.table.rawdelete(val)
    }

    /*
    * Add a value to the internal table.
    *
    * @param {any} val - The value to add.
    */
    function _pushToTable(val) {
        if(this.table.len() != 0)
            this.table[val] <- null
    }


    function _cloned() {
        return arrayLib(clone this.arr)
    }

    /*
    * Convert the array to a string.
    *
    * @returns {string} - The string representation.
    */
    function _tostring() return format("Array: [%s]", this.join(", "))
    
    /*
    * Get the type name.
    *
    * @returns {"arrayLib"}
    */
    function _typeof () return "arrayLib";
    
    /*
    * Get an element by index.
    *
    * @param {int} idx - The index.
    * @returns {any} - The element.
    */
    function _get(idx) return arr[idx];
    
    /*
    * Set an element by index.
    *
    * @param {int} idx - The index.
    * @param {any} val - The new value.
    */
    function _set(idx, val) return arr[idx] = val;


    function _nexti(previdx) {
        if(this.len() == 0) return null
        if (previdx == null) return 0;
		return previdx < this.len() - 1 ? previdx + 1 : null;
	}
}