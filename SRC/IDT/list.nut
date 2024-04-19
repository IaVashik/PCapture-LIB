::ListNode <- class {
    value = null;
    prev_ref = null;
    next_ref = null;

    /*
     * Constructor for a list node.
     *
     * @param {any} value - The value to store in the node.
    */
    constructor(value) {
        this.value = value;
    }

    function _tostring() {
        return this.value.tostring();
    }
}

::List <- class {
    length = 0;
    first_node = null;
    last_node = null;

    /*
     * Constructor for a list.
     *
     * @param {...any} vargv - The initial values to add to the list.
    */
    constructor(...) {
        this.first_node = ListNode(0);
        this.last_node = this.first_node;
        
        for(local i = 0; i< vargc; i++) {
            this.append(vargv[i])
        }
    }

    /*
     * Creates a new list from an array.
     * 
     * @param {array} array - The array to create the list from.
     * @returns {List} - The new list containing the elements from the array.
    */
    function fromArray(array) {
        local list = List()
        foreach(val in array) 
            list.append(val)
        return list
    }

    /*
     * Gets the length of the list.
     *
     * @returns {number} - The number of elements in the list.
    */
    function len() {
        return this.length;
    }

    /*
     * Appends a value to the end of the list.
     * 
     * @param {any} value - The value to append.
    */
    function append(value) {
        local next_node = ListNode(value);
        local current_node = this.last_node;

        current_node.next_ref = next_node;
        next_node.prev_ref = current_node;

        this.last_node = next_node;
        this.length++;
    }

    /*
     * Inserts a value at a specific index in the list.
     * 
     * @param {number} index - The index to insert the value at.
     * @param {any} value - The value to insert.
    */
    function insert(idx, value) {
        if(this.length == 0 || idx >= this.length) 
            return this.append(value)
    
        local node = this.getNode(idx)
        local newNode = ListNode(value)

        newNode.next_ref = node
        newNode.prev_ref = node.prev_ref
        
        node.prev_ref.next_ref = newNode 
        node.prev_ref = newNode

        this.length++
    }

    /*
     * Gets the node at a specific index in the list.
     * 
     * @param {number} index - The index of the node to retrieve.
     * @returns {ListNode} - The node at the specified index.
     * @throws {Error} - If the index is out of bounds.
    */
    function getNode(idx) {
        if (idx >= this.length) {
            throw("the index '" + idx + "' does not exist!");
        }

        local node = this.first_node.next_ref;
        for (local i = 0; i < idx; i++) {
            node = node.next_ref;
        }
        return node;
    }

    /*
     * Gets the value at a specific index in the list.
     * 
     * @param {number} index - The index of the value to retrieve.
     * @param {any} defaultValue - The value to return if the index is out of bounds. (optional)
     * @returns {any} - The value at the specified index or the default value if the index is out of bounds.
    */
    function get(idx, defaultValue = null) {
        if (idx >= this.length)
            return defaultValue

        return this.getNode(idx).value
    }

    /*
     * Removes the node at a specific index from the list.
     * 
     * @param {number} index - The index of the node to remove.
    */
    function remove(idx) {
        local node = this.getNode(idx);
        local next = node.next_ref;
        local prev = node.prev_ref;

        if (prev)
            prev.next_ref = next;
        if (next) 
            next.prev_ref = prev;

        this.length--;
    }

    /*
     * Removes the last element from the list and returns its value.
     * 
     * @returns {any} - The value of the removed element.
    */
    function pop() {
        local current = this.last_node;
        this.last_node = current.prev_ref;
        this.last_node.next_ref = null;
        this.length--
        return current.value;
    }

    /*
     * Gets the value of the last element in the list.
     * 
     * @returns {any} - The value of the last element.
    */
    function top() {
        if(this.length == 0) throw("top() on a empty list")
        return this.last_node.value
    }

    function first() {
        if(this.length == 0) throw("first() on a empty list")
        return this.first_node.next_ref.value
    }

    /*
     * Reverses the order of the elements in the list in-place.
    */
    function reverse() {
        local prev_node = null;
        local current_node = this.first_node.next_ref;

        while (current_node) {
            local next_node = current_node.next_ref;

            current_node.next_ref = prev_node;
            current_node.prev_ref = next_node;

            prev_node = current_node;
            current_node = next_node;
        }

        local temp = this.first_node.next_ref;
        this.first_node.next_ref = prev_node;
        this.last_node = temp;
    }

    function sort() {
        this.first_node.next_ref = _mergeSort(this.first_node.next_ref)
        
        /* Обновление last_node */ 
        local node = this.first_node 
        while (node.next_ref) {
            node = node.next_ref
        }
        this.last_node = node 
        
        return this
    }

    function _mergeSort(head) {
        if (head == null || head.next_ref == null) {
            return head  // Список с одним или нулём элементов уже отсортирован
        }
    
        /* Разделение списка на две части. */
        local middle = _findMiddleNode(head)
        local nextToMiddle = middle.next_ref 
        middle.next_ref = null 
    
        /* Рекурсивная сортировка двух половин. */ 
        local left = _mergeSort(head)
        local right = _mergeSort(nextToMiddle) 
    
        /* Слияние отсортированных половин. */
        return _merge(left, right) 
    }
    
    
    function _findMiddleNode(head) {
        local slow = head
        local fast = head.next_ref
        while (fast != null && fast.next_ref != null) {
            slow = slow.next_ref
            fast = fast.next_ref.next_ref 
        }
        return slow 
    }
    
    
    function _merge(left, right) {
        local dummyHead = ListNode(null)
        local current = dummyHead
    
        while (left != null && right != null) {
            if (left.value <= right.value) {
                current.next_ref = left
                left = left.next_ref 
            } else {
                current.next_ref = right
                right = right.next_ref 
            } 
            current = current.next_ref
        } 
    
        /* Добавление оставшихся элементов. */
        current.next_ref = left != null ? left : right
    
        return dummyHead.next_ref 
    }


    /*
     * Removes all elements from the list.
    */
    function clear() {
        this.first_node.next_ref = null;
        this.last_node = this.first_node;
        this.length = 0;
    }

    /*
     * Joins the elements of the list into a string, separated by the specified delimiter.
     * 
     * @param {string} joinstr - The delimiter to use between elements. (optional, default="")
     * @returns {string} - The joined string.
    */
    function join(joinstr = "") {
        if(this.length == 0) return ""
        
        local string = ""
        foreach(elem in this) {
            string += elem + joinstr
        }
        return joinstr.len() != 0 ? string.slice(0, joinstr.len() * -1) : string
    }

    /*
    * Apply a function to each element and modify the list in-place.
    *
    * @param {Function} func - The function to apply.
    * @returns {List} - The List instance for chaining.
    */
    function apply(func) {
        foreach(idx, value in this) {
            this[idx] = func(value)
        }
        return this
    }

    /*
     * Extends the list by appending all elements from another iterable.
     * 
     * @param {iterable} other - The iterable to append elements from.
     * @returns {List} - The List instance for chaining.
    */
    function extend(other) {
        foreach(val in other) 
            this.append(val)
        return this
    }

    /*
     * Searches for a value or a matching element in the list.
     * 
     * @param {any|Function} match - The value to search for or a predicate function.
     * @returns {number|null} - The index of the match or null if not found.
    */
    function search(match) {
        if(typeof match == "function") {
            foreach(idx, val in this) {
                if(match(val))
                    return idx
            }
        }
        else {
            foreach(idx, val in this) {
                if(val == match)
                    return idx
            }
        }

        return null
    }

    // function binarySearch(value) {
    //     this.sort() // Сортировка списка перед поиском

    //     local low = 0
    //     local high = this.length - 1
    //     local mid

    //     while (low <= high) {
    //         mid = floor((low + high) / 2)
    //         if (this[mid] < value) {
    //             low = mid + 1
    //         } else if (this[mid] > value) {
    //             high = mid - 1 
    //         } else {
    //             return mid  // Элемент найден 
    //         }
    //     }

    //     return null  // Элемент не найден 
    // }

    /*
     * Creates a new list by applying a function to each element of this list.
     * 
     * @param {Function} func - The function to apply to each element.
     * @returns {List} - The new list with the mapped values.
    */
    function map(func) {
        local newList = List()
        foreach(value in this) {
            newList.append(func(value))
        }
        return newList
    }

    /*
     * Converts the list to an array.
     * 
     * @returns {array} - An array containing the elements of the list.
    */
    function toarray() {
        local array = arrayLib(array(this.length))
        foreach(idx, value in this) {
            array[idx] = value
        }
        return array
    }

    // Metamethods
    function _tostring() return format("List: [%s]", this.join(", "))
    function _typeof () return "List";
    function _get(idx) return this.getNode(idx).value;
    function _set(idx, val) return this.getNode(idx).value = val

    function _nexti(previdx) {
        if(this.len() == 0) return null
        if (previdx == null) return 0;
        return previdx < this.len() - 1 ? previdx + 1 : null;
    }

    function _cmp(other) { // lmao, why? :O
        local thisSum = 0;
        local otherSum = 0;
        foreach (val in this) { thisSum += val.value; }
        foreach (val in other) { otherSum += val.value; }

        if (thisSum > otherSum) {
            return 1;
        } else if (thisSum < otherSum) {
            return -1;
        } else {
            return 0; 
        }
    }
}