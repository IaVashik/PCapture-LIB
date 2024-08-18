/*
* Enhanced arrays module.
*/
::arrayLib <- class {
    // The internal array. 
    arr = null
    length = 0;
    
    // The internal table representation. 
    table = null;
    tableIsValid = false;
    
    /*
     * Constructor.
     * 
     * @param {array} array - The initial array.
    */
    constructor(array = []) {
        if(typeof array == "arrayLib")
            array = array.arr
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
        if(IsVSquirrel3) return arrayLib(vargv)
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
     * @returns {arrayLib} - The arrayLib instance for chaining.
    */
    function append(val) {
        this._pushToTable(val)
        arr.append(val);
        return this
    }

    /*
     * Apply a function to each element and modify the array in-place.
     * 
     * @param {Function} func - The function to apply.
     * @returns {arrayLib} - The arrayLib instance for chaining.
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
     * 
     * @returns {arrayLib} - The arrayLib instance for chaining.
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
     * @param {array|arrayLib} other - The array to extend from.
     * @returns {arrayLib} - The arrayLib instance for chaining.
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
     * @param {Function} condition(index, value, newArray) - The predicate function. 
     * @returns {arrayLib} - The filtered array.
    */
    function filter(condition) {
        local newArray = arrayLib([])
        foreach(idx, val in arr) {
            if(condition(idx, val, newArray))
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
    function contains(match) { 
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
        return this.arr.len()
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
     * Reduce the array to a single value.
     * 
     * @param {Function} func - The reducer function, which takes the accumulator and current item as arguments.
     * @param {any} initial - The initial value of the accumulator.
     * @returns {any} - The reduced value.
    */
    function reduce(func, initial) {
        local accumulator = initial
        foreach(item in arr) {
            accumulator = func(accumulator, item)
        }
        return accumulator
    }

    /*
     * Return a new array with only unique elements.
     * 
     * @returns {arrayLib} - The new array with unique elements.
    */
    function unique() {
        local seen = {}
        local result = arrayLib([])
        
        foreach(value in this.arr) {
            if(value in seen) continue
            seen[value] <- true    
            result.append(value)
        }

        return result
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

    /*
     * Remove an element by index.
     * 
     * @param {int} idx - The index to remove.
     * @returns {any} - The value of the removed element.
    */
    function remove(idx) {
        local value = arr[idx]
        this._deleteFromTable(arr[idx])
        arr.remove(idx);
        return value
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
     * @param {int} startIndex - The start index.
     * @param {int} endIndex - The end index. (optional)
     * @returns {arrayLib} - The sliced array.
    */
    function slice(startIndex, endIndex = null) {
        return arrayLib(arr.slice(startIndex, endIndex || this.len()))
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
            if(element) this.table[element] <- null
        }
        return this.table
    }

    function tolist() {
        local list = List()
        foreach(idx, value in this.arr) {
            list.append(value)
        }
        return list
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


    function _cloned(...) {
        local arrCLoned = clone this.arr
        return arrayLib(arrCLoned)
    }

    function cloned() {
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

    function cmp(other) { // lmao, why? :O
        local thisSum = 0;
        local otherSum = 0;
        foreach (val in this) { thisSum += val; }
        foreach (val in other) { otherSum += val; }

    
        if (thisSum > otherSum) {
            return 1;
        } else if (thisSum < otherSum) {
            return -1;
        } else {
            return 0; 
        }
    }
}