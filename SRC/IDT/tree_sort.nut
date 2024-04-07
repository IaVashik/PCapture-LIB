::treeNode <- class { //? TODO мб добавить кэширования высоты поддеревьев?
    value = null;
    l = null; // left child
    r = null; // right child
    h = 1; // height

    constructor(value) {
        this.value = value;
    }

    function _tostring() return format("treeNode(%i)", this.value);
    
    function _typeof() return "treeNode"
}

// --- AVL Tree Class ---
::AVLTree <- class {
    root = null;
    size = 0;
    inorderCache = null;

    constructor(...) {
        for (local i = 0; i < vargc; i++) {
            this.insert(vargv[i]);
        }
    }

    function fromArray(array) {
        local tree = AVLTree()
        foreach(val in array) 
            tree.insert(val)
        return tree
    }

    // --- Basic Methods ---

    function len() {
        return this.size;
    }

    function toArray() { // todo rename this met
        if(this.inorderCache == null) 
            this.inorderCache = this.inorderTraversal()

        return this.inorderCache
    }

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

    // Вставка узла в дерево
    function insert(key) {
        this.root = _insert(this.root, key);
        this.size++
        this.inorderCache = null;
    }

    // Рекурсивная функция вставки
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

    // Левый поворот
    function _lRotate(x) {
        local y = x.r;
        local T2 = y.l;

        y.l = x;
        x.r = T2;

        x.h = 1 + math.max(_getHeight(x.l), _getHeight(x.r));
        y.h = 1 + math.max(_getHeight(y.l), _getHeight(y.r));

        return y;
    }

    // Правый поворот
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

    // Получение высоты узла
    function _getHeight(node) {
        if (node == null) {
            return 0;
        }
        return node.h;
    }

    // Получение баланса узла
    function _balanceFactor(node) {
        if (node == null) {
            return 0;
        }
        return _getHeight(node.l) - _getHeight(node.r);
    }

    // --- Search Methods ---

    function search(value) {
        return this._search(this.root, value);
    }

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

    function remove(value) {
        this.root = this._remove(this.root, value);
        this.size--
        this.inorderCache = null
    }

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

    function GetMin() return this.min(this.root).value
    function GetMax() return this.max(this.root).value

    function min(node) { // todo mb fix that?
        local current = node;
        while (current && current.l) {
            current = current.l;
        }
        return current;
    }

    function max(node) { // todo mb fix that?
        local current = node;
        while (current && current.r) {
            current = current.r;
        }
        return current;
    }

    // --- Traversal Methods ---

    function inorderTraversal() {
        local result = arrayLib.new();
        this._inorder(this.root, result);
        return result;
    }

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