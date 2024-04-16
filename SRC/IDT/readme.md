# IDT Module (Improved Data Types)

The `IDT` module provides enhanced versions of standard VScripts data structures, including arrays, lists, and trees, with additional methods and functionality to improve efficiency and flexibility.

## [IDT/array.nut](array.nut)

This file defines the `arrayLib` class, which is an enhanced version of the standard VScripts array. It provides various methods for manipulating, searching, sorting, and converting arrays, making them more versatile and easier to work with.

### `arayLib(arrray)`

**Constructor**

Creates a new `arrayLib` object from an existing array.

**Parameters:**

* `array` (array, optional): The initial array to use for the `arrayLib` object (defaults to an empty array with a capacity of 4).

**Example:**

```js
local myArray = [1, 2, 3]
local myArrayLib = arrayLib(myArray) // Create an arrayLib object from the existing array
```

### `new(...)`

This static method creates a new `arrayLib` object from a variable number of arguments.

**Parameters:**

* `...` (any): A variable number of arguments to add to the array.

**Returns:**

* (arrayLib): The newly created `arrayLib` object.

**Example:**

```js
local myArrayLib = arrayLib.new(1, "hello", Vector(0, 0, 0)) // Create an arrayLib with three elements
```

### `append(value)`

This method appends a value to the end of the array. It automatically resizes the underlying array if necessary to accommodate the new element.

**Parameters:**

* `value` (any): The value to append to the array.

**Returns:**

* (arrayLib): The `arrayLib` object itself (for method chaining).

**Example:**

```js
myArrayLib.append(4) // Add the number 4 to the end of the array
```

### `apply(func)`

This method applies a function to each element of the array and modifies the array in-place. The function should take one argument (the element value) and return the new value for the element.

**Parameters:**

* `func` (function): The function to apply to each element.

**Returns:**

* (arrayLib): The `arrayLib` object itself (for method chaining).

**Example:**

```js
myArrayLib.apply(function(x) { return x * 2 }) // Multiply each element by 2
```

### `clear()`

This method removes all elements from the array and resets its length to 0.

**Returns:**

* (arrayLib): The `arrayLib` object itself (for method chaining).

**Example:**

```js
myArrayLib.clear() // Remove all elements from the array
```

### `extend(other)`

This method extends the array by appending all elements from another array or `arrayLib` object to the end of this array. It automatically resizes the underlying array if necessary.

**Parameters:**

* `other` (array or arrayLib): The array or `arrayLib` object to append elements from.

**Returns:**

* (arrayLib): The `arrayLib` object itself (for method chaining).

**Example:**

```js
local otherArray = array("a", "b", "c")
myArrayLib.extend(otherArray) // Append the elements of otherArray to myArrayLib
```

### `filter(func)`

This method creates a new `arrayLib` object containing only the elements that satisfy the predicate function.

**Parameters:**

* `func` (function): The predicate function that takes three arguments:
* `index` (number): The index of the current element.
* `value` (any): The value of the current element.
* `newArray` (arrayLib): The new array being created.
The function should return `true` if the element should be included in the new array, and `false` otherwise.

**Returns:**

* (arrayLib): A new `arrayLib` object containing the filtered elements.

**Example:**

```js
local evenNumbers = myArrayLib.filter(function(index, value) {
    return value % 2 == 0 // Check if the value is even
})
```

### `contains(value)`

This method checks if the array contains the specified value.

**Parameters:**

* `value` (any): The value to search for.

**Returns:**

* (boolean): `true` if the value is found in the array, `false` otherwise.

**Example:**

```js
if (myArrayLib.contains(5)) {
    // The array contains the value 5
}
```

### `search(value or func)`

This method searches for a value or a matching element in the array and returns its index.

**Parameters:**

* `value or func` (any or function):
* If a value, the method searches for the first occurrence of that value in the array.
* If a function, the method searches for the first element that satisfies the predicate function. The function should take one argument (the element value) and return `true` if it matches, `false` otherwise.

**Returns:**

* (number or null): The index of the first matching element, or `null` if no match is found.

**Example:**

```js
local index = myArrayLib.search(5) // Find the index of the value 5
local index2 = myArrayLib.search(function(x) { return x > 10 }) // Find the index of the first element greater than 10
```

### `insert(index, value)`

This method inserts a value into the array at the specified index, shifting all subsequent elements to the right.

**Parameters:**

* `index` (number): The index at which to insert the value.
* `value` (any): The value to insert.

**Returns:**

* (any): The inserted value.

**Example:**

```js
myArrayLib.insert(2, "new element") // Insert "new element" at index 2
```

### `len()`

This method returns the number of elements in the array.

**Returns:**

* (number): The number of elements in the array.

**Example:**

```js
local arrayLength = myArrayLib.len() // Get the length of the array
```

### `map(func)`

This method creates a new `arrayLib` object by applying a function to each element of this array.

**Parameters:**

* `func` (function): The function to apply to each element. The function should take one argument (the element value) and return the new value for the element.

**Returns:**

* (arrayLib): A new `arrayLib` object containing the mapped values.

**Example:**

```js
local squares = myArrayLib.map(function(x) { return x * x }) // Create an array of squares of the original elements
```

### `pop()`

This method removes and returns the last element of the array.

**Returns:**

* (any): The removed element.

**Example:**

