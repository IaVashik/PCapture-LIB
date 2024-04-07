::ListNode <- class {
    value = null;
    prev_ref = null;
    next_ref = null;

    constructor(value) {
        this.value = value;
    }

    function _tostring() {
        return this.value.tostring();
    }
}

::List <- class {
    lenght = 0;
    first_node = null;
    last_node = null;

    constructor(...) {
        this.first_node = ListNode(0);
        this.last_node = this.first_node;
        
        for(local i = 0; i< vargc; i++) {
            this.append(vargv[i])
        }
    }

    function fromArray(array) {
        local list = List()
        foreach(val in array) 
            list.append(val)
        return list
    }

    function len() {
        return this.lenght;
    }

    function append(value) {
        local next_node = ListNode(value);
        local current_node = this.last_node;

        current_node.next_ref = next_node;
        next_node.prev_ref = current_node;

        this.last_node = next_node;
        this.lenght++;
    }

    function insert(idx, value) {
        if(this.lenght == 0 || idx >= this.lenght) 
            return this.append(value)
    
        local node = this.getNode(idx)
        local newNode = ListNode(value)

        newNode.next_ref = node
        newNode.prev_ref = node.prev_ref
        
        node.prev_ref.next_ref = newNode 
        node.prev_ref = newNode

        this.lenght++
    }

    function getNode(idx) {
        if (idx >= this.lenght) {
            throw("the index '" + idx + "' does not exist!");
        }

        local node = this.first_node.next_ref;
        for (local i = 0; i < idx; i++) {
            node = node.next_ref;
        }
        return node;
    }

    function get(idx, defaultValue = null) {
        if (idx >= this.lenght)
            return defaultValue

        return this.getNode(idx).value
    }

    function remove(idx) {
        local node = this.getNode(idx);
        local next = node.next_ref;
        local prev = node.prev_ref;

        if (prev)
            prev.next_ref = next;
        if (next) 
            next.prev_ref = prev;

        this.lenght--;
    }

    function pop() {
        local current = this.last_node;
        this.last_node = current.prev_ref;
        this.last_node.next_ref = null;
        this.lenght--
        return current.value;
    }

    function top() {
        return this.last_node.value
    }

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

    function clear() {
        this.first_node.next_ref = null;
        this.last_node = this.first_node;
        this.lenght = 0;
    }

    function join(joinstr = "") {
        if(this.lenght == 0) return ""
        
        local string = ""
        foreach(elem in this) {
            string += elem + joinstr
        }
        return joinstr.len() != 0 ? string.slice(0, joinstr.len() * -1) : string
    }

    /*
    * Apply a function to each element.
    *
    * @param {Function} func - The function to apply.
    */
    function apply(func) {
        foreach(idx, value in this) {
            this[idx] = func(value)
        }
        return this
    }

    function extend(other) {
        foreach(val in other) 
            this.append(val)
        return this
    }

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

    function map(func) {
        local newList = List()
        foreach(value in this) {
            newList.append(func(value))
        }
        return newList
    }

    function toarray() {
        local array = arrayLib(array(this.lenght))
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
