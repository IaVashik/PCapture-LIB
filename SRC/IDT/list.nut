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

    function insert(value, idx) {
        local node = this.get(idx);
        local new_node = ListNode(value);

        new_node.next_ref = node.next_ref;
        new_node.prev_ref = node;

        node.next_ref.prev_ref = new_node;
        node.next_ref = new_node;
    }

    function get(idx) {
        if (idx >= this.lenght) {
            throw Error("the index '" + idx + "' does not exist!");
        }

        local node = this.first_node.next_ref;
        for (local i = 0; i < idx; i++) {
            node = node.next_ref;
        }
        return node;
    }

    function remove(idx) {
        local node = this.get(idx);
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
        return current;
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
    }

    function join(joinstr = "") {
        if(this.len() == 0) return ""
        
        local string = ""
        foreach(elem in this) {
            string += elem + joinstr
        }
        return joinstr.len() != 0 ? string.slice(0, joinstr.len() * -1) : string
    }

    /*
    * Convert the list to a string.
    *
    * @returns {string} - The string representation.
    */
    function _tostring() return format("List: [%s]", this.join(", "))

    /*
    * Get the type name.
    *
    * @returns {"arrayLib"}
    */
    function _typeof () return "List";

    /*
    * Get an element by index.
    *
    * @param {int} idx - The index.
    * @returns {any} - The element.
    */
    function _get(idx) return this.get(idx);

    /*
    * Set an element by index.
    *
    * @param {int} idx - The index.
    * @param {any} val - The new value.
    */
    function _set(idx, val) {
        return this.get(idx).value = val
    }

    function _nexti(previdx) {
        if(this.len() == 0) return null
        if (previdx == null) return 0;
        return previdx < this.len() - 1 ? previdx + 1 : null;
    }
}