```js
local lastElement = myArrayLib.pop() // Remove and return the last element of the array
```

### `push(value)`

This method appends a value to the end of the array. It is equivalent to `append(value)`.

**Parameters:**

* `value` (any): The value to append to the array.

**Example:**

```js
myArrayLib.push(5) // Add the value 5 to the end of the array
```

### `remove(index)`

This method removes the element at the specified index from the array, shifting all subsequent elements to the left.

**Parameters:**

* `index` (number): The index of the element to remove.

**Example:**

```js
myArrayLib.remove(1) // Remove the element at index 1
```

### `resize(size, fill)`

This method resizes the array to the specified size. If the new size is larger than the current size, the array is extended and the new elements are optionally filled with a specified value.

**Parameters:**

* `size` (number): The new size of the array.
* `fill` (any, optional): The value to fill new elements with (default is `null`).

**Example:**

```js
myArrayLib.resize(10, 0) // Resize the array to 10 elements, filling new elements with 0
```

### `reverse()`

This method reverses the order of elements in the array in-place.

**Returns:**

* (arrayLib): The `arrayLib` object itself (for method chaining).

**Example:**

```js
myArrayLib.reverse() // Reverse the order of elements in the array
```

### `slice(start, end)`

This method returns a new `arrayLib` object containing a portion of the array.

**Parameters:**

* `start` (number): The starting index of the slice (inclusive).
* `end` (number, optional): The ending index of the slice (exclusive, defaults to the end of the array).

**Returns:**

* (arrayLib): A new `arrayLib` object containing the sliced elements.

**Example:**

```js
local slicedArray = myArrayLib.slice(1, 3) // Get a new array containing elements from index 1 to 2 (exclusive)
```

### `sort(func)`

This method sorts the elements of the array in-place, optionally using a comparison function.

**Parameters:**

* `func` (function, optional): A comparison function that takes two arguments (the two elements to compare) and returns:
* A negative value if the first element is less than the second element.
* Zero if the elements are equal.
* A positive value if the first element is greater than the second element.
If no comparison function is provided, the elements are sorted according to their default comparison behavior.

**Returns:**

* (arrayLib): The `arrayLib` object itself (for method chaining).

**Example:**

```js
myArrayLib.sort() // Sort the array in ascending order (default behavior)
myArrayLib.sort(function(a, b) { return b - a }) // Sort the array in descending order
```

### `top()`

This method returns the last element of the array.

**Returns:**

* (any): The last element of the array.

**Example:**

```js
local lastElement = myArrayLib.top() // Get the last element of the array
```

### `join(separator)`

This method joins the elements of the array into a string, separated by the specified separator.

**Parameters:**

* `separator` (string, optional): The separator to use between elements (default is an empty string).

**Returns:**

* (string): The joined string.

**Example:**

```js
local joinedString = myArrayLib.join(", ") // Join the array elements into a string separated by commas and spaces
```

### `get(index, default)`

This method returns the element at the specified index in the array. If the index is out of bounds, it returns a default value.

**Parameters:**

* `index` (number): The index of the element to retrieve.
* `default` (any, optional): The default value to return if the index is out of bounds (default is `null`).

**Returns:**

* (any): The element at the specified index, or the default value if the index is out of bounds.

**Example:**

```js
local element = myArrayLib.get(2) // Get the element at index 2
local element2 = myArrayLib.get(10, 0) // Get the element at index 10, or 0 if the index is out of bounds
```

### `totable(recreate)`

This method converts the array to a table, using the array elements as keys and setting the values to `null`.

**Parameters:**

* `recreate` (boolean, optional): Whether to recreate the table even if it already exists (default is `false`).

**Returns:**

* (table): The table representation of the array.

**Example:**

```js
local tableRepr = myArrayLib.totable() // Convert the array to a table
```

### `tolist()`

This method converts the array to a `List` object.

**Returns:**

* (List): The `List` object containing the elements of the array.

**Example:**

```js
local listRepr = myArrayLib.tolist() // Convert the array to a list
```

## [IDT/list.nut](list.nut)

This file defines the `List` class, which represents a doubly linked list and provides methods for adding and removing elements, accessing elements by index, reversing the list, and converting the list to an array. **A doubly linked list is a linear data structure where each element (node) contains a value and references to the previous and next nodes in the list.**

### `List(...)`
**Constructor** - Creates a new `List` object with optional initial elements.

**Parameters:**

* `...` (any): The initial elements to add to the list.

**Example:**

```js
local myList = List(1, 2, 3)
```

### `fromArray(array)`
Creates a new `List` object from an existing array.

**Parameters:**

* `array` (array): The array to create the list from.

**Returns:**

* (List): The new list containing the elements from the array.

**Example:**

```js
local myArray = [1, 2, 3]
local myList = List.fromArray(myArray)
```

### `len()`
Gets the length of the list, which is the number of elements it contains.

**Returns:**

* (number): The number of elements in the list.

**Example:**

```js
local listLength = myList.len()
```

### `append(value)`
Appends a value to the end of the list.

**Parameters:**

* `value` (any): The value to append.

**Example:**

```js
myList.append(4)
```

### `insert(index, value)`
Inserts a value at a specific index in the list.

**Parameters:**

* `index` (number): The index to insert the value at.
* `value` (any): The value to insert.

**Example:**

```js
myList.insert(2, "inserted")
```

