/*
 * A node in an AVL tree.
*/
 ::treeNode <- class {
    // The value stored in the node. 
    value = null;
    // The left child node. 
    l = null;
    // The right child node. 
    r = null; 
    // The height of the node. 
    h = 1; 

    /*
     * Constructor for a tree node.
     *
     * @param {any} value - The value to store in the node.
    */
    constructor(value) {
        this.value = value;
    }

    function _tostring() return format("treeNode(%i)", this.value);
    
    function _typeof() return "treeNode"
}

/*
 * An AVL tree implementation.
 *
 * An AVL tree is a self-balancing binary search tree where the heights of the two child subtrees of any node differ by at most one.
*/
::AVLTree <- class {
    // The root node of the tree. 
    root = null;
    // The number of nodes in the tree. 
    size = 0;
    // A cache of the inorder traversal of the tree. 
    inorderCache = null;

    /*
     * Constructor for an AVL tree.
     *
     * @param {...any} vargv - The initial values to add to the tree.
    */
    constructor(...) {
        for (local i = 0; i < vargc; i++) {
            this.insert(vargv[i]);
        }
    }

    /*
     * Creates a new AVL tree from an array.
     * 
     * @param {array} array - The array to create the tree from.
     * @returns {AVLTree} - The new tree containing the elements from the array.
    */
    function fromArray(array) {
        local tree = AVLTree()
        foreach(val in array) 
            tree.insert(val)
        return tree
    }

    // --- Basic Methods ---

    /*
     * Gets the number of nodes in the tree.
     *
     * @returns {number} - The number of nodes in the tree.
    */
    function len() {
        return this.size;
    }

    /*
     * Converts the tree to an array using inorder traversal.
     *
     * @returns {arrayLib} - An array containing the tree nodes in ascending order.
    */
    function toArray() { 
        if(this.inorderCache == null) 
            this.inorderCache = this.inorderTraversal()

        return this.inorderCache
    }

    /*
     * Converts the tree to a list using inorder traversal.
     *
     * @returns {List} - A list containing the tree nodes in ascending order.
    */
    function tolist() {
        local result = List();
        this._inorder(this.root, result);
        return result;
    }

    function _tostring() {
        local values = this.toArray()
        return format("AVLTree: {%s}", values.join(", "));
    }

    function _typeof() {
        return "AVLTree";
    }

    function _get(idx) {
        local values = this.toArray()
        if (idx < 0 || idx >= values.len()) {
            throw Error("the index '" + idx + "' does not exist");
        }
        return values[idx];
    }

    function _nexti(previdx) {
        local len = this.len();
        if (len == 0) return null;
        if (previdx == null) return 0;
        return previdx < len - 1 ? previdx + 1 : null;
    }

    // --- Insertion Methods --- 

    /*
     * Inserts a new node with the given key into the tree.
     *
     * @param {any} key - The key of the node to insert.
    */
    function insert(key) {
        this.root = this._insert(this.root, key);
        this.size++
        this.inorderCache = null;
    }

    /*
     * Recursive helper function for inserting a node into the tree.
     *
     * @param {treeNode|null} node - The current node being examined.
     * @param {any} key - The key of the node to insert.
     * @returns {treeNode} - The root node of the subtree after insertion.
    */
    function _insert(node, key) {
        if (node == null) {
            return treeNode(key);
        } else if (key < node.value) {
            node.l = _insert(node.l, key);
        } else {
            node.r = _insert(node.r, key);
        }
    
        // Update height
        node.h = 1 + math.max(_getHeight(node.l), _getHeight(node.r));

        // Update the balance factor and balance the tree
        local balanceFactor = _balanceFactor(node);

        // Left Left Case
        if (balanceFactor > 1 && key < node.l.value) {
            return _rRotate(node);
        }

        // Right Right Case
        if (balanceFactor < -1 && key > node.r.value) {
            return _lRotate(node);
        }

        // Left Right Case
        if (balanceFactor > 1 && key > node.l.value) {
            node.l = _lRotate(node.l);
            return _rRotate(node);
        }

        // Right Left Case
        if (balanceFactor < -1 && key < node.r.value) {
            node.r = _rRotate(node.r);
            return _lRotate(node);
        }

        return node;
    }

    // --- Balancing Methods ---

    /*
     * Performs a left rotation on the given node.
     *
     * @param {treeNode} x - The node to rotate.
     * @returns {treeNode} - The new root node of the subtree after rotation.
    */
    function _lRotate(x) {
        local y = x.r;
        local T2 = y.l;

        y.l = x;
        x.r = T2;

        x.h = 1 + math.max(_getHeight(x.l), _getHeight(x.r));
        y.h = 1 + math.max(_getHeight(y.l), _getHeight(y.r));

        return y;
    }

    /*
     * Performs a right rotation on the given node.
     *
     * @param {treeNode} x - The node to rotate.
     * @returns {treeNode} - The new root node of the subtree after rotation.
    */
    function _rRotate(x) {
        local y = x.l;
        local T3 = y.r;

        y.r = x;
        x.l = T3;

        x.h = 1 + math.max(_getHeight(x.l), _getHeight(x.r));
        y.h = 1 + math.max(_getHeight(y.l), _getHeight(y.r));

        return y;
    }

    // --- Height & Balance Methods ---

    /*
     * Gets the height of a node.
     *
     * @param {treeNode|null} node - The node to get the height of.
     * @returns {number} - The height of the node, or 0 if the node is null. 
    */
    function _getHeight(node) {
        if (node == null) {
            return 0;
        }
        return node.h;
    }

    /*
     * Gets the balance factor of a node.
     *
     * The balance factor is the difference in height between the left and right subtrees of the node.
     *
     * @param {treeNode|null} node - The node to get the balance factor of.
     * @returns {number} - The balance factor of the node.
    */
    function _balanceFactor(node) {
        if (node == null) {
            return 0;
        }
        return _getHeight(node.l) - _getHeight(node.r);
    }

    // --- Search Methods ---

    /*
     * Searches for a node with the given value in the tree.
     *
     * @param {any} value - The value to search for.
     * @returns {treeNode|null} - The node with the matching value, or null if not found.
    */
    function search(value) {
        return this._search(this.root, value);
    }

    /*
     * Recursive helper function for searching for a node in the tree.
     *
     * @param {treeNode|null} node - The current node being examined.
     * @param {any} value - The value to search for.
     * @returns {treeNode|null} - The node with the matching value, or null if not found. 
    */
    function _search(node, value) {
        if (!node || node.value == value) {
            return node;
        }

        if (value < node.value) {
            return this._search(node.l, value);
        } else {
            return this._search(node.r, value);
        }
    }

    // --- Removal Methods  ---

    /*
     * Removes the node with the given value from the tree.
     *
     * @param {any} value - The value of the node to remove.
    */
    function remove(value) {
        this.root = this._remove(this.root, value);
        this.size--
        this.inorderCache = null
    }

    /*
     * Recursive helper function for removing a node from the tree.
     *
     * @param {treeNode|null} node - The current node being examined.
     * @param {any} value - The value of the node to remove. 
     * @returns {treeNode|null} - The root node of the subtree after removal.
    */
    function _remove(node, value) {
        if (!node) {
            return null;
        }

        if (value < node.value) {
            node.l = this._remove(node.l, value);
        } else if (value > node.value) {
            node.r = this._remove(node.r, value);
        } else {
            // Node found, handle deletion based on number of children
            if (!node.l || !node.r) {
                local temp = node.l ? node.l : node.r;
                node = temp; // Replace node with its child
            } else {
                // Node has two children, find inorder successor
                local temp = this.min(node.r);
                node.value = temp.value;
                node.r = this._remove(node.r, temp.value);
            }
        }

        if (!node) {
            return node;
        }

        // Balance the tree
        node.h = 1 + math.max(_getHeight(node.l), _getHeight(node.r));

        local balanceFactor = _balanceFactor(node);

        // Balance the tree
        // Left Left Case
        if (balanceFactor > 1 && _balanceFactor(node.l) >= 0) {
            return _rRotate(node);
        }

        // Left Right Case
        if (balanceFactor > 1 && _balanceFactor(node.l) < 0) {
            node.l = _lRotate(node.l);
            return _rRotate(node);
        }

        // Right Right Case
        if (balanceFactor < -1 && _balanceFactor(node.r) <= 0) {
            return _lRotate(node);
        }

        // Right Left Case
        if (balanceFactor < -1 && _balanceFactor(node.r) > 0) {
            node.r = _rRotate(node.r);
            return _lRotate(node);
        }

        return node;
    }

    // --- Min/Max Methods ---

    /*
     * Gets the minimum value in the tree.
     *
     * @returns {any} - The minimum value in the tree.
    */
    function GetMin() return this.min(this.root).value
    
    /*
     * Gets the maximum value in the tree.
     *
     * @returns {any} - The maximum value in the tree.
    */
    function GetMax() return this.max(this.root).value

    function min(node) {
        local current = node;
        while (current && current.l) {
            current = current.l;
        }
        return current;
    }

    function max(node) {
        local current = node;
        while (current && current.r) {
            current = current.r;
        }
        return current;
    }

    // --- Traversal Methods ---

    /*
     * Performs an inorder traversal of the tree and returns the nodes in ascending order.
     *
     * @returns {arrayLib} - An array containing the tree nodes in ascending order.
    */
    function inorderTraversal() {
        local result = arrayLib.new();
        this._inorder(this.root, result);
        return result;
    }

    /*
     * Recursive helper function for inorder traversal.
     *
     * @param {treeNode|null} node - The current node being visited.
     * @param {arrayLib} result - The array to store the traversed nodes. 
    */
    function _inorder(node, result) {
        if (node) {
            this._inorder(node.l, result);
            result.append(node.value);
            this._inorder(node.r, result);
        }
    }

    // Print the tree
    function printTree() return this._print(this.root, "", true)

    function _print(currPtr, indent, last) {
        if(currPtr != null) {
            print(indent)
            if(last) {
                print("R----")
                indent += "     "
            }
            else {
                print("L----")
                indent += "|    "
            }
            printl(currPtr.value)
            this._print(currPtr.l, indent, false)
            this._print(currPtr.r, indent, true)
        }
    }
}