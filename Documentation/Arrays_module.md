# PCapture-ArrayLib

Enhanced arrays module.

## Class arrayLib

### new(...)

Create a new arrayLib instance from arguments.

```
local arr = arrayLib.new(1, 2, 3)
```

- `...` (any): The values for the array.
- Returns: The new arrayLib instance.

>Syntax sugar: 
>`local arr = arrayLib([1, 2, 3])`

### append(val)

Append a value to the array.

```
arr.append(4)
arr.append("string")
arr.append({table = "lol"})
```

- `val` (any): The value to append.
- Returns: The new array length.

### apply(func)

Apply a function to each element.

```
arr.apply(function(val) return val * 2)
```

- `func` (function): The function to apply.

### clear()

Clear the array and table.

```
arr.clear()
```

### extend(other)

Extend the array with another array.

```
arr.extend([4, 5, 6])
arr.extend(arrayLib.new(7, 8, 9))
```

- `other` (array|arrayLib): The array to extend from.

### filter(func)

Filter the array by a predicate function.

```
local filteredArray = arr.filter(function(idx, val) return val > 2) // todo
```

- `func` (function(idx, val, newArray)): The predicate function.
- Returns: The filtered array.

### find(match)

Check if the array contains a value.

```
local found = arr.find(3)
```

- `match` (any): The value to find.
- Returns: Whether the value is found.

### search(match)

Search for a value in the array.

```
local idx = arr.search(function(val) return val > 2 end)
```

- `match` (any|function): The value or predicate to search for.
- Returns: The index of the match or null.

### insert(idx, val)

Insert a value into the array.

```
arr.insert(1, "test")
```

- idx (int): The index to insert at.
- val (any): The value to insert.

### len()

Get the array length.

```
local length = arr.len()
```

- Returns: The array length.

### map(func)

Map the array to a new array via a function.

```
local mappedArray = arr.map(function(val) return val * 2 end)
```

- `func` (function): The mapping function.
- Returns: The mapped array.

### pop()

Pop a value off the end of the array.

```
local value = arr.pop()
```

- Returns: The popped value.

### push(val)

Append a value to the array.

```
arr.push("I love Nullpoint Crisis!")
```

- `val` (any): The value to append.
> **Note:**
> In operation, **push()** is identical to `append()` but provides a more convenient method name for those programmers particularly accustomed to working with stacks.

### remove(idx)

Remove an element by index.

```
arr.remove(1)
```

- idx (int): The index to remove.

### resize(size, fill = null)

Resize the array.

```
arr.resize(5, 0)
```

- `size` (int): The new size.
- `fill` (any, *optional*): The fill value for new slots.

### reverse()

Reverse the array in-place.

```
arr.reverse()
```

- Returns: The reversed array.

### slice(start, end = null)

Creates a new sub-array from an array

```
local anArray = arrayLib.new("one", "two", "three", "four", "five", "six", "seven", "eight", "nine")
local newArray = anArray.slice(1, 3) // Output: ["three", "four", "five", "six"]
```

- `start` (int): The start index.
- `end` (int, *optional*): The end index.
- Returns: The sliced array.

### sort(func = null)

Sort the array.

```
arr.sort()
```

- `func` (function, *optional*): *optional* compare function.
- Returns: The sorted array.

### top()

Get the last element.

```
local lastElement = arr.top()
```

- Returns: The last element.

### join(joinstr = "")

Join the array into a string.

```
local anArray = arrayLib.new("one", "two", "three")
local joinedString = anArray.join(", ") // Output: "one, two, three"
anArray.join(" -> ") // Output: "one -> two -> three"
```

- `joinstr` (string, *optional*): The separator string.
- Returns: The joined string.

### Clone()

Returns a clone of the array

```
local arr1 = arrayLib.new(1,2,3)
local arr2 = arr1 // Not cloning, but assigning a link/pointer
printl(arr1 == arr2) // Outputs: "true"

local arr3 = arr1.Clone()
printl(arr1 == arr3) // Outputs: "false"

arr3.append(4)
printl(arr1) // Outputs: "Array: [1, 2, 3]"
printl(arr3) // Outputs: "Array: [1, 2, 3, 4]"
```

- Returns: Full clone of your array


### get(idx, defaultVal = null)

Retrieve the element at the specified index in the array.

```
local element = arr.get(0)
```

- `idx` (integer): The index of the element to retrieve.
- `defaultVal` (any, *optional*): *optional* default value to return if the index is out of bounds. Defaults to null.
- Returns: The element at the specified index or the default value if the index is out of bounds.

### totable(recreate = false)

Convert the array to a table.

```
local anArray = arrayLib.new("one", "two", "three")
local table = anArray.totable() // Output: {one = null, two = null, three = null}
```

- `recreate` (boolean, *optional*): Whether to recreate the table.
- Returns: The table representation.