### `getNode(index)`
Gets the node at a specific index in the list. Throws an error if the index is out of bounds.

**Parameters:**

* `index` (number): The index of the node to retrieve.

**Returns:**

* (ListNode): The node at the specified index.

**Example:**

```js
local node = myList.getNode(1)
```

### `get(index, defaultValue)`
Gets the value at a specific index in the list, or a default value if the index is out of bounds.

**Parameters:**

* `index` (number): The index of the value to retrieve.
* `defaultValue` (any, optional): The value to return if the index is out of bounds.

**Returns:**

* (any): The value at the specified index or the default value if the index is out of bounds.

**Example:**

```js
local value = myList.get(2)
```

### `remove(index)`
Removes the node at a specific index from the list.

**Parameters:**

* `index` (number): The index of the node to remove.

**Example:**

```js
myList.remove(1)
```

### `pop()`
Removes the last element from the list and returns its value.

**Returns:**

* (any): The value of the removed element.

**Example:**

```js
local lastValue = myList.pop()
```

### `top()`
Gets the value of the last element in the list.

**Returns:**

* (any): The value of the last element.

**Example:**

```js
local lastValue = myList.top()
```

### `reverse()`
Reverses the order of the elements in the list in-place.

**Example:**

```js
myList.reverse()
```

### `clear()`
Removes all elements from the list.

**Example:**

```js
myList.clear()
```

### `join(separator)`
Joins the elements of the list into a string, separated by the specified delimiter.

**Parameters:**

* `separator` (string, optional): The delimiter to use between elements (default is an empty string).

**Returns:**

* (string): The joined string.

**Example:**

```js
local joinedString = myList.join(", ")
```

### `apply(func)`
Applies a function to each element of the list and modifies the list in-place.

**Parameters:**

* `func` (function): The function to apply to each element. The function should take one argument (the element value) and return the modified value.

**Returns:**

* (List): The `List` object itself for method chaining.

**Example:**

```js
myList.apply(function(x) {
    return x * 2 // Double each element
})
```

### `extend(other)`
Extends the list by appending all elements from another iterable.

**Parameters:**

* `other` (iterable): The iterable to append elements from.

**Returns:**

* (List): The `List` object itself for method chaining.

**Example:**

```js
local otherList = List(4, 5, 6)
myList.extend(otherList)
```

### `search(value or func)`
Searches for a value or a matching element in the list.

**Parameters:**

* `value or func` (any or function): If a value, searches for the first occurrence of that value in the list. If a function, searches for the first element that satisfies the predicate function. The function should take one argument (the element value) and return `true` if the element is a match, `false` otherwise.

**Returns:**

* (number or null): The index of the first matching element, or `null` if no match is found.

**Example:**

```js
local index = myList.search(2) // Find the index of the value 2
```

### `map(func)`
Creates a new list by applying a function to each element of this list.

**Parameters:**

* `func` (function): The function to apply to each element. The function should take one argument (the element value) and return the new value for the element.

**Returns:**

* (List): The new list with the mapped values.

**Example:**

```js
local squaredValues = myList.map(function(x) {
    return x * x // Square each element
})
```

### `toarray()`
Converts the list to an array.

**Returns:**

* (array): An array containing the elements of the list.

**Example:**

```js
local myArray = myList.toarray()
```

## [IDT/tree_sort.nut](tree_sort.nut)

This file defines the `AVLTree` class, which represents a self-balancing binary search tree (AVL tree). It provides methods for inserting and removing nodes, searching for nodes, and traversing the tree in different orders.

### `AVLTree(...)`
**Constructor** - Creates a new `AVLTree` object with optional initial elements.

**Parameters:**

* `...` (any): The initial elements to add to the tree.

**Example:**

```js
local myTree = AVLTree(5, 2, 8, 1, 3)
```

### `fromArray(array)`
Creates a new `AVLTree` object from an existing array.

**Parameters:**

* `array` (array): The array to create the tree from.

**Returns:**

* (AVLTree): The new tree containing the elements from the array.

**Example:**

```js
local myArray = [5, 2, 8, 1, 3]
local myTree = AVLTree.fromArray(myArray)
```

### `len()`
Gets the number of nodes in the tree.

**Returns:**

* (number): The number of nodes in the tree.

**Example:**

```js
local treeSize = myTree.len()
```

### `toArray()`
Converts the tree to an array using inorder traversal (ascending order).

**Returns:**

* (arrayLib): An array containing the tree nodes in ascending order.

**Example:**

```js
local sortedArray = myTree.toArray()
```

### `tolist()`
Converts the tree to a list using inorder traversal (ascending order).

**Returns:**

* (List): A list containing the tree nodes in ascending order.

**Example:**

```js
local sortedList = myTree.tolist()
```

### `insert(key)`
Inserts a new node with the given key into the tree, maintaining the AVL tree's balance property.

**Parameters:**

* `key` (any): The key of the node to insert.

**Example:**

```js
myTree.insert(6) // Insert a new node with the key 6
```

### `search(value)`
Searches for a node with the given value in the tree and returns the node if found.

**Parameters:**

* `value` (any): The value to search for.

**Returns:**

* (treeNode or null): The node with the matching value, or `null` if not found.

**Example:**

```js
local node = myTree.search(3)
if (node) {
    // ...
}
```

### `remove(value)`
Removes the node with the given value from the tree, maintaining the AVL tree's balance property.

**Parameters:**

* `value` (any): The value of the node to remove.

**Example:**

```js
myTree.remove(2) // Remove the node with the value 2
```

### `GetMin()`
Returns the minimum value in the tree, which is the value of the leftmost node.

**Returns:**

* (any): The minimum value in the tree.

**Example:**

```js
local minValue = myTree.GetMin()
```

### `GetMax()`
Returns the maximum value in the tree, which is the value of the rightmost node.

**Returns:**

* (any): The maximum value in the tree.

**Example:**

```js
local maxValue = myTree.GetMax()
```

### `inorderTraversal()`
Performs an inorder traversal of the tree and returns an array of nodes in ascending order.

**Returns:**

* (arrayLib): An array containing the tree nodes in ascending order.

**Example:**

```js
local sortedArray = myTree.inorderTraversal()
```

### `printTree()`
Prints a visual representation of the tree structure to the console, showing the nodes and their relationships.

**Example:**

```js
myTree.printTree()
```


### Comparison with `array`, `list` and `AVLTree`

* **`array`**: Arrays provide efficient random access to elements by index, making them suitable for situations where you need to frequently access elements by their position. However, inserting or removing elements at arbitrary positions in an array can be inefficient, as it may require shifting other elements to maintain the contiguous order.
* **`List`**: Linked lists excel at insertion and deletion operations, especially at the beginning or end of the list. This is because adding or removing a node only requires updating the references of the neighboring nodes. However, accessing elements by index in a linked list is less efficient than in an array, as it requires traversing the list from the beginning until the desired index is reached.
* **`AVLTree`**: AVL trees are self-balancing binary search trees that provide efficient search, insertion, and deletion operations while maintaining a sorted order. They are ideal for situations where you need to maintain a sorted collection of elements and perform frequent searches. However, AVL trees have a more complex structure than arrays or linked lists, which can make them slightly less efficient for simple insertion or deletion operations, especially at arbitrary positions.

### Choosing the Right Data Structure

The choice between `array`, `List`, and `AVLTree` depends on the specific requirements of your application. Consider the following factors:

* **Frequency of access by index**: If you need to frequently access elements by their position, an `array` is a good choice.
* **Frequency of insertions and deletions**: If you perform many insertions and deletions, especially at the beginning or end of the collection, a `List` might be more efficient.
* **Need for sorting**: If you need to maintain a sorted collection and perform frequent searches, an `AVLTree` is the best option.
* **Complexity**: If you need a simple data structure with minimal overhead, an `array` or `List` might be preferable.


## [IDT/entity_creator.nut](entity_creator.nut)

This file defines the `entLib` class, which provides helper functions for creating and finding entities.

### `CreateByClassname(classname, keyvalues)`
Creates an entity of the specified classname with the provided key-value pairs and returns it as a `pcapEntity` object.

**Parameters:**

* `classname` (string): The classname of the entity to create.
* `keyvalues` (table, optional): A table containing key-value pairs to set for the entity (default is an empty table).

**Returns:**

* (pcapEntity): The created entity as a `pcapEntity` object.

**Example:**

```js
local myEntity = entLib.CreateByClassname("prop_physics", {
    model = "models/my_model.mdl",
    health = 100
})
```

### `CreateProp(classname, origin, modelname, activity, keyvalues)`
Creates a prop entity with the specified classname, origin, model name, activity, and key-value pairs.

**Parameters:**

* `classname` (string): The classname of the prop entity to create (e.g., "prop_physics").
* `origin` (Vector): The initial position of the prop.
* `modelname` (string): The model name of the prop (e.g., "models/my_prop.mdl").
* `activity` (number, optional): The initial activity of the prop (default is 1).
* `keyvalues` (table, optional): A table containing additional key-value pairs to set for the prop (default is an empty table).

**Returns:**

* (pcapEntity): The created prop entity as a `pcapEntity` object.

**Example:**

```js
local myProp = entLib.CreateProp("prop_physics", Vector(0, 0, 100), "models/my_prop.mdl")
```

### `FromEntity(CBaseEntity)`
Wraps a `CBaseEntity` object in a `pcapEntity` object.

**Parameters:**

* `CBaseEntity` (CBaseEntity): The `CBaseEntity` object to wrap.

**Returns:**

* (pcapEntity): The wrapped entity as a `pcapEntity` object.

**Example:**

```js
local myPcapEntity = entLib.FromEntity(myEntity)
```

### `FindByClassname(classname, start_ent)`
Finds an entity with the specified classname.

**Parameters:**

* `classname` (string): The classname of the entity to find.
* `start_ent` (CBaseEntity or pcapEntity, optional): The entity to start the search from. If not specified, the search starts from the beginning of the entity list.

**Returns:**

* (pcapEntity or null): The found entity as a `pcapEntity` object, or `null` if no entity is found.

**Example:**

```js
local physicsProp = entLib.FindByClassname("prop_physics") // Find the first prop_physics entity
```

### `FindByClassnameWithin(classname, origin, radius, start_ent)`
Finds an entity with the specified classname within a given radius from the origin point.

**Parameters:**

* `classname` (string): The classname of the entity to find.
* `origin` (Vector): The origin point of the search sphere.
* `radius` (number): The radius of the search sphere.
* `start_ent` (CBaseEntity or pcapEntity, optional): The entity to start the search from. If not specified, the search starts from the beginning of the entity list.

**Returns:**

* (pcapEntity or null): The found entity as a `pcapEntity` object, or `null` if no entity is found.

**Example:**

```js
local nearbyButton = entLib.FindByClassnameWithin("prop_button", myPosition, 50)
// Find a prop_button entity within 50 units of myPosition
```

### `FindByName(targetname, start_ent)`
Finds an entity with the specified targetname.

**Parameters:**

* `targetname` (string): The targetname of the entity to find.
* `start_ent` (CBaseEntity or pcapEntity, optional): The entity to start the search from. If not specified, the search starts from the beginning of the entity list.

**Returns:**

* (pcapEntity or null): The found entity as a `pcapEntity` object, or `null` if no entity is found.

**Example:**

```js
local triggerEntity = entLib.FindByName("my_trigger")
```

### `FindByNameWithin(targetname, origin, radius, start_ent)`
Finds an entity with the specified targetname within a given radius from the origin point.

**Parameters:**

* `targetname` (string): The targetname of the entity to find.
* `origin` (Vector): The origin point of the search sphere.
* `radius` (number): The radius of the search sphere.
* `start_ent` (CBaseEntity or pcapEntity, optional): The entity to start the search from. If not specified, the search starts from the beginning of the entity list.

**Returns:**

* (pcapEntity or null): The found entity as a `pcapEntity` object, or `null` if no entity is found.

**Example:**

```js
local nearbyDoor = entLib.FindByNameWithin("exit_door", myPosition, 100)
// Find an entity named "exit_door" within 100 units of myPosition
```

### `FindByModel(model, start_ent)`
Finds an entity with the specified model.

**Parameters:**

* `model` (string): The model name of the entity to find.
* `start_ent` (CBaseEntity or pcapEntity, optional): The entity to start the search from. If not specified, the search starts from the beginning of the entity list.

**Returns:**

* (pcapEntity or null): The found entity as a `pcapEntity` object, or `null` if no entity is found.

**Example:**

```js
local crateEntity = entLib.FindByModel("models/props_junk/wood_crate001a.mdl")
```

### `FindByModelWithin(model, origin, radius, start_ent)`
Finds an entity with the specified model within a given radius from the origin point.

**Parameters:**

* `model` (string): The model name of the entity to find.
* `origin` (Vector): The origin point of the search sphere.
* `radius` (number): The radius of the search sphere.
* `start_ent` (CBaseEntity or pcapEntity, optional): The entity to start the search from. If not specified, the search starts from the beginning of the entity list.

**Returns:**

* (pcapEntity or null): The found entity as a `pcapEntity` object, or `null` if no entity is found.

**Example:**

```js
local nearbyCrate = entLib.FindByModelWithin("models/props_junk/wood_crate001a.mdl", myPosition, 50)
// Find a crate entity within 50 units of myPosition
```

### `FindInSphere(origin, radius, start_ent)`
Finds entities within a sphere defined by the origin and radius.

**Parameters:**

* `origin` (Vector): The origin point of the search sphere.
* `radius` (number): The radius of the search sphere.
* `start_ent` (CBaseEntity or pcapEntity, optional): The entity to start the search from. If not specified, the search starts from the beginning of the entity list.

**Returns:**

* (pcapEntity or null): The found entity as a `pcapEntity` object, or `null` if no entity is found.

**Example:**

```js
local entitiesInSphere = entLib.FindInSphere(myPosition, 100)
// Find entities within 100 units of myPosition
```

## [IDT/entity.nut](entity.nut)

This file defines the `pcapEntity` class, which extends the functionality of `CBaseEntity` with additional methods for manipulating entity properties, setting outputs, managing user data, and retrieving information about the entity's bounding box and other attributes. **Use entLib to create it**

### `SetAngles(x, y, z)`
Sets the angles (pitch, yaw, roll) of the entity, ensuring that the angles are within the range of 0 to 359 degrees.

**Parameters:**

* `x` (number): The pitch angle in degrees.
* `y` (number): The yaw angle in degrees.
* `z` (number): The roll angle in degrees.

**Example:**

```js
myPcapEntity.SetAngles(45, 90, 0) // Set the entity's angles
```

### `SetAbsAngles(angles)`
Sets the absolute rotation angles of the entity using a Vector.

**Parameters:**

* `angles` (Vector): The angle vector representing the desired rotation.

**Example:**

```js
myPcapEntity.SetAbsAngles(Vector(0, 180, 0)) // Set the entity to face the opposite direction
```

### `Destroy()`
Destroys the entity, removing it from the game world.

**Example:**

```js
myPcapEntity.Destroy() // Destroy the entity
```

### `Kill(fireDelay)`
Kills the entity, triggering its "kill" input with an optional delay.

**Parameters:**

* `fireDelay` (number, optional): The delay in seconds before killing the entity (default is 0).

**Example:**

```js
myPcapEntity.Kill(2) // Kill the entity after 2 seconds
```

### `Dissolve()`
Dissolves the entity using an `env_entity_dissolver` entity. This creates a visual effect of the entity dissolving away.

**Example:**

```js
myPcapEntity.Dissolve() // Dissolve the entity
```

### `IsValid()`
Checks if the entity is valid, meaning that it exists and has not been destroyed or dissolved.

**Returns:**

* (boolean): True if the entity is valid, false otherwise.

**Example:**

```js
if (myPcapEntity.IsValid()) {
    // The entity is valid and can be used
}
```

### `IsPlayer()`
Checks if the entity is the player entity.

**Returns:**

* (boolean): True if the entity is the player, false otherwise.

**Example:**

```js
if (myPcapEntity.IsPlayer()) {
    // The entity is the player
}
```

### `EyePosition()`
Gets the eye position of the player entity as a Vector. This is the position from which the player's view is rendered.

**Returns:**

* (Vector): The eye position of the player, or `null` if the entity is not the player.

**Example:**

```js
local eyePos = GetPlayerEx().EyePosition()
```

### `EyeAngles()`
Gets the eye angles of the player entity as a Vector representing the pitch, yaw, and roll of the player's view.

**Returns:**

* (Vector): The eye angles of the player, or `null` if the entity is not the player.

**Example:**

```js
local eyeAngles = GetPlayerEx().EyeAngles()
```

### `EyeForwardVector()`
Gets the forward vector from the player entity's eye position. This represents the direction in which the player is looking.

**Returns:**

* (Vector): The forward vector from the player's eye position, or `null` if the entity is not the player.

**Example:**

```js
local eyeForward = GetPlayerEx().EyeForwardVector()
```

### `SetKeyValue(key, value)`
Sets a key-value pair for the entity. This modifies the entity's properties and also stores the value as user data for later retrieval.

**Parameters:**

* `key` (string): The key of the key-value pair.
* `value` (any): The value to set for the key.

**Example:**

```js
myPcapEntity.SetKeyValue("health", 100) // Set the entity's health to 100
```

### `addOutput(outputName, target, input, param, delay, fires)`
Sets an output for the entity, connecting it to a target entity and input.

**Parameters:**

* `outputName` (string): The name of the output to set.
* `target` (string, CBaseEntity, or pcapEntity): The target entity to connect the output to (can be a targetname or an entity object).
* `input` (string): The name of the input on the target entity to connect to.
* `param` (string, optional): An optional parameter override for the input.
* `delay` (number, optional): An optional delay in seconds before triggering the input.
* `fires` (number, optional): The number of times the output should fire (default is -1 for unlimited fires).

**Example:**

```js
myPcapEntity.addOutput("OnTrigger", "targetEntity", "Kill", "", 0.5, 1)
// Connect the "OnTrigger" output to the "Kill" input of "targetEntity" with a 0.5-second delay and fire only once
```

### `ConnectOutputEx(outputName, script, delay, fires)`
Connects an output to a script function or string with optional delay and trigger count.

**Parameters:**

* `outputName` (string or function): The name of the output to connect.
* `script` (string): The VScripts code or function name to execute when the output is triggered.
* `delay` (number, optional): The delay in seconds before executing the script.
* `fires` (number, optional): The number of times the output should fire (default is -1 for unlimited fires).

**Example:**

```js
myPcapEntity.ConnectOutputEx("OnTrigger", function() {
    printl("Output triggered!")
})
```

### `EmitSoundEx(soundName, timeDelay, eventName)`
Plays a sound with an optional delay and event name for scheduling.

**Parameters:**

* `soundName` (string): The name of the sound to play.
* `timeDelay` (number, optional): The delay in seconds before playing the sound (default is 0).
* `eventName` (any, optional): The name of the event used for scheduling (default is the entity itself).

**Example:**

```js
myPcapEntity.EmitSoundEx("my_sound.wav", 1) // Play the sound after a 1-second delay
```

### `SetName(name)`
Sets the targetname of the entity.

**Parameters:**

* `name` (string): The targetname to set.

**Example:**

```js
myPcapEntity.SetName("my_entity") // Set the entity's targetname
```

### `SetUniqueName(prefix)`
Sets a unique targetname for the entity using the provided prefix and a generated unique identifier.

**Parameters:**

* `prefix` (string, optional): The prefix to use for the unique targetname (default is "u").

**Example:**

```js
myPcapEntity.SetUniqueName("my_entity") // Set a unique targetname starting with "my_entity_"
```

### `SetParent(parentEnt, fireDelay)`
Sets the parent entity for the entity, establishing a parent-child relationship.

**Parameters:**

* `parentEnt` (string, CBaseEntity, or pcapEntity): The parent entity to set (can be a targetname or an entity object).
* `fireDelay` (number, optional): The delay in seconds before setting the parent (default is 0).

**Example:**

```js
local parentEntity = entLib.FindByClassname("prop_static")
myPcapEntity.SetParent(parentEntity) // Set the parent entity
```

### `GetParent()`
Gets the parent entity of the entity, if set.

**Returns:**

* (pcapEntity or null): The parent entity as a `pcapEntity` object, or `null` if no parent is set.

**Example:**

```js
local parent = myPcapEntity.GetParent()
if (parent) {
    // ... do something with the parent entity
}
```

### `SetCollision(solidType, fireDelay)`
Sets the collision type of the entity, controlling how it interacts with other entities in the game world.

**Parameters:**

* `solidType` (number): The collision type to set (see the Source SDK documentation for valid values).
* `fireDelay` (number, optional): The delay in seconds before setting the collision type (default is 0).

**Example:**

```js
myPcapEntity.SetCollision(SOLID_NONE) // Make the entity non-solid (pass through other entities)
```

### `SetCollisionGroup(collisionGroup)`
Sets the collision group of the entity, determining which other entities it can collide with.

**Parameters:**

* `collisionGroup` (number): The collision group to set (see the Source SDK documentation for valid values).

**Example:**

```js
myPcapEntity.SetCollisionGroup(COLLISION_GROUP_PLAYER) // Set the collision group to the player group
```

### `SetAnimation(animationName, fireDelay)`
Starts playing the specified animation on the entity.

**Parameters:**

* `animationName` (string): The name of the animation to play.
* `fireDelay` (number, optional): The delay in seconds before starting the animation (default is 0).

**Example:**

```js
myPcapEntity.SetAnimation("run") // Start playing the "run" animation
```

### `SetAlpha(opacity, fireDelay)`
Sets the alpha (opacity) of the entity, controlling how transparent it appears.

**Parameters:**

* `opacity` (number): The alpha value between 0 (fully transparent) and 255 (fully opaque).
* `fireDelay` (number, optional): The delay in seconds before setting the alpha (default is 0).

**Example:**

```js
myPcapEntity.SetAlpha(128) // Set the entity to be semi-transparent
```

### `SetColor(colorValue, fireDelay)`
Sets the color of the entity.

**Parameters:**

* `colorValue` (string or Vector): The color value as a string (e.g., "255 0 0" for red) or a Vector with components (r, g, b).
* `fireDelay` (number, optional): The delay in seconds before setting the color (default is 0).

**Example:**

```js
myPcapEntity.SetColor("0 255 0") // Set the entity to green
```

### `SetSkin(skin, fireDelay)`
Sets the skin of the entity, if the entity has multiple skins available.

**Parameters:**

* `skin` (number): The index of the skin to set.
* `fireDelay` (number, optional): The delay in seconds before setting the skin (default is 0).

**Example:**

```js
myPcapEntity.SetSkin(2) // Set the entity's skin to the third available skin
```

### `SetDrawEnabled(isEnabled, fireDelay)`
Enables or disables rendering of the entity, controlling whether it is visible in the game world.

**Parameters:**

* `isEnabled` (boolean): True to enable rendering (make the entity visible), false to disable rendering (make the entity invisible).
* `fireDelay` (number, optional): The delay in seconds before setting the draw state (default is 0).

**Example:**

```js
myPcapEntity.SetDrawEnabled(false) // Make the entity invisible
```

### `IsDrawEnabled()`
Checks if the entity is set to be drawn (visible).

**Returns:**

* (boolean): True if the entity is set to be drawn, false otherwise.

**Example:**

```js
if (myPcapEntity.IsDrawEnabled()) {
    // The entity is visible
}
```

### `SetTraceIgnore(isEnabled)`
Sets whether the entity should be ignored during traces. This can be used to prevent the entity from blocking traces or being detected by them.

**Parameters:**

* `isEnabled` (boolean): True to ignore the entity during traces, false otherwise.

**Example:**

```js
myPcapEntity.SetTraceIgnore(true) // Ignore the entity during traces
```

### `SetSpawnflags(flag)`
Sets the spawnflags of the entity, which can affect its behavior and properties.

**Parameters:**

* `flag` (number): The spawnflags value to set.

**Example:**

```js
myPcapEntity.SetSpawnflags(128) // Set the NPC_GAG spawnflag for an NPC entity
```

### `SetModelScale(scaleValue, fireDelay)`
Sets the scale of the entity's model, making it larger or smaller.

**Parameters:**

* `scaleValue` (number): The scale value to set.
* `fireDelay` (number, optional): The delay in seconds before setting the model scale (default is 0).

**Example:**

```js
myPcapEntity.SetModelScale(2) // Double the size of the entity's model
```

### `GetModelScale()`
Gets the current model scale of the entity.

**Returns:**

* (number): The current model scale value.

**Example:**

```js
local currentScale = myPcapEntity.GetModelScale()
```

### `SetCenter(vector)`
Sets the center of the entity's bounding box. This effectively moves the entity while maintaining its orientation.

**Parameters:**

* `vector` (Vector): The new center position for the entity's bounding box.

**Example:**

```js
myPcapEntity.SetCenter(Vector(10, 20, 30)) // Set the center of the entity's bounding box
```

### `SetBBox(minBounds, maxBounds)`
Sets the bounding box of the entity using vectors or string representations of vectors.

**Parameters:**

* `minBounds` (Vector or string): The minimum bounds of the bounding box as a Vector or a string representation (e.g., "-5 -5 -5").
* `maxBounds` (Vector or string): The maximum bounds of the bounding box as a Vector or a string representation (e.g., "5 5 5").

**Example:**

```js
myPcapEntity.SetBBox(Vector(-10, -10, -10), Vector(10, 10, 10)) // Set a bounding box of 20x20x20 units
```

### `SetContext(name, value, fireDelay)`
Sets a context value for the entity, which can be used for storing additional information or state associated with the entity.

**Parameters:**

* `name` (string): The name of the context value.
* `value` (any): The value to set for the context.
* `fireDelay` (number, optional): The delay in seconds before setting the context value (default is 0).

**Example:**

```js
myPcapEntity.SetContext("activated", true) // Set a context value indicating that the entity has been activated
```

### `SetUserData(name, value)`
Stores an arbitrary value associated with the entity using a name. This is a general-purpose mechanism for attaching custom data to entities.

**Parameters:**

* `name` (string): The name of the user data value.
* `value` (any): The value to store.

**Example:**

```js
myPcapEntity.SetUserData("myData", {count = 10, message = "Hello"})
```

### `GetUserData(name)`
Retrieves a stored user data value by name.

**Parameters:**

* `name` (string): The name of the user data value to retrieve.

**Returns:**

* (any or null): The stored value, or `null` if no value is found with the given name.

**Example:**

```js
local myData = myPcapEntity.GetUserData("myData")
macros.PrintIter(myData)
```

### `GetBBox()`
Returns the bounding box of the entity as a table with two Vector properties: `min` and `max`, representing the minimum and maximum extents of the box.

**Returns:**

* (table): A table with `min` and `max` Vector properties representing the bounding box.

**Example:**

```js
local bbox = myPcapEntity.GetBBox()
printl("Bounding box min:", bbox.min)
printl("Bounding box max:", bbox.max)
```

### `GetAABB()`
Returns the axis-aligned bounding box (AABB) of the entity, which is a box that is aligned with the world axes and tightly encloses the entity.

**Returns:**

* (table): A table with three Vector properties: `min`, `max`, and `center`, representing the minimum and maximum extents of the AABB, as well as its center point.

**Example:**

```js
local aabb = myPcapEntity.GetAABB()
printl("AABB min:", aabb.min)
printl("AABB max:", aabb.max)
printl("AABB center:", aabb.center)
```

### `GetIndex()`
Returns the index of the entity, which is a unique identifier for the entity within the game.

**Returns:**

* (number): The index of the entity.

**Example:**

```js
local entityIndex = myPcapEntity.GetIndex()
```

### `GetKeyValue(key)`
Returns the value of a key-value pair for the entity, if it was set using the `SetKeyValue` method.

**Parameters:**

* `key` (string): The key of the key-value pair to retrieve.

**Returns:**

* (any or null): The value associated with the key, or `null` if the key is not found.

**Example:**

```js
local healthValue = myPcapEntity.GetKeyValue("health")
```

### `GetSpawnflags()`
Returns the spawnflags of the entity, if they were set using the `SetSpawnflags` method.

**Returns:**

* (number or null): The spawnflags value, or `null` if the spawnflags were not set using `SetSpawnflags`.

**Example:**

```js
local spawnflags = myPcapEntity.GetSpawnflags()
```

### `GetAlpha()`
Returns the alpha (opacity) value of the entity, if it was set using the `SetAlpha` method.

**Returns:**

* (number or null): The alpha value, or `null` if the alpha was not set using `SetAlpha`.

**Example:**

```js
local alpha = myPcapEntity.GetAlpha()
```

### `GetColor()`
Returns the color of the entity as a string, if it was set using the `SetColor` method.

**Returns:**

* (string or null): The color string, or `null` if the color was not set using `SetColor`.

**Example:**

```js
local color = myPcapEntity.GetColor()
```

### `GetSkin()`
Returns the skin index of the entity, if it was set using the `SetSkin` method.

**Returns:**

* (number or null): The skin index, or `null` if the skin was not set using `SetSkin`.

**Example:**

```js
local skin = myPcapEntity.GetSkin()
```

### `GetNamePrefix()`
Returns the prefix of the entity's name, if the name contains a "-" separator.

**Returns:**

* (string): The prefix of the entity name, or the entire name if no "-" separator is found.

**Example:**

```js
local prefix = myPcapEntity.GetNamePrefix()
```

### `GetNamePostfix()`
Returns the postfix of the entity's name, if the name contains a "-" separator.

**Returns:**

* (string): The postfix of the entity name, or the entire name if no "-" separator is found.

**Example:**

```js
local postfix = myPcapEntity.GetNamePostfix()
```

### `CreateAABB(stat)`
Returns a specific face of the entity's oriented bounding box (AABB) as a vector. **This is required for `GetAABB`**

**Parameters:**

* `stat` (number): An index indicating which face of the AABB to return (0 for min bounds, 7 for max bounds, 4 for center).

**Returns:**

* (Vector): The vector representing the specified face of the AABB.

**Example:**

```js
local minBounds = myPcapEntity.CreateAABB(0) // Get the minimum bounds of the AABB
```

### `getBBoxPoints()`
Returns an array of vectors representing the 8 vertices of the entity's axis-aligned bounding box (AABB). **This is required for `CreateAABB`**

**Returns:**

* (array): An array of 8 Vectors, each representing a vertex of the AABB.

**Example:**

```js
local vertices = myPcapEntity.getBBoxPoints() // Get the vertices of the AABB
```

### `getBBoxFaces()`
This method retrieves the faces of an entity's bounding box as an array of triangle vertices. It is used to access and work with the individual triangular faces that make up the bounding box.

**Returns:**

* (array): An array of 12 Vector triplets, where each triplet represents the three vertices of a triangle face.

**Example:**

```js
local myEntity = entLib.FindByClassname("prop_physics")
local faces = myEntity.getBBoxFaces()

// Iterate over the faces and print the vertices of each triangle
foreach(i, face in faces ) {
    printl("Face", i, ":")
    foreach(j, vertex in face.vertices) {
        printl(" Vertex", j, ":", vertex)
    }
}
```
